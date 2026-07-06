package widestress

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"golang.org/x/time/rate"
)

// Config controls wide-stress load generation.
type Config struct {
	DSN        string
	Table      string
	StartID    int64
	Rate       int
	Workers    int
	BatchSize  int
	SparseProb float64
	Duration   time.Duration
	MaxRows    int64
	ReportEvery time.Duration
}

// Stats holds runtime counters.
type Stats struct {
	Inserted uint64
	Errors   uint64
	Batches  uint64
}

// Run executes the load test until duration/row limit or context cancel.
func Run(ctx context.Context, cfg Config) (Stats, error) {
	if cfg.Rate <= 0 {
		return Stats{}, fmt.Errorf("rate must be positive")
	}
	if cfg.Workers <= 0 {
		cfg.Workers = 1
	}
	if cfg.BatchSize <= 0 {
		cfg.BatchSize = 20
	}
	if cfg.Table == "" {
		cfg.Table = "widecol_test_wide"
	}
	if cfg.ReportEvery <= 0 {
		cfg.ReportEvery = 10 * time.Second
	}
	if cfg.SparseProb <= 0 {
		cfg.SparseProb = 0.05
	}

	cols := ColumnNames()
	insertSQL := buildInsertSQL(cfg.Table, cols, cfg.BatchSize)

	db, err := sql.Open("mysql", cfg.DSN)
	if err != nil {
		return Stats{}, fmt.Errorf("open db: %w", err)
	}
	defer db.Close()

	db.SetMaxOpenConns(cfg.Workers)
	db.SetMaxIdleConns(cfg.Workers)

	if err := db.PingContext(ctx); err != nil {
		return Stats{}, fmt.Errorf("ping db: %w", err)
	}

	var nextID atomic.Int64
	nextID.Store(cfg.StartID)

	var inserted atomic.Uint64
	var errors atomic.Uint64
	var batches atomic.Uint64

	limiter := rate.NewLimiter(rate.Limit(cfg.Rate), cfg.BatchSize)
	stopReason := make(chan error, 1)

	runCtx, cancel := context.WithCancel(ctx)
	defer cancel()

	if cfg.Duration > 0 {
		go func() {
			timer := time.NewTimer(cfg.Duration)
			defer timer.Stop()
			select {
			case <-runCtx.Done():
			case <-timer.C:
				stopReason <- nil
				cancel()
			}
		}()
	}

	go reportLoop(runCtx, cfg.ReportEvery, &inserted, &errors, cfg.Rate)

	var wg sync.WaitGroup
	for w := 0; w < cfg.Workers; w++ {
		wg.Add(1)
		gen := NewGenerator(int64(42+w), cfg.SparseProb)
		go func(workerID int) {
			defer wg.Done()
			for {
				if runCtx.Err() != nil {
					return
				}
				if cfg.MaxRows > 0 && int64(inserted.Load()) >= cfg.MaxRows {
					cancel()
					return
				}

				if cfg.MaxRows > 0 {
					remaining := cfg.MaxRows - int64(inserted.Load())
					if remaining <= 0 {
						cancel()
						return
					}
					if int(remaining) < cfg.BatchSize {
						batch := make([]RowValues, 0, remaining)
						for i := int64(0); i < remaining; i++ {
							id := nextID.Add(1) - 1
							batch = append(batch, gen.NextRow(id))
						}
						if err := limiter.WaitN(runCtx, len(batch)); err != nil {
							return
						}
						args := flattenBatch(batch)
						if _, err := db.ExecContext(runCtx, buildInsertSQL(cfg.Table, cols, len(batch)), args...); err != nil {
							errors.Add(1)
							select {
							case stopReason <- fmt.Errorf("worker %d exec: %w", workerID, err):
							default:
							}
							cancel()
							return
						}
						inserted.Add(uint64(len(batch)))
						batches.Add(1)
						cancel()
						return
					}
				}

				batch := make([]RowValues, 0, cfg.BatchSize)
				for len(batch) < cfg.BatchSize {
					id := nextID.Add(1) - 1
					batch = append(batch, gen.NextRow(id))
				}

				if err := limiter.WaitN(runCtx, len(batch)); err != nil {
					return
				}

				args := flattenBatch(batch)
				if _, err := db.ExecContext(runCtx, insertSQL, args...); err != nil {
					errors.Add(1)
					select {
					case stopReason <- fmt.Errorf("worker %d exec: %w", workerID, err):
					default:
					}
					cancel()
					return
				}
				inserted.Add(uint64(len(batch)))
				batches.Add(1)
			}
		}(w)
	}

	wg.Wait()

	stats := Stats{
		Inserted: inserted.Load(),
		Errors:   errors.Load(),
		Batches:  batches.Load(),
	}

	select {
	case err := <-stopReason:
		if err != nil {
			return stats, err
		}
	default:
	}

	if runCtx.Err() != nil && runCtx.Err() != context.Canceled {
		return stats, runCtx.Err()
	}
	return stats, nil
}

func buildInsertSQL(table string, cols []string, batchSize int) string {
	quotedCols := make([]string, len(cols))
	for i, c := range cols {
		quotedCols[i] = "`" + c + "`"
	}
	placeholder := "(" + strings.Repeat("?,", len(cols)-1) + "?)"
	placeholders := make([]string, batchSize)
	for i := range placeholders {
		placeholders[i] = placeholder
	}
	return fmt.Sprintf(
		"INSERT INTO `%s` (%s) VALUES %s",
		table,
		strings.Join(quotedCols, ","),
		strings.Join(placeholders, ","),
	)
}

func flattenBatch(batch []RowValues) []any {
	args := make([]any, 0, len(batch)*len(batch[0]))
	for _, row := range batch {
		args = append(args, row...)
	}
	return args
}

func reportLoop(ctx context.Context, every time.Duration, inserted, errors *atomic.Uint64, targetRate int) {
	ticker := time.NewTicker(every)
	defer ticker.Stop()

	var lastInserted uint64
	lastAt := time.Now()

	for {
		select {
		case <-ctx.Done():
			return
		case now := <-ticker.C:
			cur := inserted.Load()
			delta := cur - lastInserted
			elapsed := now.Sub(lastAt).Seconds()
			actualRate := float64(delta) / elapsed
			fmt.Printf(
				"[wide-stress] inserted=%d errors=%d rate=%.1f rows/s (target=%d)\n",
				cur, errors.Load(), actualRate, targetRate,
			)
			lastInserted = cur
			lastAt = now
		}
	}
}

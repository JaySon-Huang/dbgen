package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"jaysonhuang.com/widestress"
)

func main() {
	var (
		dsn         = flag.String("dsn", "root:@tcp(10.2.12.81:8030)/widecol", "MySQL DSN")
		table       = flag.String("table", "widecol_test_wide", "Target table name")
		startID     = flag.Int64("start-id", 155000001, "First w_id to insert")
		rate        = flag.Int("rate", 1000, "Target insert rate in rows per second")
		workers     = flag.Int("workers", 4, "Number of concurrent insert workers")
		batchSize   = flag.Int("batch-size", 20, "Rows per INSERT statement")
		sparseProb  = flag.Float64("sparse-prob", 0.05, "Probability a nullable column is non-NULL")
		duration    = flag.Duration("duration", 0, "Run duration (0 = until interrupted)")
		maxRows     = flag.Int64("max-rows", 0, "Stop after inserting this many rows (0 = unlimited)")
		reportEvery = flag.Duration("report-every", 10*time.Second, "Progress report interval")
	)
	flag.Parse()

	if *rate <= 0 {
		fmt.Fprintln(os.Stderr, "rate must be positive")
		os.Exit(2)
	}

	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	cfg := widestress.Config{
		DSN:         *dsn,
		Table:       *table,
		StartID:     *startID,
		Rate:        *rate,
		Workers:     *workers,
		BatchSize:   *batchSize,
		SparseProb:  *sparseProb,
		Duration:    *duration,
		MaxRows:     *maxRows,
		ReportEvery: *reportEvery,
	}

	fmt.Printf("wide-stress starting: table=%s start-id=%d rate=%d workers=%d batch=%d sparse=%.2f\n",
		cfg.Table, cfg.StartID, cfg.Rate, cfg.Workers, cfg.BatchSize, cfg.SparseProb)
	if cfg.Duration > 0 {
		fmt.Printf("duration=%s\n", cfg.Duration)
	}
	if cfg.MaxRows > 0 {
		fmt.Printf("max-rows=%d\n", cfg.MaxRows)
	}

	start := time.Now()
	stats, err := widestress.Run(ctx, cfg)
	elapsed := time.Since(start).Seconds()

	fmt.Printf("done: inserted=%d batches=%d errors=%d elapsed=%.1fs avg=%.1f rows/s\n",
		stats.Inserted, stats.Batches, stats.Errors, elapsed, float64(stats.Inserted)/elapsed)
	if err != nil {
		fmt.Fprintf(os.Stderr, "wide-stress failed: %v\n", err)
		os.Exit(1)
	}
}

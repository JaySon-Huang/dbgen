package main

import (
	"bufio"
	"context"
	"database/sql"
	"fmt"
	"os"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage:", os.Args[0], "<input_file> <worker_count>")
		return
	}

	inputFile := os.Args[1]
	workerCount := 0
	if _, err := fmt.Sscan(os.Args[2], &workerCount); err != nil || workerCount <= 0 {
		fmt.Println("Invalid worker count. Must be a positive integer")
		return
	}

	file, err := os.Open(inputFile)
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer file.Close()

	db, err := sql.Open("mysql", "root:@tcp(10.2.12.81:8030)/widecol")
	if err != nil {
		fmt.Println("Error connecting to database:", err)
		return
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		fmt.Println("Database connection failed:", err)
		return
	}

	// 创建上下文用于取消操作
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// 创建带缓冲的任务通道
	jobs := make(chan string, 100)
	errCh := make(chan error, 1)
	var wg sync.WaitGroup
	var successCount uint32

	// 启动工作线程
	for i := 0; i < workerCount; i++ {
		wg.Add(1)
		go worker(ctx, &wg, db, jobs, errCh, &successCount)
	}

	// 启动进度报告器
	go progressReporter(ctx, &successCount)

	// 读取文件并分发任务
	go func() {
		defer close(jobs)
		scanner := bufio.NewScanner(file)
		var sqlBuilder strings.Builder
		lineCount := 0

		for scanner.Scan() {
			line := scanner.Text()
			lineCount++
			sqlBuilder.WriteString(line)

			// 每两行组成一个SQL语句
			if lineCount%2 == 0 {
				select {
				case jobs <- sqlBuilder.String():
				case <-ctx.Done():
					return
				}
				sqlBuilder.Reset()
			} else {
				sqlBuilder.WriteString("\n")
			}
		}

		// 处理可能的奇数行
		if sqlBuilder.Len() > 0 {
			fmt.Println("Warning: Ignored incomplete SQL statement at end of file")
		}

		if err := scanner.Err(); err != nil {
			select {
			case errCh <- fmt.Errorf("file read error: %w", err):
			default:
			}
		}
		fmt.Println("File reading completed. Total lines processed:", lineCount)
	}()

	fmt.Println("Waiting for workers to finish...")
	completionCh := make(chan struct{})
	go func() {
		wg.Wait()           // 等待所有worker完成
		close(completionCh) // 通知主goroutine
	}()

	select {
	case err := <-errCh:
		cancel() // cancel the context to stop workers
		fmt.Println("\nExecution stopped due to error:", err)
	case <-completionCh:
		fmt.Println("\nAll workers completed execution")
		cancel() // cancel the context to stop progress reporter
	}

	fmt.Printf("\nTotal executed: %d SQL statements\n", atomic.LoadUint32(&successCount))
}

func worker(ctx context.Context, wg *sync.WaitGroup, db *sql.DB, jobs <-chan string, errCh chan<- error, count *uint32) {
	defer wg.Done()
WORKER_LOOP:
	for {
		select {
		case <-ctx.Done():
			break WORKER_LOOP
		case sql, ok := <-jobs:
			if !ok {
				break WORKER_LOOP
			}
			// 执行SQL语句
			_, err := db.ExecContext(ctx, sql)
			if err != nil {
				// only send the first error
				select {
				case errCh <- fmt.Errorf("SQL execution error: %v\nStatement: %s", err, sql):
				default:
				}
				return
			}
			atomic.AddUint32(count, 1)
		}
	}
	fmt.Println("Worker finished execution")
}

func progressReporter(ctx context.Context, count *uint32) {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()

	for {
		select {
		case <-ticker.C:
			current := atomic.LoadUint32(count)
			fmt.Printf("Executed: %d SQL statements\n", current)
		case <-ctx.Done():
			fmt.Println() // 确保最后的状态在新行显示
			return
		}
	}
}

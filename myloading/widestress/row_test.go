package widestress

import (
	"testing"
)

func TestColumnCount(t *testing.T) {
	if got := len(ColumnNames()); got != 500 {
		t.Fatalf("column count = %d, want 500", got)
	}
}

func TestRowShape(t *testing.T) {
	g := NewGenerator(1, 0.05)
	row := g.NextRow(42)
	if len(row) != 500 {
		t.Fatalf("row len = %d, want 500", len(row))
	}
	if row[0] != int64(42) {
		t.Fatalf("w_id = %v", row[0])
	}
}

func TestSparseProbability(t *testing.T) {
	const (
		samples    = 20000
		sparseProb = 0.05
		tolerance  = 0.01
	)
	g := NewGenerator(99, sparseProb)
	var nonNull int
	// sparse columns start at index 12.
	for i := 0; i < samples; i++ {
		row := g.NextRow(int64(i))
		for _, v := range row[12:] {
			if v != nil {
				nonNull++
			}
		}
	}
	got := float64(nonNull) / float64(samples*490)
	if got < sparseProb-tolerance || got > sparseProb+tolerance {
		t.Fatalf("non-null ratio = %.4f, want ~%.2f", got, sparseProb)
	}
}

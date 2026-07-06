package widestress

import (
	"fmt"
	"math/rand"
)

const (
	decCols = 10
	intCols = 290
	strCols = 190
)

// RowValues holds one row in column order (500 values). Nil means SQL NULL.
type RowValues []any

// Generator produces rows matching tbl_wide.sql distributions.
type Generator struct {
	rng        *rand.Rand
	sparseProb float64
}

func NewGenerator(seed int64, sparseProb float64) *Generator {
	return &Generator{
		rng:        rand.New(rand.NewSource(seed)),
		sparseProb: sparseProb,
	}
}

func (g *Generator) NextRow(wID int64) RowValues {
	row := make(RowValues, 0, 500)
	row = append(row,
		wID,
		"300000.00",
		fmt.Sprintf("%.4f", float64(g.rng.Intn(2001))/10000.0),
		g.randAlphaNum(6, 10),
		g.randAlphaNum(10, 20),
		g.randAlphaNum(10, 20),
		g.randAlphaNum(10, 20),
		g.randAlphaNum(10, 20),
		g.randUpperAlpha(2),
		fmt.Sprintf("%04d11111", g.rng.Intn(10000)),
	)
	for i := 0; i < decCols; i++ {
		row = append(row, g.maybeDecimal())
	}
	for i := 0; i < intCols; i++ {
		row = append(row, g.maybeInt())
	}
	for i := 0; i < strCols; i++ {
		row = append(row, g.maybeString())
	}
	return row
}

func (g *Generator) maybeDecimal() any {
	if g.rng.Float64() >= g.sparseProb {
		return nil
	}
	return fmt.Sprintf("%.2f", float64(g.rng.Intn(200001))/10000.0)
}

func (g *Generator) maybeInt() any {
	if g.rng.Float64() >= g.sparseProb {
		return nil
	}
	return g.rng.Intn(10000001)
}

func (g *Generator) maybeString() any {
	if g.rng.Float64() >= g.sparseProb {
		return nil
	}
	return g.randAlphaNum(185, 195)
}

func (g *Generator) randAlphaNum(minLen, maxLen int) string {
	const alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	n := minLen
	if maxLen > minLen {
		n += g.rng.Intn(maxLen - minLen + 1)
	}
	b := make([]byte, n)
	for i := range b {
		b[i] = alphabet[g.rng.Intn(len(alphabet))]
	}
	return string(b)
}

func (g *Generator) randUpperAlpha(n int) string {
	const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	b := make([]byte, n)
	for i := range b {
		b[i] = alphabet[g.rng.Intn(len(alphabet))]
	}
	return string(b)
}

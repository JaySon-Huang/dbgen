package widestress

import "fmt"

// ColumnNames returns all 500 columns in table order.
func ColumnNames() []string {
	cols := []string{
		"w_id", "w_ytd", "w_tax", "w_name",
		"w_street_1", "w_street_2", "w_street_3", "w_city", "w_state", "w_zip",
	}
	for i := 0; i < 10; i++ {
		cols = append(cols, fmt.Sprintf("r_dec%03d", i))
	}
	for i := 0; i < 290; i++ {
		cols = append(cols, fmt.Sprintf("r_int%03d", i))
	}
	for i := 0; i < 190; i++ {
		cols = append(cols, fmt.Sprintf("r_str%03d", i))
	}
	return cols
}

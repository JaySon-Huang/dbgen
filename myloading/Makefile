load2db:
	mkdir -p bin
	go build -o bin/load2db .

wide-stress:
	mkdir -p bin
	go build -o bin/wide-stress ./cmd/wide-stress

test:
	go test ./...

# CSV output goes to mock_data_csv; schema is still emitted as .sql
# -N 300M: pilot_csv shows ~1773 bytes/row, ~494 GiB total
gen:
	../target/release/dbgen -i ../tbl.sql -o ../mock_data_csv -N 300M -R 200k -f csv --headers -j $(shell nproc)

# Keep SQL generation available if needed
gen-sql:
	../target/release/dbgen -i ../tbl.sql -o ../mock_data -N 165M -R 200k -j $(shell nproc)

# widecol_test_wide: 190 str + 290 int; pilot ~3465 bytes/row
gen-wide:
	../target/release/dbgen -i ../tbl_wide.sql -o ../mock_data_wide -N 152M -R 200k -f csv --headers -j $(shell nproc)

# ~50 GiB wide table CSV (pilot: ~3465 bytes/row -> ~16.4M rows, ~82 files)
gen-wide-50g:
	../target/release/dbgen -i ../tbl_wide.sql -o ../mock_data_wide -N 16.4M -R 200k -f csv --headers -j $(shell nproc)

load2db:
	mkdir -p bin
	go build -o bin/load2db

gen:
	../target/release/dbgen -i ../tbl.sql -o ../mock_data -N 165M -R 200k -j $(shell nproc)

#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <generated-output-directory>" >&2
    exit 2
fi

out_dir=$1
metadata=${out_dir}/generation.env

if ! command -v zstd >/dev/null 2>&1; then
    echo "zstd is required to validate compressed CSV files." >&2
    exit 1
fi

if [[ ! -f "${metadata}" ]]; then
    echo "Missing generation metadata: ${metadata}" >&2
    exit 1
fi

expected_rows=$(awk -F= '$1 == "total_rows" { print $2 }' "${metadata}")
if [[ -z "${expected_rows}" ]]; then
    echo "total_rows is missing from ${metadata}" >&2
    exit 1
fi

shopt -s nullglob
data_files=("${out_dir}"/bc_bet_records_213*.csv.zst)
shopt -u nullglob
if [[ ${#data_files[@]} -eq 0 ]]; then
    echo "No compressed CSV files found in ${out_dir}" >&2
    exit 1
fi

echo "Validating ${#data_files[@]} files; this streams the complete data set."

zstd -q -dc "${data_files[@]}" | awk -F, -v expected_rows="${expected_rows}" '
    {
        rows++
        if (NF != 45) {
            bad_column_rows++
        }
    }
    $21 == "2100-01-01 00:00:00" {
        sentinel++
        if ($23 != 1 || $45 != "\"2100-01-01\"") {
            bad_sentinel_rows++
        }
    }
    $21 != "2100-01-01 00:00:00" {
        if (normal_min == "" || $21 < normal_min) {
            normal_min = $21
        }
        if ($21 > normal_max) {
            normal_max = $21
        }
    }
    $6 == 5 && $23 == 2 &&
        $21 >= "2026-07-14 21:00:00" && $21 <= "2026-07-15 23:59:59" &&
        $7 == "\"213\"" && $35 == "\"CNY\"" {
        benchmark_matches++
    }
    END {
        print "rows=" rows
        print "sentinel_rows=" sentinel + 0
        print "bad_column_rows=" bad_column_rows + 0
        print "bad_sentinel_rows=" bad_sentinel_rows + 0
        print "normal_time_min=" normal_min
        print "normal_time_max=" normal_max
        print "benchmark_query_matches=" benchmark_matches + 0

        if (rows != expected_rows || bad_column_rows != 0 || bad_sentinel_rows != 0) {
            exit 1
        }
    }
'

#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 <1m|500m> [output-directory]" >&2
    echo "Environment: DBGEN_BIN=<path> JOBS=<n> SENTINEL_PROBABILITY=<p>" >&2
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
    exit 2
fi

profile=$1
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd "${script_dir}/../.." && pwd)

case "${profile}" in
    1m)
        total_rows=1000000
        rows_per_file=250000
        default_jobs=4
        target_file_size=256MiB
        ;;
    500m)
        total_rows=500000000
        rows_per_file=5000000
        default_jobs=16
        target_file_size=512MiB
        ;;
    *)
        usage
        exit 2
        ;;
esac

out_dir=${2:-"${script_dir}/out/${profile}"}
jobs=${JOBS:-${default_jobs}}
sentinel_probability=${SENTINEL_PROBABILITY:-0.0001}
seed=19f60afd4e07102a1ecb98fdf1d3b3e019f60afd4e07102a1ecb98fdf1d3b3e0
template=${script_dir}/bc_bet_records_213.template.sql

if [[ -e "${out_dir}" ]] && [[ -n "$(find "${out_dir}" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    echo "Output directory is not empty: ${out_dir}" >&2
    echo "Choose another directory or remove the old generated data explicitly." >&2
    exit 1
fi

if [[ -n "${DBGEN_BIN:-}" ]]; then
    dbgen_bin=${DBGEN_BIN}
elif [[ -x "${repo_root}/target/release/dbgen" ]]; then
    dbgen_bin=${repo_root}/target/release/dbgen
elif command -v dbgen >/dev/null 2>&1; then
    dbgen_bin=$(command -v dbgen)
else
    echo "Building release dbgen binary..."
    cargo build --release --bin dbgen --manifest-path "${repo_root}/Cargo.toml"
    dbgen_bin=${repo_root}/target/release/dbgen
fi

mkdir -p "${out_dir}"

echo "Generating ${total_rows} rows into ${out_dir}"
echo "dbgen=${dbgen_bin} jobs=${jobs} rows_per_file=${rows_per_file} sentinel_probability=${sentinel_probability}"

"${dbgen_bin}" \
    --template "${template}" \
    --out-dir "${out_dir}" \
    --total-count "${total_rows}" \
    --rows-per-file "${rows_per_file}" \
    --rows-count 10000 \
    --jobs "${jobs}" \
    --format csv \
    --compression gzip \
    --compress-level 1 \
    --size "${target_file_size}" \
    --seed "${seed}" \
    --now '2026-07-15 23:59:59.000' \
    --components table,data \
    --initialize "@dataset_rows := ${total_rows}" \
    --initialize "@sentinel_probability := ${sentinel_probability}"

schema_file=${out_dir}/bc_bet_records_213-schema.sql
data_file_count=$(find "${out_dir}" -maxdepth 1 -name 'bc_bet_records_213*.csv.gz' -print | wc -l | tr -d ' ')
if [[ ! -s "${schema_file}" || "${data_file_count}" -eq 0 ]]; then
    echo "Generation did not produce the expected schema and CSV files." >&2
    exit 1
fi

{
    echo "profile=${profile}"
    echo "total_rows=${total_rows}"
    echo "rows_per_file=${rows_per_file}"
    echo "jobs=${jobs}"
    echo "target_file_size=${target_file_size}"
    echo "sentinel_probability=${sentinel_probability}"
    echo "seed=${seed}"
    echo "normal_time_start_utc=2026-04-17 00:00:00"
    echo "normal_time_end_utc=2026-07-15 23:59:59"
} > "${out_dir}/generation.env"

echo "Done. Generated ${data_file_count} compressed CSV data files."
echo "Metadata: ${out_dir}/generation.env"

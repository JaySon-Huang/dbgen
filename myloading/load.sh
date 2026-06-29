#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
MOCK="../mock_data"

for file_path in "$MOCK"/widecol.widecol_test.[0-9]*.sql; do
    [[ "$file_path" == *schema* ]] && continue
    [[ -f "$file_path" ]] || continue

    echo "Processing file: $file_path"
    ./bin/load2db "$file_path" 10
    echo "Successfully processed $file_path"
done

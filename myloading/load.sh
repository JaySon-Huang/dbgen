#set -x
for i in {0..50};do
    file_path="../mock_data/widecol.widecol_test.${i}.sql"
  
    if [ -f "$file_path" ]; then
        echo "Processing file: $file_path"
      
        ./bin/load2db "$file_path" 10
      
        if [ $? -eq 0 ]; then
            echo "Successfully processed $file_path"
        else
            echo "Failed to process $file_path"
        fi
    else
        echo "File not found: $file_path"
    fi
done

#!/usr/bin/env bash
# apply_sql_scripts.sh

# find and sort SQL files
sql_files=$(find "SQL" -maxdepth 1 -type f -name "*.sql" | sort)

# apply each SQL file to the database
for sql_file in $sql_files; do
    echo "Applying: $sql_file"
    mariadb --port="3306" --user="root" --password="root" "anastasia_gamedb" < "$sql_file"
    # failure? log and exit
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to apply $sql_file"
        exit 1
    fi
done

echo "All SQL scripts applied successfully."
exit 0

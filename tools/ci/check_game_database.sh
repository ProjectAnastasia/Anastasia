#!/usr/bin/env bash
# check_game_database.sh

# global error flag
error_flag=0

# helper: error if the query result is NOT empty
expect_empty() {
    local sql_query="$1"
    local query_result="$2"

    if [[ -n "$query_result" ]]; then
        echo "ERROR: Query result is not empty, but was expected to be empty."
        echo "SQL Query: $sql_query"
        echo "Query Result: $query_result"
        error_flag=1
    fi
}

# helper: error if the query result IS empty
expect_not_empty() {
    local sql_query="$1"
    local query_result="$2"

    if [[ -z "$query_result" ]]; then
        echo "ERROR: Query result is empty, but was expected to contain rows."
        echo "SQL Query: $sql_query"
        echo "Query Result: $query_result"
        error_flag=1
    fi
}

# helper: run the query against the database
    # --host="${DB_HOST:-127.0.0.1}" \
query() {
    local sql_query="$1"
    mariadb --batch --skip-column-names \
    --user="root" \
    --password="root" \
    "anastasia_gamedb" \
    -e "$sql_query"
}

# run some QA queries against the database
query_text="select table_name, engine from information_schema.tables where table_schema = 'anastasia_gamedb' and engine <> 'MInnoDB';";
query_result=$(query "$query_text")
expect_empty "$query_text" "$query_result"

# exit with error if any check failed
if [[ $error_flag -ne 0 ]]; then
  echo "One or more checks failed."
  exit 1
fi

# exit with success if all the checks passed
echo "All checks passed."
exit 0

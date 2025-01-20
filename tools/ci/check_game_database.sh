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
        echo "Query Result:\n $query_result"
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
        echo "Query Result:\n $query_result"
        error_flag=1
    fi
}

# # helper: run the query against the database
# query() {
#     local sql_query="$1"
#     mariadb \
#     --batch \
#     --password="root" \
#     --port="3306" \
#     --skip-column-names \
#     --user="root" \
#     "anastasia_gamedb" \
#     -e "$sql_query"
# }

query() {
    local sql_query="$1"
    local result

    result=$(mariadb \
        --batch \
        --password="root" \
        --port="3306" \
        --skip-column-names \
        --user="root" \
        "anastasia_gamedb" \
        -e "$sql_query" 2>&1)

    local exit_code=$?

    # set error_flag if the query fails
    if [[ $exit_code -ne 0 ]]; then
        error_flag=1
    fi

    echo "$result"

    return $exit_code
}

# run some QA queries against the database

# Ensure the database has the proper text encoding and collation set
query_text="select schema_name, default_character_set_name, default_collation_name from information_schema.schemata where schema_name = 'anastasia_gamedb' and (default_character_set_name <> 'utf8mb4' or default_collation_name <> 'utf8mb4_uca1400_ai_ci');";
query_result=$(query "$query_text")
expect_empty "$query_text" "$query_result"

# Ensure no tables have text encoding or collation set
query_text="select table_name, table_collation, ccsa.character_set_name from information_schema.tables as t join information_schema.collation_character_set_applicability as ccsa on t.table_collation = ccsa.collation_name where t.table_schema = 'anastasia_gamedb';";
query_result=$(query "$query_text")
expect_empty "$query_text" "$query_result"

# Ensure all columns have the proper text encoding and collation set
query_text="select table_name, column_name, character_set_name, collation_name from information_schema.columns where table_schema = 'anastasia_gamedb' and ((character_set_name is not null and character_set_name <> 'utf8mb4') or (collation_name is not null and collation_name <> 'utf8mb4_uca1400_ai_ci');";
query_result=$(query "$query_text")
expect_empty "$query_text" "$query_result"

# Ensure all tables are using the InnoDB engine
query_text="select table_name, engine from information_schema.tables where table_schema = 'anastasia_gamedb' and engine <> 'InnoDB';";
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

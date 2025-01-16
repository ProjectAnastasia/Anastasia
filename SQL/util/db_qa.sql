-- db_qa.sql

-- Each of these queries should return 0 rows.
-- If they return more than 0 rows, something is misconfigured.

-- Ensure the database has the proper text encoding and collation set
SELECT SCHEMA_NAME, DEFAULT_CHARACTER_SET_NAME, DEFAULT_COLLATION_NAME
FROM information_schema.SCHEMATA
WHERE SCHEMA_NAME = 'anastasia_gamedb'
  AND (DEFAULT_CHARACTER_SET_NAME <> 'utf8mb4' OR DEFAULT_COLLATION_NAME <> 'utf8mb4_uca1400_ai_ci');

-- Ensure no tables have text encoding or collation set
SELECT TABLE_NAME, TABLE_COLLATION, CCSA.CHARACTER_SET_NAME
FROM information_schema.TABLES AS T
JOIN information_schema.COLLATION_CHARACTER_SET_APPLICABILITY AS CCSA
  ON T.TABLE_COLLATION = CCSA.COLLATION_NAME
WHERE T.TABLE_SCHEMA = 'anastasia_gamedb';

-- Ensure all columns have the proper text encoding and collation set
SELECT TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'anastasia_gamedb'
  AND (
       (CHARACTER_SET_NAME IS NOT NULL AND CHARACTER_SET_NAME <> 'utf8mb4')
    OR (COLLATION_NAME IS NOT NULL AND COLLATION_NAME <> 'utf8mb4_uca1400_ai_ci')
);

-- Ensure all tables are using the InnoDB engine
SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'anastasia_gamedb'
  AND ENGINE <> 'InnoDB';

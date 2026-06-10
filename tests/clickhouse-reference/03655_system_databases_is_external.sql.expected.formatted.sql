-- Tags: no-fasttest
-- - no-fasttest -- no SQLite
SET allow_deprecated_database_ordinary = '1';

-- Suppress "Server has databases (for example `X`) with Ordinary engine, which was deprecated."
SET send_logs_level = 'error';

CREATE DATABASE CLICKHOUSE_DATABASE_1
ENGINE = Ordinary();

SELECT
    engine,
    is_external
FROM `system`.databases
WHERE name = 'placeholder';

DROP DATABASE CLICKHOUSE_DATABASE_1 SYNC;

CREATE DATABASE CLICKHOUSE_DATABASE_1
ENGINE = Atomic();

CREATE DATABASE CLICKHOUSE_DATABASE_1
ENGINE = Memory();

CREATE DATABASE CLICKHOUSE_DATABASE_1
ENGINE = Replicated('/test/{database}/rdb', 's1', 'r1');

CREATE DATABASE CLICKHOUSE_DATABASE_1
ENGINE = SQLite('placeholder');
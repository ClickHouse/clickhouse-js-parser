--- See also tests/queries/0_stateless/01581_deduplicate_by_columns_replicated.sql
--- local case
-- Just in case if previous tests run left some stuff behind.
DROP TABLE IF EXISTS source_data;

CREATE TABLE source_data
(
    pk Int32,
    sk Int32,
    val UInt32,
    partition_key UInt32 DEFAULT 1,
    PRIMARY KEY(pk)
)
ENGINE = MergeTree()
ORDER BY (pk, sk);

INSERT INTO source_data (pk, sk, val);

SELECT
    'TOTAL rows',
    count()
FROM source_data;

DROP TABLE IF EXISTS full_duplicates;

-- table with duplicates on MATERIALIZED columns
CREATE TABLE full_duplicates
(
    pk Int32,
    sk Int32,
    val UInt32,
    partition_key UInt32,
    mat UInt32 MATERIALIZED 12345,
    alias UInt32 ALIAS 2,
    PRIMARY KEY(pk)
)
ENGINE = MergeTree()
ORDER BY (pk, toString(sk * 10))
PARTITION BY partition_key + 1; -- silly order key to ensure that key column is checked even when it is a part of expression. See [1] below.

-- ERROR cases
OPTIMIZE TABLE full_duplicates DEDUPLICATE BY pk, sk, val, mat, alias; -- { serverError NO_SUCH_COLUMN_IN_TABLE } -- alias column is present

OPTIMIZE TABLE full_duplicates DEDUPLICATE BY sk, val; -- { serverError THERE_IS_NO_COLUMN } -- primary key column is missing

OPTIMIZE TABLE full_duplicates DEDUPLICATE BY * EXCEPT (pk, sk, val, mat, alias, partition_key); -- { serverError EMPTY_LIST_OF_COLUMNS_QUERIED } -- list is empty

OPTIMIZE TABLE full_duplicates DEDUPLICATE BY * EXCEPT (pk); -- { serverError THERE_IS_NO_COLUMN } -- primary key column is missing [1]

OPTIMIZE TABLE full_duplicates DEDUPLICATE BY * EXCEPT (sk); -- { serverError THERE_IS_NO_COLUMN } -- sorting key column is missing [1]

OPTIMIZE TABLE full_duplicates DEDUPLICATE BY * EXCEPT (partition_key); -- { serverError THERE_IS_NO_COLUMN } -- partitioning column is missing [1]

INSERT INTO full_duplicates SELECT *
FROM source_data;

OPTIMIZE TABLE full_duplicates FINAL DEDUPLICATE;

SELECT *
FROM full_duplicates;

TRUNCATE TABLE full_duplicates;

OPTIMIZE TABLE full_duplicates FINAL DEDUPLICATE BY *;

OPTIMIZE TABLE full_duplicates FINAL DEDUPLICATE BY * EXCEPT (mat);

OPTIMIZE TABLE full_duplicates FINAL DEDUPLICATE BY pk, sk, val, mat, partition_key;

--DROP TABLE full_duplicates;
-- Now to the partial duplicates when MATERIALIZED column alway has unique value.
DROP TABLE IF EXISTS partial_duplicates;

CREATE TABLE partial_duplicates
(
    pk Int32,
    sk Int32,
    val UInt32,
    partition_key UInt32 DEFAULT 1,
    mat UInt32 MATERIALIZED rand(),
    alias UInt32 ALIAS 2,
    PRIMARY KEY(pk)
)
ENGINE = MergeTree()
ORDER BY (pk, sk);

INSERT INTO partial_duplicates SELECT *
FROM source_data;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE;

SELECT count()
FROM partial_duplicates;

TRUNCATE TABLE partial_duplicates;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY pk, sk, val, mat;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY *;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY * EXCEPT (mat);

SELECT *
FROM partial_duplicates;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY COLUMNS('.*') EXCEPT (mat);

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY pk, sk;

OPTIMIZE TABLE partial_duplicates FINAL DEDUPLICATE BY COLUMNS('.*k');

DROP TABLE full_duplicates;

DROP TABLE partial_duplicates;

DROP TABLE source_data;
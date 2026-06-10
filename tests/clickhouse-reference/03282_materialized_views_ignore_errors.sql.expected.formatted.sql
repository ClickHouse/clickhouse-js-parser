-- more blocks to process
SET max_block_size = '10';

SET min_insert_block_size_rows = '10';

DROP TABLE IF EXISTS testX;

DROP TABLE IF EXISTS testXA;

CREATE TABLE testX
(
    A Int64
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY (intDiv(A, 10), throwIf(A = 2));

CREATE MATERIALIZED VIEW testXA
ENGINE = MergeTree()
ORDER BY tuple()
AS
SELECT sleep(0.1)
FROM testX;

-- { echoOn }
INSERT INTO testX SELECT number
FROM numbers(20)
SETTINGS materialized_views_ignore_errors = '0'; -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

SELECT count()
FROM testX;

SELECT count()
FROM testXA;

INSERT INTO testX SELECT number
FROM numbers(20)
SETTINGS materialized_views_ignore_errors = '1'; -- { serverError FUNCTION_THROW_IF_VALUE_IS_NON_ZERO }

-- { echoOff }
DROP TABLE testX;

DROP VIEW testXA;
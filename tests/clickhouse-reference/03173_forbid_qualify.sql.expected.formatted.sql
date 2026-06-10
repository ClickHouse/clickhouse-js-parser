DROP TABLE IF EXISTS test_qualify;

CREATE TABLE test_qualify
(
    number Int64
)
ENGINE = MergeTree()
ORDER BY number;

INSERT INTO test_qualify SELECT *
FROM numbers(100);

SELECT count()
FROM test_qualify; -- 100

SELECT *
FROM test_qualify
QUALIFY row_number() OVER (ORDER BY number ASC) = 50
SETTINGS enable_analyzer = '1'; -- 49

SELECT *
FROM test_qualify
QUALIFY row_number() OVER (ORDER BY number ASC) = 50
SETTINGS enable_analyzer = '0'; -- { serverError NOT_IMPLEMENTED }

DELETE FROM test_qualify WHERE number IN (
    SELECT number
    FROM test_qualify
    QUALIFY row_number() OVER (ORDER BY number ASC) = 50
) SETTINGS validate_mutation_query = '0'; -- { serverError UNFINISHED }
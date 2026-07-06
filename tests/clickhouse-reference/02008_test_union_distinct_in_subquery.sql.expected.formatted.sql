DROP TABLE IF EXISTS test;

CREATE TABLE test
(
    name String,
    uuid UUID
)
ENGINE = Memory();

INSERT INTO test SELECT
    '1',
    '00000000-0000-0000-0000-000000000000';

INSERT INTO test SELECT
    '2',
    '00000000-0000-0000-0000-000000000000';

INSERT INTO test SELECT
    '3',
    '00000000-0000-0000-0000-000000000000';

INSERT INTO test SELECT
    '4',
    '00000000-0000-0000-0000-000000000000';

INSERT INTO test SELECT
    '5',
    '00000000-0000-0000-0000-000000000000';

-- { echo }
SELECT count()
FROM (
        SELECT *
        FROM test
        UNION DISTINCT
        SELECT *
        FROM test
    );

SELECT count()
FROM (
        SELECT *
        FROM test
        UNION DISTINCT
        SELECT *
        FROM test
        UNION ALL
        SELECT *
        FROM test
    );

SELECT count()
FROM (
(        SELECT *
        FROM test
        UNION DISTINCT
        SELECT *
        FROM test)
EXCEPT
        SELECT *
        FROM test
        WHERE name = '3'
    );

SELECT count()
FROM (
((        SELECT *
        FROM test
INTERSECT
(        SELECT *
        FROM test
        WHERE toUInt8(name) < 4))
        UNION DISTINCT
        SELECT *
        FROM test
        WHERE name = '5'
            OR name = '1')
EXCEPT
        SELECT *
        FROM test
        WHERE name = '3'
    );

WITH (
        SELECT count()
        FROM (
(                SELECT *
                FROM test
                UNION DISTINCT
                SELECT *
                FROM test)
EXCEPT
                SELECT *
                FROM test
                WHERE toUInt8(name) > 3
            )
    ) AS max

SELECT count()
FROM (
        SELECT *
        FROM test
        UNION ALL
        SELECT *
        FROM test
        WHERE toUInt8(name) < max
    );

WITH (
        SELECT count()
        FROM (
(                SELECT *
                FROM test
                UNION DISTINCT
                SELECT *
                FROM test)
EXCEPT
                SELECT *
                FROM test
                WHERE toUInt8(name) > 3
            )
    ) AS max

SELECT count()
FROM (
        SELECT *
        FROM test
EXCEPT
        SELECT *
        FROM test
        WHERE toUInt8(name) < max
    );

SELECT uuid
FROM test
UNION DISTINCT
SELECT uuid
FROM test;

SELECT uuid
FROM test
UNION DISTINCT
SELECT uuid
FROM test
UNION ALL
SELECT uuid
FROM test
WHERE name = '1';

SELECT uuid
FROM (
        SELECT *
        FROM test
        UNION DISTINCT
        SELECT *
        FROM test
    );
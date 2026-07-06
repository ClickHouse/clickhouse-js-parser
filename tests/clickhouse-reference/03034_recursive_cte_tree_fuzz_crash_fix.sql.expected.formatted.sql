SET enable_analyzer = '1';

SET enable_global_with_statement = '1';

SET session_timezone = 'Etc/UTC';

DROP TABLE IF EXISTS department__fuzz_1;

CREATE TABLE department__fuzz_1
(
    id DateTime,
    parent_department UInt128,
    name String
)
ENGINE = TinyLog();

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

INSERT INTO department__fuzz_1;

DROP TABLE IF EXISTS department__fuzz_3;

CREATE TABLE department__fuzz_3
(
    id Date,
    parent_department UInt128,
    name LowCardinality(String)
)
ENGINE = TinyLog();

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

INSERT INTO department__fuzz_3;

SELECT *
FROM (
        WITH RECURSIVE q AS (
            SELECT *
            FROM department__fuzz_3
            UNION ALL
            WITH RECURSIVE x AS (
                SELECT *
                FROM department__fuzz_1
                UNION ALL
                SELECT *
                FROM q
                UNION ALL
                SELECT *
                FROM x
            )

            SELECT *
            FROM x
        )

        SELECT *
        FROM q
        LIMIT 32
    )
ORDER BY
    id ASC,
    parent_department DESC,
    name ASC;

DROP TABLE department__fuzz_1;

DROP TABLE department__fuzz_3;
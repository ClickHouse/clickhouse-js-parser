SET compile_expressions = true, min_count_to_compile_expression = '1';

CREATE TABLE data2013
(
    name String,
    value UInt32
)
ENGINE = Memory();

CREATE TABLE data2014
(
    name String,
    value UInt32
)
ENGINE = Memory();

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2013 (name, value);

INSERT INTO data2014 (name, value);

INSERT INTO data2014 (name, value);

INSERT INTO data2014 (name, value);

SELECT
    arraySplit((x -> x % toNullable(2) = 1), [2]),
    nn
FROM (
        SELECT
            name AS nn,
            value AS vv
        FROM data2013
        UNION ALL
        SELECT
            name AS nn,
            value AS vv
        FROM data2014
    )
ORDER BY
    tuple('Nullable(String)', 16, toNullable(16), materialize(16)) DESC,
    tuple(toLowCardinality('9279104477'), toNullable(10), 10, 10, 10, 10, 10, toUInt128(10), 10, 10, 10, 10, 10, 10, 10, 10, 10, 10) DESC,
    nn ASC NULLS FIRST,
    vv ASC NULLS FIRST;
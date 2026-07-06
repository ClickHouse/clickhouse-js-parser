-- Tags: no-parallel-replicas
SET output_format_write_statistics = '0';

DROP TABLE IF EXISTS `03408_memory`;

CREATE TABLE `03408_memory`
(
    id Int32,
    val String
)
ENGINE = Memory() AS
SELECT
    number % 10,
    leftPad(toString(number), 2, '0')
FROM numbers(50);

SELECT '-- Assert total number of groups and records in memory';

SELECT
    uniqExact(id),
    count()
FROM `03408_memory`;

SELECT
    id,
    val
FROM `03408_memory`
ORDER BY
    id ASC,
    val ASC
LIMIT 1 BY id
LIMIT 3
FORMAT JsonCompact
SETTINGS exact_rows_before_limit = '1';

SELECT
    id,
    val
FROM `03408_memory`
GROUP BY
    id,
    val
HAVING id < 7
ORDER BY
    id ASC,
    val DESC
LIMIT 1 BY id
LIMIT 3
FORMAT JsonCompact
SETTINGS exact_rows_before_limit = '1';

DROP TABLE `03408_memory`;
-- https://github.com/ClickHouse/ClickHouse/pull/62457
DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    ID String
)
ENGINE = Memory();

INSERT INTO t;

-- This optimization is disabled by default and even its description says that it could lead to
-- inconsistencies for distributed queries.
SET optimize_if_transform_strings_to_enum = '0';

SET enable_analyzer = '1';

SELECT multiIf((multiIf(ID = ''
    AND (ID = 'a'
    OR ID = 'c'
    OR ID = 'b'), 'a', 'x') AS y) = 'c'
    OR multiIf(ID = ''
    AND (ID = 'a'
    OR ID = 'c'
    OR ID = 'b'), 'a', 'x') = 'b'
    OR multiIf(ID = ''
    AND (ID = 'a'
    OR ID = 'c'
    OR ID = 'b'), 'a', 'x') = 'd'
    OR multiIf(ID = ''
    AND (ID = 'a'
    OR ID = 'c'
    OR ID = 'b'), 'a', 'x') = 'e', 'test', 'x') AS alias
FROM remote('127.0.0.{1,2}', currentDatabase(), t)
GROUP BY alias;
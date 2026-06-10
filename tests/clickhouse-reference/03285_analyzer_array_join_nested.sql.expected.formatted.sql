SET enable_analyzer = '1';

CREATE TABLE hourly
(
    hour datetime,
    `metric.names` Array(String),
    `metric.values` Array(Int64)
)
ENGINE = Memory() AS
SELECT
    '2020-01-01',
    ['a', 'b'],
    [1, 2];

-- { echoOn }
EXPLAIN QUERY TREE dump_ast = '1'
SELECT `metric.names`
FROM
    hourly
ARRAY JOIN metric;

EXPLAIN QUERY TREE dump_ast = '1'
SELECT metric.names
FROM
    hourly
ARRAY JOIN metric;

-- { echoOff }
CREATE TABLE tab
(
    `x.a` Array(String),
    `x.b.first` Array(Array(UInt32)),
    `x.b.second` Array(Array(String))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    ['a1', 'a2'],
    [[1, 2, 3], [4, 5, 6]],
    [['b1', 'b2', 'b3'], ['b4', 'b5', 'b6']];

-- { echoOn }
SELECT
    nested(['click', 'house'], x.b.`first`, x.b.second) AS n,
    toTypeName(n)
FROM tab;

SELECT
    nested([['click', 'house']], x.b.`first`, x.b.second) AS n,
    toTypeName(n)
FROM tab;

SELECT
    nested([['click'], ['house']], x.b.`first`, x.b.second) AS n,
    toTypeName(n)
FROM tab; -- {serverError BAD_ARGUMENTS}

SET analyzer_compatibility_allow_compound_identifiers_in_unflatten_nested = '0';

SELECT x
FROM tab;

SELECT
    y,
    y.b.`first`,
    y.b.second
FROM
    tab
ARRAY JOIN x AS y; -- { serverError UNKNOWN_IDENTIFIER }

SET analyzer_compatibility_allow_compound_identifiers_in_unflatten_nested = '1';
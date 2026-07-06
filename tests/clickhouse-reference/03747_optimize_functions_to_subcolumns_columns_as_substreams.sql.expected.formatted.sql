-- Test Array empty (size0 substream)
DROP TABLE IF EXISTS test_empty_array;

CREATE TABLE test_empty_array
(
    id UInt64,
    `a.size0` UInt64,
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_empty_array SELECT
    42,
    42,
    [];

-- { echo }
SELECT id
FROM test_empty_array
WHERE empty(a)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_empty_array
WHERE empty(a)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Array notEmpty (size0 substream)
DROP TABLE IF EXISTS test_notempty_array;

CREATE TABLE test_notempty_array
(
    id UInt64,
    `a.size0` UInt64,
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_notempty_array SELECT
    42,
    42,
    [1];

-- { echo }
SELECT id
FROM test_notempty_array
WHERE notEmpty(a)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_notempty_array
WHERE notEmpty(a)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Array length (size0 substream)
DROP TABLE IF EXISTS test_length_array;

CREATE TABLE test_length_array
(
    id UInt64,
    `a.size0` UInt64,
    a Array(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_length_array SELECT
    42,
    100,
    [1, 2, 3];

-- { echo }
SELECT
    id,
    length(a)
FROM test_length_array
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT
    id,
    length(a)
FROM test_length_array
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test String empty (size substream)
DROP TABLE IF EXISTS test_empty_string;

CREATE TABLE test_empty_string
(
    id UInt64,
    `s.size` UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_empty_string SELECT
    42,
    42,
    '';

-- { echo }
SELECT id
FROM test_empty_string
WHERE empty(s)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_empty_string
WHERE empty(s)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test String notEmpty (size substream)
DROP TABLE IF EXISTS test_notempty_string;

CREATE TABLE test_notempty_string
(
    id UInt64,
    `s.size` UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_notempty_string SELECT
    42,
    42,
    'hello';

-- { echo }
SELECT id
FROM test_notempty_string
WHERE notEmpty(s)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_notempty_string
WHERE notEmpty(s)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test String length (size substream)
DROP TABLE IF EXISTS test_length_string;

CREATE TABLE test_length_string
(
    id UInt64,
    `s.size` UInt64,
    s String
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_length_string SELECT
    42,
    100,
    'hello';

-- { echo }
SELECT
    id,
    length(s)
FROM test_length_string
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT
    id,
    length(s)
FROM test_length_string
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Map empty (size0 substream)
DROP TABLE IF EXISTS test_empty_map;

CREATE TABLE test_empty_map
(
    id UInt64,
    `m.size0` UInt64,
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_empty_map SELECT
    42,
    42,
    map();

-- { echo }
SELECT id
FROM test_empty_map
WHERE empty(m)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_empty_map
WHERE empty(m)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Map notEmpty (size0 substream)
DROP TABLE IF EXISTS test_notempty_map;

CREATE TABLE test_notempty_map
(
    id UInt64,
    `m.size0` UInt64,
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_notempty_map SELECT
    42,
    42,
    map('a', 1);

-- { echo }
SELECT id
FROM test_notempty_map
WHERE notEmpty(m)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_notempty_map
WHERE notEmpty(m)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Map length (size0 substream)
DROP TABLE IF EXISTS test_length_map;

CREATE TABLE test_length_map
(
    id UInt64,
    `m.size0` UInt64,
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_length_map SELECT
    42,
    100,
    map('a', 1, 'b', 2);

-- { echo }
SELECT
    id,
    length(m)
FROM test_length_map
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT
    id,
    length(m)
FROM test_length_map
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Map mapKeys (keys substream)
DROP TABLE IF EXISTS test_mapkeys;

CREATE TABLE test_mapkeys
(
    id UInt64,
    `m.keys` Array(String),
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

-- Test Map mapValues (values substream)
DROP TABLE IF EXISTS test_mapvalues;

CREATE TABLE test_mapvalues
(
    id UInt64,
    `m.values` Array(UInt64),
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

-- Test Map mapContainsKey (keys substream)
DROP TABLE IF EXISTS test_mapcontainskey;

CREATE TABLE test_mapcontainskey
(
    id UInt64,
    `m.keys` Array(String),
    m Map(String, UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }

-- Test Nullable isNull (null substream)
DROP TABLE IF EXISTS test_isnull;

CREATE TABLE test_isnull
(
    id UInt64,
    `n.null` UInt8,
    n Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_isnull SELECT
    42,
    1,
    NULL;

-- { echo }
SELECT id
FROM test_isnull
WHERE isNull(n)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_isnull
WHERE isNull(n)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Nullable isNotNull (null substream)
DROP TABLE IF EXISTS test_isnotnull;

CREATE TABLE test_isnotnull
(
    id UInt64,
    `n.null` UInt8,
    n Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_isnotnull SELECT
    42,
    1,
    100;

-- { echo }
SELECT id
FROM test_isnotnull
WHERE isNotNull(n)
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT id
FROM test_isnotnull
WHERE isNotNull(n)
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Nullable count (null substream)
DROP TABLE IF EXISTS test_count_nullable;

CREATE TABLE test_count_nullable
(
    id UInt64,
    `n.null` UInt8,
    n Nullable(UInt64)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO test_count_nullable SELECT
    42,
    0,
    100;

INSERT INTO test_count_nullable SELECT
    43,
    1,
    NULL;

-- { echo }
SELECT count(n)
FROM test_count_nullable
SETTINGS optimize_functions_to_subcolumns = '1';

SELECT count(n)
FROM test_count_nullable
SETTINGS optimize_functions_to_subcolumns = '0';

-- { echoOff }
-- Test Tuple tupleElement (named subcolumn)
DROP TABLE IF EXISTS test_tupleelement;

CREATE TABLE test_tupleelement
(
    id UInt64,
    `t.a` UInt64,
    t Tuple(a UInt64, b String)
)
ENGINE = MergeTree()
ORDER BY tuple(); -- { serverError BAD_ARGUMENTS }
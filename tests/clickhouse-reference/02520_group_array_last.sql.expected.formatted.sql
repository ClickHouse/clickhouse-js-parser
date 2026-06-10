DROP TABLE IF EXISTS simple_agg_groupArrayLastArray;

-- { echo }
-- BAD_ARGUMENTS
SELECT groupArrayLast(number + 1)
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

SELECT groupArrayLastArray([number + 1])
FROM numbers(5); -- { serverError BAD_ARGUMENTS }

-- groupArrayLast by number
SELECT groupArrayLast(1)(number + 1)
FROM numbers(5);

SELECT groupArrayLast(3)(number + 1)
FROM numbers(5);

SELECT groupArrayLast(3)(number + 1)
FROM numbers(10);

-- groupArrayLast by String
SELECT groupArrayLast(3)((number + 1)::String)
FROM numbers(5);

SELECT groupArrayLast(3)((number + 1)::String)
FROM numbers(10);

-- groupArrayLastArray
SELECT groupArrayLastArray(3)([1, 2, 3, 4, 5, 6]);

SELECT groupArrayLastArray(3)(['1', '2', '3', '4', '5', '6']);

-- groupArrayLastMerge
-- [10,8,9] + [10,8,9]     => [10,10,9] => [10,10,8] => [9,10,8]
--     ^          ^                  ^      ^^
-- (position to insert at)
SELECT groupArrayLast(3)(number + 1) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

SELECT groupArrayLast(3)((number + 1)::String) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

SELECT groupArrayLast(3)([number + 1]) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

SELECT groupArrayLast(100)(number + 1) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

SELECT groupArrayLast(100)((number + 1)::String) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

SELECT groupArrayLast(100)([number + 1]) AS state
FROM remote('127.{1,1}', view(    SELECT *
    FROM numbers(10)));

-- SimpleAggregateFunction
CREATE TABLE simple_agg_groupArrayLastArray
(
    key Int,
    value SimpleAggregateFunction(groupArrayLastArray(5), Array(UInt64))
)
ENGINE = AggregatingMergeTree()
ORDER BY key;

INSERT INTO simple_agg_groupArrayLastArray;

SELECT *
FROM simple_agg_groupArrayLastArray
ORDER BY
    key ASC,
    value ASC;

SYSTEM STOP MERGES simple_agg_groupArrayLastArray;

INSERT INTO simple_agg_groupArrayLastArray;

SELECT *
FROM simple_agg_groupArrayLastArray FINAL
ORDER BY
    key ASC,
    value ASC;
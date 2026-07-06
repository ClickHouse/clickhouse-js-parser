DROP TABLE IF EXISTS my_table;

DROP VIEW IF EXISTS my_view;

CREATE TABLE my_table
(
    Id UInt32,
    Object Nested(Key UInt8, Value String)
)
ENGINE = MergeTree()
ORDER BY Id;

CREATE VIEW my_view
AS
SELECT * REPLACE (arrayMap((x -> x + 1), `Object.Key`) AS `Object.Key`)
FROM my_table;

SHOW CREATE TABLE my_view;

DROP TABLE my_table;

DROP VIEW my_view;
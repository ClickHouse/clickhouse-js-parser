DROP TABLE IF EXISTS table_00653;

CREATE TABLE table_00653
(
    val Int32
)
ENGINE = MergeTree()
ORDER BY val;

INSERT INTO table_00653;

SELECT count()
FROM table_00653
WHERE toUInt64(val) = 0;

DROP TABLE table_00653;
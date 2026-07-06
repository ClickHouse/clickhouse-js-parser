CREATE TABLE mytable_stored
(
    a UInt8
)
ENGINE = MergeTree()
ORDER BY a;

CREATE TABLE mytable
(
    a UInt8
)
ENGINE = Buffer(currentDatabase(), 'mytable_stored', 4, 600, 3600, 10, 100, 10000, 10000000);

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

INSERT INTO mytable;

SELECT a
FROM mytable
ORDER BY a DESC
LIMIT 5;
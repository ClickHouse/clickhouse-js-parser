DROP TABLE IF EXISTS t;

CREATE TABLE t
(
    letter String
)
ENGINE = MergeTree()
ORDER BY ()
PARTITION BY letter;

INSERT INTO t;

SELECT anyHeavy(if(letter != 'b', letter, NULL))
FROM t;
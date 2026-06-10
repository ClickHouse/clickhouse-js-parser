DROP TABLE IF EXISTS memory;

CREATE TABLE memory
(
    x UInt8
)
ENGINE = Memory();

INSERT INTO memory;

INSERT INTO memory (x);

INSERT INTO memory (x);

INSERT INTO memory (x);

INSERT INTO memory (x);

INSERT INTO memory (x);

SELECT *
FROM memory
ORDER BY x ASC;

DROP TABLE memory;
DROP TABLE IF EXISTS buf_dest;

DROP TABLE IF EXISTS buf;

CREATE TABLE buf_dest
(
    timestamp DateTime
)
ENGINE = MergeTree()
ORDER BY timestamp
PARTITION BY toYYYYMMDD(timestamp);

CREATE TABLE buf
(
    timestamp DateTime
)
ENGINE = Buffer(currentDatabase(), buf_dest, 16, 3, 20, 2000000, 20000000, 100000000, 300000000);

;

INSERT INTO buf (timestamp);

ALTER TABLE buf_dest ADD COLUMN s String;

ALTER TABLE buf ADD COLUMN s String;

SELECT *
FROM buf;

INSERT INTO buf (timestamp, s);

SELECT *
FROM buf
ORDER BY timestamp ASC;
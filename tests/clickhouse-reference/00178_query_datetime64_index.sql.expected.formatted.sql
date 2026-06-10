DROP TABLE IF EXISTS datetime64_index_tbl;

CREATE TABLE datetime64_index_tbl
(
    ts DateTime64(3, 'UTC')
)
ENGINE = MergeTree()
ORDER BY ts;

INSERT INTO datetime64_index_tbl (ts);

SELECT ts
FROM datetime64_index_tbl
WHERE ts < toDate('2023-05-28');

SELECT ts
FROM datetime64_index_tbl
WHERE ts < toDate32('2023-05-28');

DROP TABLE datetime64_index_tbl;
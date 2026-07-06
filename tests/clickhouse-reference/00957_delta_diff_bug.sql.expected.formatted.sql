SET allow_suspicious_codecs = '1';

DROP TABLE IF EXISTS segfault_table;

CREATE TABLE segfault_table
(
    id UInt16 CODEC(Delta(2))
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO segfault_table;

SELECT *
FROM segfault_table;
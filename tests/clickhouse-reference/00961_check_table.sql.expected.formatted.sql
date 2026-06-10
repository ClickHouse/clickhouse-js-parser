SET check_query_single_value_result = '0';

DROP TABLE IF EXISTS mt_table;

CREATE TABLE mt_table
(
    d Date,
    key UInt64,
    data String
)
ENGINE = MergeTree()
ORDER BY key
PARTITION BY toYYYYMM(d);

CHECK TABLE mt_table SETTINGS max_threads = '1';

INSERT INTO mt_table;

INSERT INTO mt_table;

INSERT INTO mt_table;

OPTIMIZE TABLE mt_table FINAL;

INSERT INTO mt_table;

INSERT INTO mt_table;

CHECK TABLE mt_table PARTITION 201902 SETTINGS max_threads = '1';

CHECK TABLE mt_table PART '201801_1_1_2';
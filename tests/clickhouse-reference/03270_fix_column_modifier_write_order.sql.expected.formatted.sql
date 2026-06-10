DROP TABLE IF EXISTS t1;

SET allow_experimental_statistics = '1';

CREATE TABLE t1
(
    d Datetime,
    c0 Int TTL d + toIntervalMonth(1) SETTINGS(max_compress_block_size = '1'),
    c2 Int STATISTICS(Uniq()) SETTINGS(max_compress_block_size = '1')
)
ENGINE = MergeTree()
ORDER BY ();

INSERT INTO t1;
-- Regression test when Join stores data on disk and receive empty block.
-- Because of this it does not create empty file, while expect it.
SET max_threads = '1';

SET join_algorithm = 'auto';

SET max_rows_in_join = '1000';

SET optimize_aggregation_in_order = '1';

SET max_block_size = '1000';

DROP TABLE IF EXISTS join_on_disk;

SYSTEM STOP MERGES join_on_disk;

CREATE TABLE join_on_disk
(
    id Int
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO join_on_disk SELECT number AS id
FROM numbers_mt(50000);

INSERT INTO join_on_disk SELECT number AS id
FROM numbers_mt(1000);

SELECT id
FROM
    join_on_disk AS lhs
LEFT JOIN (
        SELECT id
        FROM join_on_disk
        GROUP BY id
    ) AS rhs
    USING (id)
FORMAT Null;

DROP TABLE join_on_disk;
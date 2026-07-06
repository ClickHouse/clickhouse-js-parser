DROP TABLE IF EXISTS set_index;

CREATE TABLE set_index
(
    a Int32,
    b Int32,
    INDEX b_set b TYPE set(0) GRANULARITY 1
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO set_index;

SELECT b
FROM set_index
WHERE a = 1
    AND a = 1
    AND b = 1
SETTINGS
    force_data_skipping_indices = 'b_set',
    optimize_move_to_prewhere = '0';
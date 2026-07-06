CREATE TABLE mt_compact
(
    a Int,
    s String
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS index_granularity_bytes = '0';

ALTER TABLE mt_compact MODIFY SETTING min_rows_for_wide_part = '1000'; -- { serverError NOT_IMPLEMENTED }

SHOW CREATE TABLE mt_compact;

CREATE TABLE mt_compact_2
(
    a Int,
    s String
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS min_rows_for_wide_part = '1000';

INSERT INTO mt_compact_2;

ALTER TABLE mt_compact ATTACH PARTITION 1 FROM mt_compact_2; -- { serverError BAD_ARGUMENTS }

DROP TABLE mt_compact;

DROP TABLE mt_compact_2;

SET send_logs_level = 'error';

CREATE TABLE mt_compact
(
    a Int,
    s String
)
ENGINE = MergeTree()
ORDER BY a
PARTITION BY a
SETTINGS index_granularity_bytes = '0', min_rows_for_wide_part = '1000';

-- Check that alter of other settings works
ALTER TABLE mt_compact MODIFY SETTING parts_to_delay_insert = '300';

ALTER TABLE mt_compact MODIFY SETTING min_rows_for_wide_part = '0';
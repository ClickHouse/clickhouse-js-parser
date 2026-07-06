-- https://github.com/ClickHouse/ClickHouse/issues/88150
DROP TABLE IF EXISTS t0;

CREATE TABLE t0
(
    c0 Nullable(String)
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS allow_nullable_key = '1';

INSERT INTO t0 (c0);

ALTER TABLE t0 DELETE WHERE c0.size = 'b' SETTINGS mutations_sync = '1'; -- { serverError UNFINISHED }

DELETE FROM t0 WHERE _block_number = 1; -- { serverError UNFINISHED }

ALTER TABLE t0 REWRITE PARTS SETTINGS mutations_sync = '1'; -- { serverError UNFINISHED }

KILL MUTATION WHERE database = currentDatabase()
AND command = '(DELETE WHERE c0.size = ''b'')' SYNC FORMAT Null;

SELECT *
FROM `system`.mutations
WHERE database = currentDatabase()
    AND NOT is_done
FORMAT Vertical;
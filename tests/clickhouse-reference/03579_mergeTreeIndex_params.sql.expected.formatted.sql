DROP TABLE IF EXISTS t_mt_params;

CREATE TABLE t_mt_params
(
    s String,
    n UInt64
)
ENGINE = MergeTree()
ORDER BY s
PARTITION BY n % 2
SETTINGS index_granularity = '3', min_bytes_for_wide_part = '0', min_rows_for_wide_part = '0', serialization_info_version = 'basic';

INSERT INTO t_mt_params;

SELECT *
FROM mergeTreeIndex(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT *
FROM mergeTreeIndex(currentDatabase()); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', non_existing_param = 1); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', with_marks = 1, non_existing_param = 1); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', with_marks = 1, with_minmax = 1, non_existing_param = 1); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params')
ORDER BY `ALL` ASC
FORMAT TSVWithNames;

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', with_marks = 1)
ORDER BY `ALL` ASC
FORMAT TSVWithNames;

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', with_minmax = 1)
ORDER BY `ALL` ASC
FORMAT TSVWithNames;

SELECT *
FROM mergeTreeIndex(currentDatabase(), 't_mt_params', with_marks = 1, with_minmax = 1)
ORDER BY `ALL` ASC
FORMAT TSVWithNames;

DROP TABLE t_mt_params;
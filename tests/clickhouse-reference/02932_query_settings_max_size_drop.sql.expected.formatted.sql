CREATE TABLE test_max_size_drop
ENGINE = MergeTree()
ORDER BY number AS
SELECT number
FROM numbers(1000);

DROP TABLE test_max_size_drop SETTINGS max_table_size_to_drop = '1'; -- { serverError TABLE_SIZE_EXCEEDS_MAX_DROP_SIZE_LIMIT }

DROP TABLE test_max_size_drop;

ALTER TABLE test_max_size_drop DROP PARTITION tuple() SETTINGS max_partition_size_to_drop = '1'; -- { serverError TABLE_SIZE_EXCEEDS_MAX_DROP_SIZE_LIMIT }

ALTER TABLE test_max_size_drop DROP PARTITION tuple();

ALTER TABLE test_max_size_drop DROP PART 'all_1_1_0' SETTINGS max_partition_size_to_drop = '1'; -- { serverError TABLE_SIZE_EXCEEDS_MAX_DROP_SIZE_LIMIT }

ALTER TABLE test_max_size_drop DROP PART 'all_1_1_0';
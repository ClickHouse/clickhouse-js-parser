DROP TABLE IF EXISTS `03604_test`;

SET allow_experimental_lightweight_update = '1';

-- catch error BAD_ARGUMENTS
SET merge_tree_min_read_task_size = '0'; -- { serverError BAD_ARGUMENTS }

CREATE TABLE `03604_test`
(
    c0 Int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS enable_block_number_column = '1', enable_block_offset_column = '1';

INSERT INTO `03604_test` (c0);

DELETE FROM `03604_test` WHERE c0 = 2;

UPDATE `03604_test` SET c0 = 3 WHERE true;

DROP TABLE `03604_test`;
DROP TABLE IF EXISTS table_for_alter;

CREATE TABLE table_for_alter
(
    id UInt64,
    Data String
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS parts_to_throw_insert = '1', parts_to_delay_insert = '1';

INSERT INTO table_for_alter;

INSERT INTO table_for_alter; -- { serverError TOO_MANY_PARTS }

INSERT INTO table_for_alter SETTINGS parts_to_throw_insert = '100', parts_to_delay_insert = '100';

INSERT INTO table_for_alter; -- { serverError TOO_MANY_PARTS }

ALTER TABLE table_for_alter MODIFY SETTING parts_to_throw_insert = '100', parts_to_delay_insert = '100';
DROP TABLE IF EXISTS data;

CREATE TABLE data
(
    key Int
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO data;

SET param_part = 'all_1_1_0';

ALTER TABLE data DETACH PART 'placeholder';

ALTER TABLE data ATTACH PART 'placeholder';

SET param_part = 'all_2_2_0';

ALTER TABLE data DROP DETACHED PART 'placeholder' SETTINGS allow_drop_detached = '1';

INSERT INTO data;

SET param_part = 'all_3_3_0';

ALTER TABLE data DROP PART 'placeholder';
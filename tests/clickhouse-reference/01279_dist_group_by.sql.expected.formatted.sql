DROP TABLE IF EXISTS data_01279;

CREATE TABLE data_01279
(
    key String
)
ENGINE = TinyLog();

INSERT INTO data_01279 SELECT reinterpretAsString(number)
FROM numbers(100000);

SET max_rows_to_group_by = '10';

SET group_by_overflow_mode = 'any';

SET group_by_two_level_threshold = '100';

SELECT *
FROM data_01279
GROUP BY key
FORMAT Null;

DROP TABLE data_01279;
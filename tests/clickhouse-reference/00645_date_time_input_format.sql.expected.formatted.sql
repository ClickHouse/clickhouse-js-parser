CREATE TEMPORARY TABLE test_00645
(
    d DateTime
)
ENGINE = Memory();

SET date_time_input_format = 'best_effort';

INSERT INTO test_00645;

SELECT toTimeZone(d, 'UTC')
FROM test_00645;
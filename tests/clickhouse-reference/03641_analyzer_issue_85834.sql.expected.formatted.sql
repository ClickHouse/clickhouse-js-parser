-- https://github.com/ClickHouse/ClickHouse/issues/85834
DROP TABLE IF EXISTS test_generic_events_all;

CREATE TABLE test_generic_events_all
(
    APIKey UInt8,
    SessionType UInt8
)
ENGINE = MergeTree()
ORDER BY tuple()
PARTITION BY APIKey;

INSERT INTO test_generic_events_all;

ALTER TABLE test_generic_events_all ADD COLUMN OperatingSystem UInt64 DEFAULT 42;

CREATE ROW POLICY rp ON test_generic_events_all USING APIKey > 35 TO CURRENT_USER;

SELECT OperatingSystem
FROM test_generic_events_all
PREWHERE APIKey = 42
SETTINGS additional_table_filters = [('test_generic_events_all', 'APIKey > 40')];
CREATE TABLE ts_data
(
    timestamp DateTime('UTC'),
    value Float64
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO ts_data WITH [11, 57, 71, 88, 89, 101, 127, 135, 151] AS timestamps

SELECT
    ts::DateTime64 AS timestamp,
    ts + 10000 AS value
FROM (
        SELECT arrayJoin(timestamps) AS ts
    );

INSERT INTO ts_data WITH [102, 104, 112, 113, 120] AS timestamps

SELECT
    ts::DateTime64 AS timestamp,
    ts + 10000 AS value
FROM (
        SELECT arrayJoin(timestamps) AS ts
    );

SET allow_experimental_ts_to_grid_aggregate_function = '1';

SELECT groupArraySorted(30)((toUnixTimestamp(timestamp), value))
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin, `end`, step_sec, staleness_sec)(timestamp, value)) AS a
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin_ts, end_ts, step_sec, staleness_sec)(timestamp, value)) AS b
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin_ts, end_ts, step_sec, staleness_sec)(timestamp::DateTime64(3, 'UTC'), value::Float32)) AS c
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin_ts::DateTime64(2, 'UTC'), end_ts::DateTime64(1, 'UTC'), step_sec::Decimal(6, 2), staleness_sec::Decimal(18, 3))(timestamp::DateTime64(3, 'UTC'), value::Float32)) AS d
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin_ts, end_ts::DateTime64(3, 'UTC'), step_sec::Decimal(6, 2), staleness_sec)(timestamp::DateTime64(6, 'UTC'), value)) AS e
FROM ts_data;

WITH 100 AS begin,

200 AS `end`,

10 AS step_sec,

15 AS staleness_sec,

CAST(begin AS DateTime('UTC')) AS begin_ts,

CAST(`end` AS DateTime('UTC')) AS end_ts,

range(begin, `end` + step_sec, step_sec) AS grid

SELECT arrayZip(grid, timeSeriesResampleToGridWithStaleness(begin_ts, end_ts, step_sec, staleness_sec)(timestamp::DateTime64(6, 'UTC'), value)) AS e
FROM clusterAllReplicas('test_shard_localhost', currentDatabase(), ts_data)
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '3',
    parallel_replicas_for_non_replicated_merge_tree = '1',
    prefer_localhost_replica = '0';

-- Test for returning multiple rows in batch
SELECT
    intDiv(toUnixTimestamp(timestamp), 130) * 130 AS fake_key,
    timeSeriesResampleToGridWithStaleness(100, 200, 10, 15)(timestamp, value)
FROM ts_data
GROUP BY fake_key
ORDER BY fake_key ASC;

-- Compute average in each bucket
SELECT
    avgForEach(values),
    countForEach(values) AS avg_values
FROM (
        SELECT
            intDiv(toUnixTimestamp(timestamp), 130) * 130 AS fake_key,
            timeSeriesResampleToGridWithStaleness(100, 200, 10, 15)(timestamp, value) AS values
        FROM ts_data
        GROUP BY fake_key
    );

-- AggregatingMergeTree Table to test (de)serialization of timeSeriesResampleToGridWithStaleness state
CREATE TABLE ts_data_agg
(
    k UInt64,
    agg AggregateFunction(timeSeriesResampleToGridWithStaleness(100, 200, 10, 15), DateTime('UTC'), Float64)
)
ENGINE = AggregatingMergeTree()
ORDER BY k;

-- Insert the data splitting it into several pieces
INSERT INTO ts_data_agg SELECT
    toUnixTimestamp(timestamp) % 3,
    initializeAggregation('timeSeriesResampleToGridWithStalenessState(100, 200, 10, 15)', timestamp, value)
FROM ts_data;

SELECT
    k,
    finalizeAggregation(agg)
FROM ts_data_agg FINAL
ORDER BY k ASC;

-- Reload table and check that the data is the same (i.e. serialize-deserialize worked correctly)
DETACH TABLE ts_data_agg;

ATTACH TABLE ts_data_agg;

-- Check that -Merge returns the same result as the result form original table
SELECT timeSeriesResampleToGridWithStaleness(100, 200, 10, 15)(timestamp, value)
FROM ts_data;

SELECT timeSeriesResampleToGridWithStalenessMerge(100, 200, 10, 15)(agg)
FROM ts_data_agg;

-- Check various data types for parameters and arguments
SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, value) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp::DateTime64(2, 'UTC'), value) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStaleness(CAST('100' AS Int32), CAST('150' AS UInt16), CAST('15' AS Decimal(10, 2)), 50)(timestamp::DateTime64(3, 'UTC'), value::Float32) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStaleness(100, 100, 15, 50)(timestamp::DateTime64(3, 'UTC'), value::Float32) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStalenessIf(100, 150, 15, 50)(timestamp, value, value % 2 = 0) AS res
FROM ts_data;

-- Test with Nullable timestamps and values
SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(if(value < 10120, NULL, timestamp), value::Float32) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, if(value < 10120, NULL, value)) AS res
FROM ts_data;

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, value::Decimal(10, 3)) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, value::Int64) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, value::String) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, 50)(timestamp, value::DateTime) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(CAST('100' AS Float64), 150, 15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, CAST('150' AS Float32), 15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, CAST('15' AS Float32), 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, CAST('50' AS Float64))(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(-100, 150, 15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, -150, 15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, -15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 15, -50)(timestamp, value) AS res
FROM ts_data; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT timeSeriesResampleToGridWithStaleness(200, 100, 15, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError BAD_ARGUMENTS }

SELECT timeSeriesResampleToGridWithStaleness(100, 150, 0, 50)(timestamp, value) AS res
FROM ts_data; -- { serverError BAD_ARGUMENTS }
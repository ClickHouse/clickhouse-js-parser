SET allow_experimental_ts_to_grid_aggregate_function = '1';

SET cluster_for_parallel_replicas = 'test_shard_localhost';

CREATE TABLE t_resampled_timeseries
(
    `step` UInt32,
    metric_id UInt64,
    grid_timestamp DateTime('UTC') CODEC(DoubleDelta(), ZSTD()),
    samples Tuple(Array(DateTime('UTC')), Array(Float64))
)
ENGINE = AggregatingMergeTree()
ORDER BY (`step`, metric_id, grid_timestamp);

INSERT INTO t_resampled_timeseries (`step`, metric_id, grid_timestamp, samples);

WITH toDateTime('2024-12-12 12:00:10', 'UTC') AS start_ts,

toDateTime('2024-12-12 12:01:00', 'UTC') AS end_ts,

10 AS step_sec,

50 AS window_sec,

range(toUnixTimestamp(start_ts), toUnixTimestamp(end_ts) + 1, step_sec) AS grid

SELECT
    metric_id,
    arrayJoin(arrayZip(grid, irate_values, irate_values_scale_3, idelta_values, rate_values, rate_values_scale_5, delta_values))
FROM (
        SELECT
            metric_id,
            timeSeriesInstantRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS irate_values,
            timeSeriesInstantRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1::Array(DateTime64(3, 'UTC')), (samples).2) AS irate_values_scale_3,
            timeSeriesInstantDeltaToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS idelta_values,
            timeSeriesRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS rate_values,
            timeSeriesRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1::Array(DateTime64(5, 'UTC')), (samples).2) AS rate_values_scale_5,
            timeSeriesDeltaToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS delta_values
        FROM clusterAllReplicas('test_shard_localhost', currentDatabase(), t_resampled_timeseries)
        GROUP BY metric_id
    )
ORDER BY metric_id ASC
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '3',
    parallel_replicas_for_non_replicated_merge_tree = '1',
    enable_analyzer = '1';

-- Test with DateTime64
CREATE TABLE t_resampled_timeseries_64
(
    `step` UInt32,
    metric_id UInt64,
    grid_timestamp DateTime('UTC') CODEC(DoubleDelta(), ZSTD()),
    samples Tuple(Array(DateTime64(3, 'UTC')), Array(Float64))
)
ENGINE = AggregatingMergeTree()
ORDER BY (`step`, metric_id, grid_timestamp);

INSERT INTO t_resampled_timeseries_64 (`step`, metric_id, grid_timestamp, samples);

WITH toDateTime64('2024-12-12 12:00:10', 3, 'UTC') AS start_ts,

toDateTime64('2024-12-12 12:01:00', 3, 'UTC') AS end_ts,

10 AS step_sec,

50 AS window_sec,

range(toUnixTimestamp(start_ts), toUnixTimestamp(end_ts) + 1, step_sec) AS grid

SELECT
    metric_id,
    arrayJoin(arrayZip(grid, irate_values, idelta_values, rate_values, delta_values))
FROM (
        SELECT
            metric_id,
            timeSeriesInstantRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS irate_values,
            timeSeriesInstantDeltaToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS idelta_values,
            timeSeriesRateToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS rate_values,
            timeSeriesDeltaToGrid(start_ts, end_ts, step_sec, window_sec)((samples).1, (samples).2) AS delta_values
        FROM clusterAllReplicas('test_shard_localhost', currentDatabase(), t_resampled_timeseries_64)
        GROUP BY metric_id
    )
ORDER BY metric_id ASC
SETTINGS
    enable_parallel_replicas = '1',
    max_parallel_replicas = '3',
    parallel_replicas_for_non_replicated_merge_tree = '1',
    enable_analyzer = '1';

-- Another test with a reset
WITH CAST('[\n(1600000000, 10),\n(1600000010, 20),\n(1600000020, 30),\n(1600000030, 40),\n(1600000040, 10),\n(1600000050, 70),\n(1600000060, 90),\n(1600000270, 20),\n(1600000330, 10)\n]' AS Array(Tuple(UInt32, Float64))) AS data

SELECT *
FROM (
        SELECT
            'delta' AS name,
            timeSeriesDeltaToGrid(1600000010, 1600000320, 10, 300)((data).1, (data).2)
        UNION ALL
        SELECT
            'idelta' AS name,
            timeSeriesInstantDeltaToGrid(1600000010, 1600000320, 10, 300)((data).1, (data).2)
    )
ORDER BY name ASC;

-- Tests to validate block header compatibility in queries with parallel replicas
SET serialize_query_plan = '1', prefer_localhost_replica = false;

SELECT
    metric_id,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10'::DateTime64(3, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c1,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10'::DateTime64(4, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c2,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10'::DateTime64(3, 'UTC'), '2024-12-12 12:01:00'::DateTime64(2, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c3,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10.123'::DateTime64(4, 'UTC'), '2024-12-12 12:01:01'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c4,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10.123456'::DateTime64(4, 'UTC'), '2024-12-12 12:01:00.123'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c5,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10.12'::DateTime64(1, 'UTC'), '2024-12-12 12:01:00.123'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c6,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10.123'::DateTime64(0, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c7,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10'::DateTime('UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2)) AS c8,
    toTypeName(timeSeriesInstantRateToGridState('2024-12-12 12:00:10.123'::DateTime64(2, 'UTC'), '2024-12-12 12:01:01'::DateTime('UTC'), 10, 60)((samples).1, (samples).2)) AS c9
FROM clusterAllReplicas('test_shard_localhost', currentDatabase(), t_resampled_timeseries_64)
GROUP BY metric_id
FORMAT Vertical;

SELECT
    metric_id,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10'::DateTime64(3, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c1,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10'::DateTime64(4, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c2,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10'::DateTime64(3, 'UTC'), '2024-12-12 12:01:00'::DateTime64(2, 'UTC'), 10, 60)((samples).1, (samples).2) AS c3,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10.123'::DateTime64(4, 'UTC'), '2024-12-12 12:01:01'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c4,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10.123456'::DateTime64(4, 'UTC'), '2024-12-12 12:01:00.123'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c5,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10.12'::DateTime64(1, 'UTC'), '2024-12-12 12:01:00.123'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c6,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10.123'::DateTime64(0, 'UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c7,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10'::DateTime('UTC'), '2024-12-12 12:01:00'::DateTime64(3, 'UTC'), 10, 60)((samples).1, (samples).2) AS c8,
    timeSeriesInstantRateToGrid('2024-12-12 12:00:10.123'::DateTime64(2, 'UTC'), '2024-12-12 12:01:01'::DateTime('UTC'), 10, 60)((samples).1, (samples).2) AS c9
FROM clusterAllReplicas('test_shard_localhost', currentDatabase(), t_resampled_timeseries_64)
GROUP BY metric_id
FORMAT Vertical;
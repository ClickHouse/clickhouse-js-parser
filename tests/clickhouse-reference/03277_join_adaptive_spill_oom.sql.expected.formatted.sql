-- Tags: no-asan, no-tsan
CREATE TABLE adaptive_spill_03277_1
(
    k String,
    x String
)
ENGINE = Memory();

CREATE TABLE adaptive_spill_03277_2
(
    k String,
    x String
)
ENGINE = Memory();

CREATE TABLE adaptive_spill_03277_3
(
    k String,
    x String
)
ENGINE = Memory();

INSERT INTO adaptive_spill_03277_1 SELECT
    CAST(rand() AS String) AS k,
    CAST(rand() AS String) AS x
FROM numbers(1000000);

INSERT INTO adaptive_spill_03277_2 SELECT
    CAST(rand() AS String) AS k,
    CAST(rand() AS String) AS x
FROM numbers(1000000);

INSERT INTO adaptive_spill_03277_3 SELECT
    CAST(rand() AS String) AS k,
    CAST(rand() AS String) AS x
FROM numbers(1000000);

SET max_threads = '1';

SET join_algorithm = 'grace_hash';

SET max_memory_usage = '314572800';

SET collect_hash_table_stats_during_joins = '0';

-- don't limit the memory usage for join
SET max_bytes_in_join = '0';

SET enable_adaptive_memory_spill_scheduler = false;

SELECT
    t1.k,
    t2.x,
    t3.x
FROM
    adaptive_spill_03277_1 AS t1
LEFT JOIN adaptive_spill_03277_2 AS t2
    ON t1.k = t2.k
LEFT JOIN adaptive_spill_03277_3 AS t3
    ON t1.k = t3.k
FORMAT Null; --{serverError MEMORY_LIMIT_EXCEEDED}

SET enable_adaptive_memory_spill_scheduler = true;

DROP TABLE IF EXISTS adaptive_spill_03277_1;

DROP TABLE IF EXISTS adaptive_spill_03277_2;

DROP TABLE IF EXISTS adaptive_spill_03277_3;
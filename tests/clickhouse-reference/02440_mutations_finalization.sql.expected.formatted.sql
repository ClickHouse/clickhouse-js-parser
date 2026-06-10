-- Tags: no-parallel
CREATE TABLE mut
(
    n int
)
ENGINE = ReplicatedMergeTree('/test/02440/{database}/mut', '1')
ORDER BY tuple();

SET insert_keeper_fault_injection_probability = '0';

INSERT INTO mut;

SYSTEM STOP MERGES mut;

ALTER TABLE mut UPDATE n = 2 WHERE n = 1;

-- it will create MUTATE_PART entry, but will not execute it
SYSTEM SYNC REPLICA mut PULL;

SELECT
    mutation_id,
    command,
    parts_to_do_names,
    is_done
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 'mut';

-- merges (and mutations) will start again after detach/attach, we need to avoid this somehow...
CREATE TABLE tmp
(
    n int
)
ENGINE = MergeTree()
ORDER BY tuple()
SETTINGS index_granularity = '1';

INSERT INTO tmp SELECT *
FROM numbers(1000);

ALTER TABLE tmp UPDATE n = sleepEachRow(1) WHERE 1;

SELECT sleepEachRow(2) AS higher_probablility_of_reproducing_the_issue
FORMAT Null;

-- it will not execute MUTATE_PART, because another mutation is currently executing (in tmp)
ALTER TABLE mut MODIFY SETTING max_number_of_mutations_for_replica = '1';

DETACH TABLE mut;

ATTACH TABLE mut;

-- mutation should not be finished yet
SELECT *
FROM mut;

ALTER TABLE mut MODIFY SETTING max_number_of_mutations_for_replica = '100';

SYSTEM SYNC REPLICA mut;

SELECT
    mutation_id,
    command,
    parts_to_do_names
FROM `system`.mutations
WHERE database = currentDatabase()
    AND table = 'mut';

DROP TABLE tmp; -- btw, it will check that mutation can be cancelled between blocks on shutdown
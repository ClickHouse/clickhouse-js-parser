SET any_join_distinct_right_table_keys = '1';

SET joined_subquery_requires_alias = '0';

DROP TABLE IF EXISTS local_statements;

DROP TABLE IF EXISTS statements;

CREATE TABLE local_statements
(
    statementId String,
    eventDate Date,
    eventHour DateTime,
    eventTime DateTime,
    verb String,
    objectId String,
    onCourse UInt8,
    courseId UInt16,
    contextRegistration String,
    resultScoreRaw Float64,
    resultScoreMin Float64,
    resultScoreMax Float64,
    resultSuccess UInt8,
    resultCompletition UInt8,
    resultDuration UInt32,
    resultResponse String,
    learnerId String,
    learnerHash String,
    contextId UInt16
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE statements
(
    statementId String,
    eventDate Date,
    eventHour DateTime,
    eventTime DateTime,
    verb String,
    objectId String,
    onCourse UInt8,
    courseId UInt16,
    contextRegistration String,
    resultScoreRaw Float64,
    resultScoreMin Float64,
    resultScoreMax Float64,
    resultSuccess UInt8,
    resultCompletition UInt8,
    resultDuration UInt32,
    resultResponse String,
    learnerId String,
    learnerHash String,
    contextId UInt16
)
ENGINE = Distributed(test_shard_localhost, currentDatabase(), 'local_statements', sipHash64(learnerHash));

INSERT INTO local_statements FORMAT CSV;

DROP TABLE local_statements;

DROP TABLE statements;
-- Tags: stateful
DROP TABLE IF EXISTS hits_dst;

DROP TABLE IF EXISTS hits_buffer;

CREATE TABLE hits_dst AS test.hits
ENGINE = MergeTree()
ORDER BY (CounterID, EventDate, intHash32(UserID))
PARTITION BY toYYYYMM(EventDate)
SAMPLE BY intHash32(UserID)
SETTINGS storage_policy = 'default';

CREATE TABLE hits_buffer AS hits_dst
ENGINE = Buffer(current_database(), hits_dst, 8, 600, 600, 1000000, 1000000, 100000000, 1000000000);

INSERT INTO hits_buffer SELECT *
FROM test.hits
WHERE CounterID = 800784;

SELECT count()
FROM hits_buffer;

SELECT count()
FROM hits_dst;

OPTIMIZE TABLE hits_buffer;

DROP TABLE hits_dst;

DROP TABLE hits_buffer;
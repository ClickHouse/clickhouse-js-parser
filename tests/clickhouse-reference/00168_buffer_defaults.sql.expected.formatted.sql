DROP TABLE IF EXISTS mt_00168;

DROP TABLE IF EXISTS mt_00168_buffer;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE mt_00168
(
    EventDate Date,
    UTCEventTime DateTime,
    MoscowEventDate Date DEFAULT toDate(UTCEventTime)
)
ENGINE = MergeTree(EventDate, UTCEventTime, 8192);

CREATE TABLE mt_00168_buffer AS mt_00168
ENGINE = Buffer(currentDatabase(), mt_00168, 16, 10, 100, 10000, 1000000, 10000000, 100000000);

DESCRIBE TABLE mt_00168;

DESCRIBE TABLE mt_00168_buffer;

INSERT INTO mt_00168 (EventDate, UTCEventTime);

SELECT *
FROM mt_00168_buffer;

INSERT INTO mt_00168_buffer (EventDate, UTCEventTime);

DROP TABLE mt_00168_buffer;

DROP TABLE mt_00168;
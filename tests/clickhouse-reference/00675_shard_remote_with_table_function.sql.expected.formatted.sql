-- Tags: shard
DROP TABLE IF EXISTS remote_test;

CREATE TABLE remote_test
(
    a1 UInt8
)
ENGINE = Memory();

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), remote_test);

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), remote_test);

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), remote_test);

INSERT INTO FUNCTION remote('127.0.0.1', currentDatabase(), remote_test);

SELECT COUNT(*)
FROM remote('127.0.0.1', currentDatabase(), remote_test);

SELECT count(*)
FROM remote('127.0.0.{1,2}', merge(currentDatabase(), '^remote_test'));

DROP TABLE remote_test;
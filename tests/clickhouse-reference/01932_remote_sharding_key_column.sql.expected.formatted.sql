-- Tags: shard
-- regression test for the following query:
--
--     select * from remote('127.1', system.one, dummy)
--
-- that produce the following error before:
--
--     Unknown column: dummy, there are only columns .
--
-- NOTE: that wrapping column into any function works before.
SELECT *
FROM remote('127.1', `system`.one, dummy)
FORMAT Null;

SELECT *
FROM remote('127.1', `system`.one, identity(dummy))
FORMAT Null;

SELECT *
FROM remote('127.1', view(    SELECT *
    FROM `system`.one), identity(dummy))
FORMAT Null;

SELECT *
FROM remote('127.{1,2}', view(    SELECT *
    FROM `system`.one), identity(dummy))
FORMAT Null;

SELECT *
FROM remote('127.1', view(    SELECT *
    FROM `system`.one), dummy)
FORMAT Null;

SELECT *
FROM remote('127.{1,2}', view(    SELECT *
    FROM `system`.one), dummy)
FORMAT Null;
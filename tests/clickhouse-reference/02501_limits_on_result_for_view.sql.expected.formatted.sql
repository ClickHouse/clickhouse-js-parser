DROP TABLE IF EXISTS `02501_test`;

DROP TABLE IF EXISTS `02501_dist`;

DROP VIEW IF EXISTS `02501_view`;

-- create local table
CREATE TABLE `02501_test`
(
    a UInt64
)
ENGINE = Memory();

-- create dist table
CREATE TABLE `02501_dist`
(
    a UInt64
)
ENGINE = Distributed(test_cluster_two_shards, currentDatabase(), `02501_test`);

-- create view
CREATE VIEW `02501_view` (a UInt64)
AS
SELECT a
FROM `02501_dist`;

-- insert data
INSERT INTO `02501_test`;

-- test
SELECT *
FROM `02501_view`
SETTINGS max_result_rows = '1'; -- { serverError TOO_MANY_ROWS_OR_BYTES }

SELECT sum(a)
FROM `02501_view`
SETTINGS max_result_rows = '1';
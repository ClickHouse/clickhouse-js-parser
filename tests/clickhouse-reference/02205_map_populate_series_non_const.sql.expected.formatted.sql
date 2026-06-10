DROP TABLE IF EXISTS `02005_test_table`;

CREATE TABLE `02005_test_table`
(
    value Map(Int64, Int64)
)
ENGINE = TinyLog();

SELECT mapPopulateSeries(value)
FROM `02005_test_table`;

TRUNCATE TABLE `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

SELECT mapPopulateSeries(value, materialize(20))
FROM `02005_test_table`;

SELECT mapPopulateSeries(map(toUInt64(18446744073709551610), toUInt64(5)), 18446744073709551615);

SELECT mapPopulateSeries(map(toUInt64(18446744073709551615), toUInt64(5)), 18446744073709551615);

SELECT mapPopulateSeries(map(1, 4, 1, 5, 5, 6));

SELECT mapPopulateSeries(map(1, 4, 1, 5, 5, 6), materialize(10));

DROP TABLE `02005_test_table`;

CREATE TABLE `02005_test_table`
(
    key Array(Int64),
    value Array(Int64)
)
ENGINE = TinyLog();

SELECT mapPopulateSeries(key, value)
FROM `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

INSERT INTO `02005_test_table`;

SELECT mapPopulateSeries(key, value, materialize(20))
FROM `02005_test_table`;

SELECT mapPopulateSeries([18446744073709551610], [5], 18446744073709551615);

SELECT mapPopulateSeries([18446744073709551615], [5], 18446744073709551615);

SELECT mapPopulateSeries([1, 1, 5], [4, 5, 6]);

SELECT mapPopulateSeries([1, 1, 5], [4, 5, 6], materialize(10));
DROP TABLE IF EXISTS `02131_rptable`;

CREATE TABLE `02131_rptable`
(
    x UInt8
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO `02131_rptable`;

DROP ROW POLICY IF EXISTS `02131_filter_1` ON `02131_rptable`;

DROP ROW POLICY IF EXISTS `02131_filter_2` ON `02131_rptable`;

DROP ROW POLICY IF EXISTS `02131_filter_3` ON `02131_rptable`;

DROP ROW POLICY IF EXISTS `02131_filter_4` ON `02131_rptable`;

DROP ROW POLICY IF EXISTS `02131_filter_5` ON `02131_rptable`;

SELECT *
FROM `02131_rptable`;

CREATE ROW POLICY 02131_filter_1 ON `02131_rptable` USING x = 1 AS PERMISSIVE TO ALL;

CREATE ROW POLICY 02131_filter_2 ON `02131_rptable` USING x = 2 AS PERMISSIVE TO ALL;

CREATE ROW POLICY 02131_filter_3 ON `02131_rptable` USING x = 3 AS PERMISSIVE TO ALL;

SELECT *
FROM `02131_rptable`
PREWHERE x >= 2
SETTINGS additional_table_filters = [('02131_rptable', 'x > 1')];

SELECT *
FROM `02131_rptable`
PREWHERE x >= 2
SETTINGS additional_result_filter = 'x > 1';

SELECT *
FROM `02131_rptable`
WHERE x >= 2
SETTINGS additional_table_filters = [('02131_rptable', 'x > 1')];

CREATE ROW POLICY 02131_filter_4 ON `02131_rptable` USING x <= 2 AS RESTRICTIVE TO ALL;

CREATE ROW POLICY 02131_filter_5 ON `02131_rptable` USING x >= 2 AS RESTRICTIVE TO ALL;

DROP ROW POLICY `02131_filter_1` ON `02131_rptable`;

DROP ROW POLICY `02131_filter_2` ON `02131_rptable`;

DROP ROW POLICY `02131_filter_3` ON `02131_rptable`;

DROP ROW POLICY `02131_filter_4` ON `02131_rptable`;

DROP ROW POLICY `02131_filter_5` ON `02131_rptable`;

DROP TABLE `02131_rptable`;
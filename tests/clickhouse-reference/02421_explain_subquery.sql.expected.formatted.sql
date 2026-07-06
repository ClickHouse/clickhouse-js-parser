SET enable_analyzer = '0';

SELECT count() > 3
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', 'header = 1', (
                SELECT *
                FROM `system`.numbers
                ORDER BY number DESC
            ))
    )
WHERE `explain` LIKE '%Header: number UInt64%';

SELECT count() > 0
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT *
                FROM `system`.numbers
                ORDER BY number DESC
            ))
    )
WHERE `explain` ILIKE '%Sort%';

SELECT count() > 0
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN', '', (
                SELECT *
                FROM `system`.numbers
                ORDER BY number DESC
            ))
    )
WHERE `explain` ILIKE '%Sort%';

SELECT count() > 0
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN CURRENT TRANSACTION', '')
    );

SELECT count() = 1
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN SYNTAX', '', (
                SELECT number
                FROM `system`.numbers
                ORDER BY number DESC
            ))
    )
WHERE `explain` ILIKE 'SELECT%';

SELECT trimBoth(`explain`) = 'Asterisk'
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN AST', '', (
                SELECT *
                FROM `system`.numbers
                LIMIT 10
            ))
    )
WHERE `explain` LIKE '%Asterisk%';

SELECT *
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN AST', '', (
                SELECT *
                FROM (
                        SELECT *
                        FROM viewExplain('EXPLAIN', '', (
                                SELECT *
                                FROM (
                                        SELECT *
                                        FROM viewExplain('EXPLAIN SYNTAX', '', (
                                                SELECT trimBoth(`explain`) = 'Asterisk'
                                                FROM (
                                                        SELECT *
                                                        FROM viewExplain('EXPLAIN AST', '', (
                                                                SELECT *
                                                                FROM `system`.numbers
                                                                LIMIT 10
                                                            ))
                                                    )
                                                WHERE `explain` LIKE '%Asterisk%'
                                            ))
                                    )
                            ))
                    )
            ))
    )
FORMAT Null;

SELECT (
        SELECT *
        FROM viewExplain('EXPLAIN SYNTAX', 'oneline = 1', (
                SELECT 1
            ))
    ) = 'SELECT 1';

SELECT *
FROM viewExplain('', ''); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM viewExplain('EXPLAIN AST', ''); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM viewExplain('EXPLAIN AST', '', 1); -- { serverError BAD_ARGUMENTS }

SELECT *
FROM viewExplain('EXPLAIN AST', '', ''); -- { serverError BAD_ARGUMENTS }

DROP TABLE IF EXISTS t1;

CREATE TABLE t1
(
    a UInt64
)
ENGINE = MergeTree()
ORDER BY tuple() AS
SELECT number AS a
FROM `system`.numbers
LIMIT 100000;

SELECT `rows` > 1000
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN ESTIMATE', '', (
                SELECT sum(a)
                FROM t1
            ))
    );

SELECT count() = 1
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN ESTIMATE', '', (
                SELECT sum(a)
                FROM t1
            ))
    );

DROP TABLE t1;

SET enable_analyzer = '1';

SELECT count() > 3
FROM (
        SELECT *
        FROM viewExplain('EXPLAIN PIPELINE', 'header = 1', (
                SELECT *
                FROM `system`.numbers
                ORDER BY number DESC
            ))
    )
WHERE `explain` LIKE '%Header: \\_\\_table1.number UInt64%';

SELECT (
        SELECT *
        FROM viewExplain('EXPLAIN SYNTAX', 'oneline = 1', (
                SELECT 1
            ))
    ) = 'SELECT 1 FROM system.one'; -- EXPLAIN ESTIMATE is not supported in experimental analyzer
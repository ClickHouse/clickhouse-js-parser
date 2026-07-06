DROP TABLE IF EXISTS `set`;

DROP TABLE IF EXISTS set2;

DROP TABLE IF EXISTS tab;

CREATE TABLE `set`
(
    x String
)
ENGINE = Set();

SELECT arrayJoin(['Hello', 'test', 'World', 'world', 'abc', 'xyz']) AS s
WHERE s IN (`set`);

SELECT arrayJoin(['Hello', 'test', 'World', 'world', 'abc', 'xyz']) AS s
WHERE s NOT IN (`set`);

INSERT INTO `set`;

RENAME TABLE `set` TO set2;

SELECT arrayJoin(['Hello', 'test', 'World', 'world', 'abc', 'xyz']) AS s
WHERE s IN (set2);

INSERT INTO set2;

INSERT INTO set2;

DETACH TABLE set2;

ATTACH TABLE set2;

RENAME TABLE set2 TO `set`;

CREATE TABLE tab
(
    x String
)
ENGINE = MergeTree()
ORDER BY x AS
SELECT 'Hello';

SELECT *
FROM tab
PREWHERE x IN (`set`)
WHERE x IN (`set`)
LIMIT 1
SETTINGS enable_analyzer = '0';

SELECT *
FROM tab
PREWHERE x IN (`set`)
WHERE x IN (`set`)
LIMIT 1
SETTINGS enable_analyzer = '1';

DROP TABLE tab;

DROP TABLE `set`;
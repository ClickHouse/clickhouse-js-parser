DROP DICTIONARY IF EXISTS groups_dict;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS `groups`;

CREATE TABLE users
(
    uid Int16,
    name String,
    gid LowCardinality(String),
    gname LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE `groups`
(
    gid LowCardinality(String),
    gname LowCardinality(String)
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE DICTIONARY groups_dict
(
    gid String,
    gname String
)
PRIMARY KEY gid, gname
SOURCE(clickhouse(TABLE 'groups' DATABASE currentDatabase()))
LIFETIME(MIN 0 MAX 0)
LAYOUT(COMPLEX_KEY_HASHED());

INSERT INTO `groups`;

INSERT INTO users;

SELECT
    u.uid,
    u.name,
    u.gid,
    u.gname
FROM
    users AS u
LEFT JOIN groups_dict AS g
    USING (gid, gname)
FORMAT PrettyCompactMonoBlock;

SELECT
    u.uid,
    u.name,
    u.gid,
    u.gname
FROM
    users AS u
LEFT JOIN `groups` AS g
    USING (gid, gname)
FORMAT PrettyCompactMonoBlock;

SET allow_experimental_analyzer = '0';
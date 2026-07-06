DROP DICTIONARY IF EXISTS groups_dict;

DROP TABLE IF EXISTS mv;

DROP TABLE IF EXISTS users;

DROP TABLE IF EXISTS `groups`;

DROP TABLE IF EXISTS target;

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

CREATE TABLE target
(
    uid Int16,
    name String,
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

CREATE MATERIALIZED VIEW mv
TO target
AS
SELECT
    u.uid,
    u.name,
    u.gid,
    u.gname
FROM
    users AS u
LEFT JOIN groups_dict AS g
    USING (gid, gname);

INSERT INTO `groups`;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT *
FROM target
ORDER BY uid ASC
FORMAT PrettyCompactMonoBlock;
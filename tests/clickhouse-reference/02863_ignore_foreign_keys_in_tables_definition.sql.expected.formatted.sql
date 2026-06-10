-- https://github.com/ClickHouse/ClickHouse/issues/53380
DROP TABLE IF EXISTS parent;

DROP TABLE IF EXISTS child;

CREATE TABLE parent
(
    id int,
    PRIMARY KEY(id)
)
ENGINE = MergeTree();

CREATE TABLE child
(
    id int,
    pid int,
    PRIMARY KEY(id)
)
ENGINE = MergeTree();

SHOW CREATE TABLE child;

CREATE TABLE child2
(
    id int,
    pid int,
    PRIMARY KEY(id)
)
ENGINE = MergeTree();

SHOW CREATE TABLE child2;

CREATE TABLE child3
(
    id int,
    pid int,
    PRIMARY KEY(id)
)
ENGINE = MergeTree();

SHOW CREATE TABLE child3;

DROP TABLE child3;

DROP TABLE child2;

DROP TABLE child;

DROP TABLE parent;
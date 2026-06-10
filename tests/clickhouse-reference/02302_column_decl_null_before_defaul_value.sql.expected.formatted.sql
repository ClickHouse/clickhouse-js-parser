DROP TABLE IF EXISTS null_before SYNC;

CREATE TABLE null_before
(
    id INT NULL
)
ENGINE = MergeTree()
ORDER BY tuple();

DESCRIBE TABLE null_before;

CREATE TABLE null_before
(
    id INT NOT NULL
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id INT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id INT NOT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id INT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id INT NOT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id NOT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE null_before
(
    id NOT NULL DEFAULT 1
)
ENGINE = MergeTree()
ORDER BY tuple();
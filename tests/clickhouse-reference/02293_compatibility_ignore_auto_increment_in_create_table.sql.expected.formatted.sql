SET compatibility_ignore_auto_increment_in_create_table = false;

DROP TABLE IF EXISTS ignore_auto_increment SYNC;

CREATE TABLE ignore_auto_increment
(
    id int AUTO_INCREMENT
)
ENGINE = MergeTree()
ORDER BY tuple(); -- {serverError SYNTAX_ERROR}

SET compatibility_ignore_auto_increment_in_create_table = true;

CREATE TABLE ignore_auto_increment
(
    id INT AUTO_INCREMENT
)
ENGINE = MergeTree()
ORDER BY tuple();

DESCRIBE TABLE ignore_auto_increment;

CREATE TABLE ignore_auto_increment
(
    id int AUTO_INCREMENT,
    di INT AUTO_INCREMENT,
    s String AUTO_INCREMENT
)
ENGINE = MergeTree()
ORDER BY tuple();

CREATE TABLE ignore_auto_increment
(
    di DEFAULT 1,
    id int AUTO_INCREMENT,
    s String EPHEMERAL
)
ENGINE = MergeTree()
ORDER BY tuple();
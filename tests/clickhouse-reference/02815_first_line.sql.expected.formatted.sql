SELECT firstLine('foo\nbar\nbaz');

SELECT firstLine('foo\rbar\rbaz');

SELECT firstLine('foo\r\nbar\r\nbaz');

SELECT firstLine('foobarbaz');

DROP TABLE IF EXISTS `02815_first_line_vector`;

CREATE TABLE `02815_first_line_vector`
(
    n Int32,
    text String
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO `02815_first_line_vector`;

SELECT
    n,
    firstLine(text)
FROM `02815_first_line_vector`
ORDER BY n ASC;
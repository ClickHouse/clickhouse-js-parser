DROP TABLE IF EXISTS markdown;

CREATE TABLE markdown
(
    id UInt32,
    name String,
    `array` Array(Int32),
    nullable Nullable(String),
    low_cardinality LowCardinality(String),
    decimal Decimal32(6)
)
ENGINE = Memory();

INSERT INTO markdown;

SELECT *
FROM markdown
FORMAT Markdown;

SET output_format_markdown_escape_special_characters = true;

SELECT '!#$%&(*+,-./:<=>?@[^`{|}~' AS a
FORMAT Markdown;

SELECT CAST(1 AS Enum('!#$%&(*+,-./:<=>?@[^`{|}~' = 1)) AS a
FORMAT Markdown;

SELECT toFixedString('!#$%&(*+,-./:<=>?@[^`{|}~', 25) AS a
FORMAT Markdown;

SET output_format_markdown_escape_special_characters = false;
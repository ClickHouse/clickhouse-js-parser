SET output_format_pretty_squash_consecutive_ms = '0';

SET output_format_pretty_max_column_name_width_cut_to = '0';

DROP TABLE IF EXISTS unicode;

CREATE TABLE unicode
(
    c1 String,
    c2 String
)
ENGINE = Memory();

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

INSERT INTO unicode;

SELECT *
FROM unicode
SETTINGS max_threads = '1'
FORMAT PrettyNoEscapes;

SELECT
    'Tabs \t Tabs',
    'Long\tTitle'
FORMAT PrettyNoEscapes;

SELECT
    '你好',
    '世界'
FORMAT Vertical;

SELECT
    'Tabs \t Tabs',
    'Non-first \t Tabs'
FORMAT Vertical;

SELECT
    'Control characters  with zero width',
    'Invalid UTF-8 which eats pending characters �, and invalid by itself � with zero width'
FORMAT Vertical;

SELECT
    'Russian ё and ё',
    'Zero bytes \0 \0 in middle'
FORMAT Vertical;
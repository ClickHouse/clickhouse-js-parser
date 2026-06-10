-- https://github.com/ClickHouse/ClickHouse/pull/52653
DROP TABLE IF EXISTS or_bug;

CREATE TABLE or_bug
(
    key UInt8
)
ENGINE = MergeTree()
ORDER BY key;

INSERT INTO or_bug;

-- { echoOn }
SELECT *
FROM or_bug
WHERE key = 1
    OR false
    OR false;

SELECT *
FROM or_bug
WHERE key = 1
    OR false;

SELECT *
FROM or_bug
WHERE key = 1;

-- { echoOff }
-- https://github.com/ClickHouse/ClickHouse/issues/55288
DROP TABLE IF EXISTS forms;

CREATE TABLE forms
(
    form_id FixedString(24),
    text_field String
)
ENGINE = MergeTree()
PRIMARY KEY form_id
ORDER BY form_id;

INSERT INTO forms;

-- { echoOn }
SELECT *
FROM forms
WHERE text_field LIKE '%this%'
    OR 0 = 1
    OR 0 = 1;

SELECT *
FROM forms
WHERE text_field LIKE '%this%'
    OR 0 = 1;

SELECT *
FROM forms
WHERE text_field LIKE '%this%'; -- { echoOff }
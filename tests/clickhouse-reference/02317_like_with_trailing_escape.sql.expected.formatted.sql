DROP TABLE IF EXISTS tab;

CREATE TABLE tab
(
    haystack String,
    pattern String
)
ENGINE = MergeTree()
ORDER BY haystack;

INSERT INTO tab;

-- const pattern
SELECT haystack LIKE 'pattern\\'
FROM tab; -- { serverError CANNOT_PARSE_ESCAPE_SEQUENCE }

-- non-const pattern
SELECT haystack LIKE pattern
FROM tab; -- { serverError CANNOT_PARSE_ESCAPE_SEQUENCE }
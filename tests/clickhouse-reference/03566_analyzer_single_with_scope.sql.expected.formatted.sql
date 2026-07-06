CREATE TABLE tab
(
    x String,
    y UInt8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    'rue',
    1;

WITH 't' || x AS y

SELECT 1
FROM tab
WHERE y = 'true'
SETTINGS enable_analyzer = '0';

WITH 't' || x AS y

SELECT 1
FROM tab
WHERE y = 'true'
SETTINGS enable_analyzer = '1';

WITH 't' || x AS y

SELECT *
FROM (
        SELECT 1
        FROM tab
        WHERE y = 'true'
    )
SETTINGS enable_analyzer = '0';

WITH 't' || x AS y

SELECT *
FROM (
        SELECT 1
        FROM tab
        WHERE y = 'true'
    )
SETTINGS enable_analyzer = '1'; -- { serverError TYPE_MISMATCH }

WITH 't' || x AS y,

'rue' AS x

SELECT 1
FROM tab
WHERE y = 'true'
SETTINGS enable_analyzer = '1';

WITH 't' || x AS y,

'rue' AS x

SELECT *
FROM (
        SELECT 1
        FROM tab
        WHERE y = 'true'
    )
SETTINGS enable_analyzer = '1'; -- { serverError TYPE_MISMATCH }

SET enable_scopes_for_with_statement = '0';

WITH 't' || x AS y,

'rue' AS x

SELECT 1
FROM tab
WHERE y = 'true'
SETTINGS enable_analyzer = '0'; -- { serverError TYPE_MISMATCH }

WITH 't' || x AS y,

'rue' AS x

SELECT *
FROM (
        SELECT 1
        FROM tab
        WHERE y = 'true'
    )
SETTINGS enable_analyzer = '0'; -- { serverError TYPE_MISMATCH }
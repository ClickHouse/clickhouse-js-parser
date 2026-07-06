-- {echo}
SELECT
    sqrt(-1) AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '1';

SELECT
    sqrt(-1) AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '0';

SELECT
    -inf AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '1';

SELECT
    -inf AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '0';

SELECT
    NULL AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '1';

SELECT
    NULL AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '0';

SELECT
    inf AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '1';

SELECT
    inf AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '0';

SELECT
    nan AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '1';

SELECT
    nan AS x,
    NOT x,
    NOT NOT x,
    (NOT x) IS NULL
SETTINGS enable_analyzer = '0';
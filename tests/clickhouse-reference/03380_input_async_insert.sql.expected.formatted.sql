---
--- Analyzer
---
INSERT INTO FUNCTION null() SELECT *
FROM input('x Int, y String')
SETTINGS
    async_insert = '1',
    allow_experimental_analyzer = '1' FORMAT JSONEachRow;

INSERT INTO FUNCTION null('auto') SELECT *
FROM input('x Int, y String')
SETTINGS
    async_insert = '1',
    allow_experimental_analyzer = '1' FORMAT JSONEachRow;

INSERT INTO FUNCTION null('x Int, y String') SELECT *
FROM input('x Int, y String')
SETTINGS
    async_insert = '1',
    allow_experimental_analyzer = '1' FORMAT JSONEachRow;

---
--- Non-analyzer - does not support INSERT INTO FUNCTION null('auto') SELECT FROM input()
---
INSERT INTO FUNCTION null() SELECT *
FROM input('x Int, y String')
SETTINGS
    async_insert = '1',
    allow_experimental_analyzer = '0' FORMAT JSONEachRow; -- { serverError QUERY_IS_PROHIBITED }

INSERT INTO FUNCTION null('x Int, y String') SELECT *
FROM input('x Int, y String')
SETTINGS
    async_insert = '1',
    allow_experimental_analyzer = '0' FORMAT JSONEachRow;

DROP TABLE IF EXISTS x;

CREATE TABLE x
(
    x Int,
    y String
)
ENGINE = Memory();

INSERT INTO x SELECT *
FROM input('x Int, y String')
SETTINGS async_insert = '1' FORMAT JSONEachRow;

SELECT *
FROM x;
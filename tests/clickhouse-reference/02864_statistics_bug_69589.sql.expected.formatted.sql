-- Tags: no-fasttest
-- no-fasttest: 'countmin' sketches need a 3rd party library
SET allow_experimental_statistics = '1';

SET use_statistics = '1';

CREATE TABLE tab
(
    c Nullable(Int)
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab (c);

DELETE FROM tab WHERE true;

INSERT INTO tab (c);

ALTER TABLE tab ADD STATISTICS c TYPE countmin;

OPTIMIZE TABLE tab;

SELECT 1
FROM tab
WHERE tab.c = 0;
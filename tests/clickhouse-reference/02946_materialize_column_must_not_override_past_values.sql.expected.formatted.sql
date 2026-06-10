SET mutations_sync = '2';

DROP TABLE IF EXISTS tab;

SELECT '-- Compact parts';

CREATE TABLE tab
(
    id Int64,
    dflt Int64 DEFAULT 54321
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab (id, dflt);

INSERT INTO tab (id);

SELECT *
FROM tab
ORDER BY id ASC;

ALTER TABLE tab MATERIALIZE COLUMN dflt;

DROP TABLE tab;

CREATE TABLE tab
(
    id Int64,
    dflt Int64 DEFAULT 54321
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1';

CREATE TABLE tab
(
    id Int64,
    dflt Nullable(Int64) DEFAULT 54321
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1';

INSERT INTO tab (id, dflt);

INSERT INTO tab (id);

ALTER TABLE tab RENAME COLUMN dflt TO dflt2;

ALTER TABLE tab MATERIALIZE COLUMN dflt2;

CREATE TABLE tab
(
    id Int64,
    mtrl Int64 MATERIALIZED 54321
)
ENGINE = MergeTree()
ORDER BY id;

INSERT INTO tab (id);

SELECT
    id,
    mtrl
FROM tab
ORDER BY id ASC;

ALTER TABLE tab MODIFY COLUMN mtrl Int64 MATERIALIZED 65432;

ALTER TABLE tab MATERIALIZE COLUMN mtrl;

CREATE TABLE tab
(
    id Int64,
    mtrl Int64 MATERIALIZED 54321
)
ENGINE = MergeTree()
ORDER BY id
SETTINGS min_bytes_for_wide_part = '1';
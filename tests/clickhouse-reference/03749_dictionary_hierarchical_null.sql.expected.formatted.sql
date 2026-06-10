-- {echoOn }
DROP DICTIONARY IF EXISTS d0;

CREATE DICTIONARY d0
(
    c0 Int
)
PRIMARY KEY c0
SOURCE(null())
LIFETIME(MIN 0 MAX 1)
LAYOUT(FLAT());

SELECT dictGetDescendants('d0', 'c0', 1); -- { serverError UNSUPPORTED_METHOD }

SELECT dictGetDescendants('d0', 'c0', NULL); -- { serverError UNSUPPORTED_METHOD }

SELECT dictGetDescendants('d0', NULL, 1); -- { serverError UNSUPPORTED_METHOD }

SELECT dictGetChildren('d0', 'c0'); -- { serverError UNSUPPORTED_METHOD }

SELECT dictGetChildren('d0', NULL); -- { serverError UNSUPPORTED_METHOD }

SELECT dictGetChildren(NULL, NULL); -- { serverError UNSUPPORTED_METHOD }

DROP DICTIONARY IF EXISTS hierarchical_dictionary;

DROP TABLE IF EXISTS hierarchy_source;

CREATE TABLE hierarchy_source
(
    id UInt64,
    parent_id UInt64,
    name String
)
ENGINE = Memory();

INSERT INTO hierarchy_source;

CREATE DICTIONARY hierarchical_dictionary
(
    id UInt64,
    parent_id UInt64 HIERARCHICAL,
    name String
)
PRIMARY KEY id
SOURCE(clickhouse(TABLE 'hierarchy_source'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(HASHED());

SELECT dictGetDescendants('hierarchical_dictionary', 1, 1);

SELECT dictGetDescendants('hierarchical_dictionary', NULL, 1);

SELECT dictGetDescendants('hierarchical_dictionary', 1, NULL); -- { serverError BAD_ARGUMENTS }

SELECT dictGetChildren('hierarchical_dictionary', 1);

SELECT dictGetChildren('hierarchical_dictionary', NULL);
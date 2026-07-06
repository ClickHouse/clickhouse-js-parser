-- Tags: use-vectorscan
DROP DICTIONARY IF EXISTS regexp_dict1;

DROP TABLE IF EXISTS regexp_dictionary_source_table;

CREATE TABLE regexp_dictionary_source_table
(
    id UInt64,
    parent_id UInt64,
    regexp String,
    keys Array(String),
    values Array(String)
)
ENGINE = TinyLog();

-- test back reference.
INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

CREATE DICTIONARY regexp_dict1
(
    regexp String,
    name String,
    version Nullable(UInt64),
    comment String DEFAULT 'nothing'
)
PRIMARY KEY regexp
SOURCE(clickhouse(TABLE 'regexp_dictionary_source_table'))
LIFETIME(MIN 0 MAX 0)
LAYOUT(REGEXP_TREE());

SELECT *
FROM dictionary(regexp_dict1);

SELECT dictGet('regexp_dict1', ('name', 'version', 'comment'), 'Linux/101.tlinux');

SELECT dictGet('regexp_dict1', ('name', 'version', 'comment'), '33/tclwebkit11.10x');

SELECT dictGet('regexp_dict1', ('name', 'version', 'comment'), '30/tclwebkit');

SELECT dictGetOrDefault('regexp_dict1', ('name', 'version', 'comment'), '30/tclwebkit', ('', 0, 'default'));

--test column input
DROP TABLE IF EXISTS needle_table;

CREATE TABLE needle_table
(
    key String
)
ENGINE = TinyLog();

INSERT INTO needle_table SELECT concat(toString(number + 30), '/tclwebkit', toString(number))
FROM `system`.numbers
LIMIT 15;

SELECT *
FROM needle_table;

SELECT dictGet(regexp_dict1, ('name', 'version'), key)
FROM needle_table;

SYSTEM RELOAD DICTIONARY regexp_dict1; -- { serverError INCORRECT_DICTIONARY_DEFINITION  }

TRUNCATE TABLE regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table;

INSERT INTO regexp_dictionary_source_table; -- child has more priority than parents.

INSERT INTO regexp_dictionary_source_table; -- larger id has lower priority than small id.

SELECT dictGet(regexp_dict1, ('name', 'version', 'comment'), '33/tclwebkit');
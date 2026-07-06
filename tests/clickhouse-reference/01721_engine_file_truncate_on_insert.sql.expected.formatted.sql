-- Tags: no-replicated-database, no-parallel
-- Tag no-replicated-database: user_files
DROP TABLE IF EXISTS test;

INSERT INTO FUNCTION file('01721_file/test/data.TSV', 'TSV', 'id UInt32');

ATTACH TABLE test FROM '01721_file/test'
(
    id UInt8
)
ENGINE = File(TSV);

INSERT INTO test;

INSERT INTO test;

SELECT *
FROM test;

SET engine_file_truncate_on_insert = '0';

INSERT INTO test;

SET engine_file_truncate_on_insert = '1';

INSERT INTO test;

DROP TABLE test;
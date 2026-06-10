-- Tags: no-replicated-database, memory-engine
DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS file;

DROP TABLE IF EXISTS mt;

ATTACH TABLE test FROM 'some/path'
(
    n UInt8
)
ENGINE = Memory(); -- { serverError NOT_IMPLEMENTED }

ATTACH TABLE test FROM '/etc/passwd'
(
    s String
)
ENGINE = File(TSVRaw); -- { serverError PATH_ACCESS_DENIED }

ATTACH TABLE test FROM '../../../../../../../../../etc/passwd'
(
    s String
)
ENGINE = File(TSVRaw); -- { serverError PATH_ACCESS_DENIED }

INSERT INTO FUNCTION file('01188_attach/file/data.TSV', 'TSV', 's String, n UInt8');

ATTACH TABLE file FROM '01188_attach/file'
(
    s String,
    n UInt8
)
ENGINE = File(TSV);

SELECT *
FROM file;

DETACH TABLE file;

ATTACH TABLE file;

ATTACH TABLE mt FROM '01188_attach/file'
(
    n UInt8,
    s String
)
ENGINE = MergeTree()
ORDER BY n;

SELECT *
FROM mt;

INSERT INTO mt;

DETACH TABLE mt;

ATTACH TABLE mt;

DROP TABLE file;

DROP TABLE mt;
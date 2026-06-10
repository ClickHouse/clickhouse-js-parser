-- Tags: no-fasttest
SET allow_suspicious_low_cardinality_types = '0';

SELECT CAST(1000000 AS LowCardinality(UInt64)); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

DESCRIBE TABLE file(nonexist.json, JSONEachRow, 'lc LowCardinality(UInt64)'); -- {serverError SUSPICIOUS_TYPE_FOR_LOW_CARDINALITY}

SET allow_suspicious_fixed_string_types = '0';

SELECT CAST('' AS FixedString(1000)); -- {serverError ILLEGAL_COLUMN}

DESCRIBE TABLE file(nonexist.json, JSONEachRow, 'fs FixedString(1000)'); -- {serverError ILLEGAL_COLUMN}
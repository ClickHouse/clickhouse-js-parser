SET allow_suspicious_low_cardinality_types = '1';

DROP TABLE IF EXISTS tab_00718;

CREATE TABLE tab_00718
(
    a String,
    b LowCardinality(UInt32)
)
ENGINE = MergeTree()
ORDER BY a;

INSERT INTO tab_00718;

SELECT
    *,
    toTypeName(b)
FROM tab_00718;

ALTER TABLE tab_00718 MODIFY COLUMN b UInt32;

ALTER TABLE tab_00718 MODIFY COLUMN b LowCardinality(UInt32);

ALTER TABLE tab_00718 MODIFY COLUMN b LowCardinality(String);

ALTER TABLE tab_00718 MODIFY COLUMN b String;
DROP TABLE IF EXISTS tbl;

SET allow_suspicious_low_cardinality_types = '1';

CREATE TABLE tbl
(
    lc LowCardinality(UUID)
)
ENGINE = Memory();

INSERT INTO tbl;

SET extremes = '1';

SELECT *
FROM tbl;

DROP TABLE tbl;
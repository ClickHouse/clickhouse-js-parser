SET enable_time_time64_type = '1';

CREATE OR REPLACE TABLE tx
(
    c0 Time
)
ENGINE = Memory();

INSERT INTO tx (c0);

SELECT c0
FROM tx;

DROP TABLE tx;
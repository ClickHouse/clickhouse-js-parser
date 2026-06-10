DROP TABLE IF EXISTS stripelog;

CREATE TABLE stripelog
(
    x UInt8
)
ENGINE = StripeLog();

SELECT *
FROM stripelog
ORDER BY x ASC;

INSERT INTO stripelog;

DROP TABLE stripelog;
DROP TABLE IF EXISTS histogram;

CREATE TABLE histogram
(
    num Int64
)
ENGINE = TinyLog();

INSERT INTO histogram;

SELECT histogram(2)(num)
FROM histogram;
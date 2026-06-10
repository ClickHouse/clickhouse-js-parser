DROP TABLE IF EXISTS mann_whitney_test;

CREATE TABLE mann_whitney_test
(
    `left` Float64,
    `right` UInt8
)
ENGINE = Memory();

INSERT INTO mann_whitney_test;

SELECT mannWhitneyUTest(`left`, `right`)
FROM mann_whitney_test;

SELECT
    '223.0',
    '0.5426959774289482';

WITH mannWhitneyUTest(`left`, `right`) AS pair

SELECT
    roundBankers((pair).1, 16) AS t_stat,
    roundBankers((pair).2, 16) AS p_value
FROM mann_whitney_test;

WITH mannWhitneyUTest('two-sided', 1)(`left`, `right`) AS pair

SELECT
    roundBankers((pair).1, 16) AS t_stat,
    roundBankers((pair).2, 16) AS p_value
FROM mann_whitney_test;

WITH mannWhitneyUTest('two-sided')(`left`, `right`) AS pair

SELECT
    roundBankers((pair).1, 16) AS t_stat,
    roundBankers((pair).2, 16) AS p_value
FROM mann_whitney_test;
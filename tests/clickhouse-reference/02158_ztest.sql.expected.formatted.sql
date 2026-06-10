DROP TABLE IF EXISTS mean_ztest;

CREATE TABLE mean_ztest
(
    v int,
    s UInt8
)
ENGINE = Memory();

INSERT INTO mean_ztest SELECT
    number,
    0
FROM numbers(100)
WHERE number % 2 = 0;

INSERT INTO mean_ztest SELECT
    number,
    1
FROM numbers(100)
WHERE number % 2 = 1;

SELECT
    roundBankers(meanZTest(833., 800., 0.95)(v, s).1, 16) AS z_stat,
    roundBankers(meanZTest(833., 800., 0.95)(v, s).2, 16) AS p_value,
    roundBankers(meanZTest(833., 800., 0.95)(v, s).3, 16) AS ci_low,
    roundBankers(meanZTest(833., 800., 0.95)(v, s).4, 16) AS ci_high
FROM mean_ztest;
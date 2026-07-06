DROP TABLE IF EXISTS welch_ttest;

CREATE TABLE welch_ttest
(
    `left` Float64,
    `right` UInt8
)
ENGINE = Memory();

INSERT INTO welch_ttest;

SELECT roundBankers(welchTTest(`left`, `right`).2, 6)
FROM welch_ttest;

CREATE TABLE welch_ttest
(
    `left` Float64,
    `right` Float64
)
ENGINE = Memory();

INSERT INTO welch_ttest;

INSERT INTO welch_ttest;

INSERT INTO welch_ttest;

SELECT
    '-0.5028215369186904',
    '0.6152361677168877';

SELECT
    roundBankers(welchTTest(`left`, `right`).1, 6) AS t_stat,
    roundBankers(welchTTest(`left`, `right`).2, 6) AS p_value
FROM welch_ttest;

INSERT INTO welch_ttest;

SELECT
    '14.971190998235835',
    '5.898143508382202e-44';

SELECT
    roundBankers(welchTTest(0.95)(`left`, `right`).3, 6) AS t_stat,
    roundBankers(welchTTest(0.95)(`left`, `right`).4, 6) AS p_value
FROM welch_ttest;

DROP TABLE IF EXISTS student_ttest;

/*Check t-stat and p-value and compare it with scipy.stat implementation
  First: a=1, sigma (not sigma^2)=5, size=500
  Second: a=1, sigma = 5, size = 500 */
CREATE TABLE student_ttest
(
    `left` Float64,
    `right` Float64
)
ENGINE = Memory();

INSERT INTO student_ttest;

SELECT
    '-2.610898982580138',
    '0.00916587538237954';

SELECT
    roundBankers(studentTTest(`left`, `right`).1, 6) AS t_stat,
    roundBankers(studentTTest(`left`, `right`).2, 6) AS p_value
FROM student_ttest;

INSERT INTO student_ttest;

SELECT
    '-28.740781574102936',
    '7.667329672103986e-133';

SELECT
    roundBankers(studentTTest(0.95)(`left`, `right`).3, 6) AS t_stat,
    roundBankers(studentTTest(0.95)(`left`, `right`).4, 6) AS p_value
FROM student_ttest;

/* One-sample t-test against population mean 75 */
DROP TABLE IF EXISTS onesample_ttest;

CREATE TABLE onesample_ttest
(
    value Float64
)
ENGINE = Memory();

INSERT INTO onesample_ttest;

SELECT
    '0.376423',
    '0.709342';

SELECT
    roundBankers(studentTTestOneSample(value, 75).1, 6) AS t_stat,
    roundBankers(studentTTestOneSample(value, 75).2, 6) AS p_value
FROM onesample_ttest;
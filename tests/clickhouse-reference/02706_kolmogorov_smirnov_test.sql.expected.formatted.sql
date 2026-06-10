DROP TABLE IF EXISTS kstest;

CREATE TABLE kstest
(
    `left` Float64,
    `right` Float64
)
ENGINE = Memory();

INSERT INTO kstest;

SELECT
    roundBankers(kolmogorovSmirnovTest(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('less')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('greater')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'auto')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'auto')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'auto')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'exact')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'exact')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'exact')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'asymp')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'asymp')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'asymp')(`left`, `right`).2, 6),
    roundBankers(kolmogorovSmirnovTest(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('less')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('greater')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'auto')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'auto')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'auto')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'exact')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'exact')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'exact')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('two-sided', 'asymp')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('less', 'asymp')(`left`, `right`).1, 6),
    roundBankers(kolmogorovSmirnovTest('greater', 'asymp')(`left`, `right`).1, 6)
FROM kstest;

INSERT INTO kstest;

INSERT INTO kstest;
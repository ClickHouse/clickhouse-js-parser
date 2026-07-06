SELECT abs(0) = 0;

SELECT abs(1) = 1;

SELECT abs(0.) = 0;

SELECT abs(1.) = 1.;

SELECT abs(-1.) = 1.;

SELECT abs(-128) = 128;

SELECT abs(127) = 127;

SELECT sum(abs(number - 10 AS x) = (x < 0 ? -x : x)) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS number;

SELECT sqrt(0) = 0;

SELECT sqrt(1) = 1;

SELECT sqrt(4) = 2;

SELECT sum(sqrt(x * x) = x) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT cbrt(0) = 0;

SELECT cbrt(1) = 1;

SELECT cbrt(8) = 2;

SELECT sum(abs(cbrt(x * x * x) - x) < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT pow(1, 0) = 1;

SELECT pow(2, 0) = 1;

SELECT sum(pow(x, 0) = 1) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT pow(1, 1) = 1;

SELECT pow(2, 1) = 2;

SELECT sum(abs(pow(x, 1) - x) < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT sum(pow(x, 2) = x * x) / count()
FROM
    `system`.one
ARRAY JOIN range(10000) AS x;

SELECT isNaN(lgamma(-2));

SELECT isNaN(lgamma(-1));

SELECT lgamma(0) = inf;

SELECT lgamma(1) = 0;

SELECT lgamma(2) = 0;

SELECT abs(lgamma(3) - 0.693147181) < 1e-8;

SELECT abs(lgamma(4) - 1.791759469) < 1e-8;

SELECT tgamma(0) = inf;

SELECT tgamma(1) = 1;

SELECT tgamma(2) = 1;

SELECT tgamma(3) = 2;

SELECT tgamma(4) = 6;

SELECT sum(abs(lgamma(x + 1) - log(tgamma(x + 1))) < 1e-8) / count()
FROM
    `system`.one
ARRAY JOIN range(10) AS x;

SELECT abs(e() - arraySum(arrayMap((x -> 1 / tgamma(x + 1)), range(13)))) < 1e-9;

SELECT log(0) = -inf;

SELECT log(1) = 0;

SELECT abs(log(e()) - 1) < 1e-8;

SELECT abs(log(exp(1)) - 1) < 1e-8;

SELECT abs(log(exp(2)) - 2) < 1e-8;

SELECT sum(abs(log(exp(x)) - x) < 1e-8) / count()
FROM
    `system`.one
ARRAY JOIN range(100) AS x;

SELECT exp2(-1) = 1 / 2;

SELECT exp2(0) = 1;

SELECT exp2(1) = 2;

SELECT exp2(2) = 4;

SELECT exp2(3) = 8;

SELECT sum(exp2(x) = pow(2, x)) / count()
FROM
    `system`.one
ARRAY JOIN range(1000) AS x;

SELECT log2(0) = -inf;

SELECT log2(1) = 0;

SELECT log2(2) = 1;

SELECT log2(4) = 2;

SELECT sum(abs(log2(exp2(x)) - x) < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(1000) AS x;

SELECT log1p(-1) = -inf;

SELECT log1p(0) = 0;

SELECT abs(log1p(exp(2) - 1) - 2) < 100000000.;

SELECT abs(log1p(exp(3) - 1) - 3) < 100000000.;

SELECT sum(abs(log1p(exp(x) - 1) - x) < 1e-8) / count()
FROM
    `system`.one
ARRAY JOIN range(100) AS x;

SELECT sin(0) = 0;

SELECT sin(pi() / 4) = 1 / sqrt(2);

SELECT sin(pi() / 2) = 1;

SELECT sin(3 * pi() / 2) = -1;

SELECT sum(sin(pi() / 2 + 2 * pi() * x) = 1) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT cos(0) = 1;

SELECT abs(cos(pi() / 4) - 1 / sqrt(2)) < 1e-9;

SELECT cos(pi() / 2) < 1e-9;

SELECT sum(abs(cos(2 * pi() * x)) - 1 < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT tan(0) = 0;

SELECT abs(tan(pi() / 4) - 1) < 1e-9;

SELECT sum(abs(tan(pi() / 4 + 2 * pi() * x) - 1) < 1e-8) / count()
FROM
    `system`.one
ARRAY JOIN range(1000000) AS x;

SELECT asin(0) = 0;

SELECT asin(1) = pi() / 2;

SELECT asin(-1) = -pi() / 2;

SELECT acos(0) = pi() / 2;

SELECT acos(1) = 0;

SELECT acos(-1) = pi();

SELECT atan(0) = 0;

SELECT atan(1) = pi() / 4;

SELECT atan2(0, 1) = 0;

SELECT atan2(0, 2) = 0;

SELECT atan2(1, 0) = pi() / 2;

SELECT atan2(1, 1) = pi() / 4;

SELECT atan2(-1, -1) = -3 * pi() / 4;

SELECT hypot(0, 1) = 1;

SELECT hypot(1, 0) = 1;

SELECT hypot(1, 1) = sqrt(2);

SELECT hypot(-1, 1) = sqrt(2);

SELECT hypot(3, 4) = 5;

SELECT sinh(0) = 0;

SELECT sinh(1) = -sinh(-1);

SELECT abs(sinh(1) - 0.5 * (e() - exp(-1))) < 0.000001;

SELECT abs(sinh(2) - 0.5 * (exp(2) - exp(-2))) < 0.000001;

SELECT sum(abs(sinh(x) - 0.5 * (exp(x) - exp(-x))) < 0.000001) / count()
FROM
    `system`.one
ARRAY JOIN range(10) AS x;

SELECT cosh(0) = 1;

SELECT cosh(1) = cosh(-1);

SELECT abs(cosh(1) - 0.5 * (e() + exp(-1))) < 0.000001;

SELECT abs(pow(cosh(1), 2) - pow(sinh(1), 2) - 1) < 0.000001;

SELECT sum(abs(cosh(x) * cosh(x) - sinh(x) * sinh(x) - 1) < 0.000001) / count()
FROM
    `system`.one
ARRAY JOIN range(10) AS x;

SELECT asinh(0) = 0;

SELECT asinh(1) = -asinh(-1);

SELECT abs(asinh(1) - ln(1 + sqrt(2))) < 1e-9;

SELECT abs(asinh(sinh(1)) - 1) < 1e-9;

SELECT sum(abs(asinh(sinh(x)) - x) < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(100) AS x;

SELECT acosh(1) = 0;

SELECT abs(acosh(2) - ln(2 + sqrt(3))) < 1e-9;

SELECT abs(acosh(cosh(2)) - 2) < 1e-9;

SELECT abs(acosh(cosh(3)) - 3) < 1e-9;

SELECT sum(abs(acosh(cosh(x)) - x) < 1e-9) / count()
FROM
    `system`.one
ARRAY JOIN range(1, 101) AS x;

SELECT atanh(0) = 0;

SELECT atanh(0.5) = -atanh(-0.5);

SELECT abs(atanh(0.9) - 0.5 * ln(19)) < 0.00001;

SELECT abs(atanh(tanh(1)) - 1) < 0.00001;

SELECT sum(abs(atanh(tanh(x)) - x) < 0.00001) / count()
FROM
    `system`.one
ARRAY JOIN range(10) AS x;

SELECT erf(0) = 0;

SELECT erf(-10) = -1;

SELECT erf(10) = 1;

SELECT erfc(0) = 1;

SELECT erfc(-10) = 2;

SELECT erfc(28) = 0;
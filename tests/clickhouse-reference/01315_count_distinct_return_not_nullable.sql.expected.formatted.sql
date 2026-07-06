SELECT uniq(number >= 10 ? number : NULL)
FROM numbers(10);

SELECT uniqExact(number >= 10 ? number : NULL)
FROM numbers(10);

SELECT countDistinct(number >= 10 ? number : NULL)
FROM numbers(10);

SELECT uniq(number >= 5 ? number : NULL)
FROM numbers(10);

SELECT uniqExact(number >= 5 ? number : NULL)
FROM numbers(10);

SELECT countDistinct(number >= 5 ? number : NULL)
FROM numbers(10);

SELECT '---';

SELECT count(NULL);

SELECT uniq(NULL);

SELECT countDistinct(NULL);

SELECT avg(NULL);

SELECT sum(NULL);

SELECT corr(NULL, NULL);

SELECT corr(1, NULL);

SELECT corr(NULL, 1);
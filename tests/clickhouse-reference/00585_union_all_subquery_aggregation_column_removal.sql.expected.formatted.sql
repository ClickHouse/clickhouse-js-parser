DROP TABLE IF EXISTS clicks;

DROP TABLE IF EXISTS transactions;

CREATE TABLE clicks
(
    domain String
)
ENGINE = Memory();

CREATE TABLE transactions
(
    domain String
)
ENGINE = Memory();

INSERT INTO clicks;

INSERT INTO transactions;

SELECT
    sum(total_count) AS total,
    domain
FROM (
        SELECT
            COUNT(*) AS total_count,
            toUInt64(0) AS facebookHits,
            domain
        FROM transactions
        GROUP BY domain
        UNION ALL
        SELECT
            COUNT(*) AS total_count,
            SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
            domain
        FROM clicks
        GROUP BY domain
    )
GROUP BY domain
ORDER BY domain ASC
LIMIT 10
FORMAT JSONEachRow;

SELECT
    sum(total_count) AS total,
    domain
FROM (
        SELECT
            COUNT(*) AS total_count,
            SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
            domain
        FROM clicks
        GROUP BY domain
        UNION ALL
        SELECT
            COUNT(*) AS total_count,
            toUInt64(0) AS facebookHits,
            domain
        FROM transactions
        GROUP BY domain
    )
GROUP BY domain
ORDER BY domain ASC
LIMIT 10
FORMAT JSONEachRow;

SELECT DISTINCT *
FROM (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
        UNION ALL
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    );

SELECT DISTINCT
    total,
    domain
FROM (
        SELECT
            sum(total_count) AS total,
            sum(facebookHits) AS facebook,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
        UNION ALL
        SELECT
            sum(total_count) AS total,
            max(facebookHits) AS facebook,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    )
ORDER BY
    domain ASC,
    total ASC;

SELECT *
FROM
    (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js1
ALL FULL JOIN (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js2
    USING (total, domain)
ORDER BY
    total ASC,
    domain ASC;

SELECT total
FROM
    (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js1
ALL FULL JOIN (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js2
    USING (total, domain)
ORDER BY
    total ASC,
    domain ASC;

SELECT domain
FROM
    (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js1
ALL FULL JOIN (
        SELECT
            sum(total_count) AS total,
            domain
        FROM (
                SELECT
                    COUNT(*) AS total_count,
                    SUM(if(domain = 'facebook.com', 1, 0)) AS facebookHits,
                    domain
                FROM clicks
                GROUP BY domain
                UNION ALL
                SELECT
                    COUNT(*) AS total_count,
                    toUInt64(0) AS facebookHits,
                    domain
                FROM transactions
                GROUP BY domain
            )
        GROUP BY domain
        ORDER BY domain ASC
        LIMIT 10
    ) AS js2
    USING (total, domain)
ORDER BY
    total ASC,
    domain ASC;

DROP TABLE clicks;

DROP TABLE transactions;
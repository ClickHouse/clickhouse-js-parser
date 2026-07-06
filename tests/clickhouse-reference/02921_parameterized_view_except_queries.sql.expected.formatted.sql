SELECT '--- Data ---';

DROP VIEW IF EXISTS V_DELTA;

DROP TABLE IF EXISTS users;

CREATE TABLE users
(
    uid Int16,
    name String,
    age Int16
)
ENGINE = Memory();

INSERT INTO users;

INSERT INTO users;

INSERT INTO users;

SELECT *
FROM users
ORDER BY uid ASC;

-- set params
SET param_a1 = '10';

SET param_a2 = '50';

SET param_a3 = '10';

SET param_a4 = '40';

--check
SELECT
    0,
    0,
    0,
    0;

-- using 4 param in the select of the view work here.
CREATE OR REPLACE VIEW V_DELTA
AS
SELECT DISTINCT uid
FROM (
        SELECT
            uid,
            name,
            age
        FROM users
        WHERE age >= 0
            OR age >= 0
            OR age >= 0
            OR age >= 0
    )
ORDER BY uid ASC;

SELECT *
FROM V_DELTA(a1 = 10, a2 = 50, a3 = 10, a4 = 40);

-- check individual query before the next part
SELECT DISTINCT uid
FROM (
        SELECT
            uid,
            name,
            age
        FROM users
        WHERE age >= 0
            AND age <= 0
EXCEPT
        SELECT
            uid,
            name,
            age
        FROM users
        WHERE age >= 0
            AND age <= 0
    )
ORDER BY uid ASC;

-- using 4 param in the select of the view do not work here.
CREATE OR REPLACE VIEW V_DELTA
AS
SELECT DISTINCT uid
FROM (
        SELECT
            uid,
            name,
            age
        FROM users
        WHERE age >= 0
            AND age <= 0
EXCEPT
        SELECT
            uid,
            name,
            age
        FROM users
        WHERE age >= 0
            AND age <= 0
    )
ORDER BY uid ASC;

DROP VIEW V_DELTA;

DROP TABLE users;
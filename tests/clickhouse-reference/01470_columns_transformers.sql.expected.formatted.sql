DROP TABLE IF EXISTS columns_transformers;

CREATE TABLE columns_transformers
(
    i Int64,
    j Int16,
    k Int64
)
ENGINE = TinyLog();

INSERT INTO columns_transformers;

SELECT * APPLY(sum)
FROM columns_transformers;

SELECT * APPLY(sum)
FROM columns_transformers;

SELECT columns_transformers.* APPLY(avg)
FROM columns_transformers;

SELECT a.* APPLY(toDate) APPLY(any)
FROM columns_transformers AS a;

SELECT COLUMNS('[jk]') APPLY(toString) APPLY(length)
FROM columns_transformers;

SELECT * EXCEPT (i) APPLY(sum)
FROM columns_transformers;

SELECT columns_transformers.* EXCEPT (j) APPLY(avg)
FROM columns_transformers;

-- EXCEPT after APPLY will not match anything
SELECT a.* APPLY(toDate) EXCEPT (i, j) APPLY(any)
FROM columns_transformers AS a;

SELECT * EXCEPT STRICT (i)
FROM columns_transformers;

SELECT * EXCEPT STRICT (i, j)
FROM columns_transformers;

SELECT
    * EXCEPT STRICT (i),
    j1
FROM columns_transformers; -- { serverError UNKNOWN_IDENTIFIER }

SELECT * EXCEPT STRICT (i, j1)
FROM columns_transformers; -- { serverError NO_SUCH_COLUMN_IN_TABLE , BAD_ARGUMENTS }

SELECT * REPLACE STRICT (i + 1 AS i)
FROM columns_transformers;

SELECT * REPLACE STRICT (i + 1 AS col)
FROM columns_transformers; -- { serverError NO_SUCH_COLUMN_IN_TABLE, BAD_ARGUMENTS }

SELECT * REPLACE (i + 1 AS i) APPLY(sum)
FROM columns_transformers;

SELECT columns_transformers.* REPLACE (j + 2 AS j, i + 1 AS i) APPLY(avg)
FROM columns_transformers;

SELECT columns_transformers.* REPLACE (j + 1 AS j, j + 2 AS j) APPLY(avg)
FROM columns_transformers; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- REPLACE after APPLY will not match anything
SELECT a.* APPLY(toDate) REPLACE (i + 1 AS i) APPLY(any)
FROM columns_transformers AS a;

SELECT a.* APPLY(toDate) REPLACE STRICT (i + 1 AS i) APPLY(any)
FROM columns_transformers AS a; -- { serverError NO_SUCH_COLUMN_IN_TABLE, BAD_ARGUMENTS }

EXPLAIN SYNTAX
SELECT * APPLY(sum)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT columns_transformers.* APPLY(avg)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT a.* APPLY(toDate) APPLY(any)
FROM columns_transformers AS a;

EXPLAIN SYNTAX
SELECT COLUMNS('[jk]') APPLY(toString) APPLY(length)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT * EXCEPT (i) APPLY(sum)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT columns_transformers.* EXCEPT (j) APPLY(avg)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT a.* APPLY(toDate) EXCEPT (i, j) APPLY(any)
FROM columns_transformers AS a;

EXPLAIN SYNTAX
SELECT * REPLACE (i + 1 AS i) APPLY(sum)
FROM columns_transformers;

EXPLAIN AST
SELECT * REPLACE (i + 1 AS i) APPLY(sum)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT sum(i + 1 AS m)
FROM columns_transformers;

EXPLAIN AST
SELECT sum(i + 1 AS m)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT columns_transformers.* REPLACE (j + 2 AS j, i + 1 AS i) APPLY(avg)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT a.* APPLY(toDate) REPLACE (i + 1 AS i) APPLY(any)
FROM columns_transformers AS a;

-- Multiple REPLACE in a row
EXPLAIN SYNTAX
SELECT * REPLACE (i + 1 AS i) REPLACE (i + 1 AS i)
FROM columns_transformers;

-- Explicit column list
SELECT COLUMNS(i, j, k) APPLY(sum)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT COLUMNS(i, j, k) APPLY(sum)
FROM columns_transformers;

-- Multiple column matchers and transformers
SELECT
    i,
    j,
    COLUMNS(i, j, k) APPLY(toFloat64),
    COLUMNS(i, j) EXCEPT (i)
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT
    i,
    j,
    COLUMNS(i, j, k) APPLY(toFloat64),
    COLUMNS(i, j) EXCEPT (i)
FROM columns_transformers;

-- APPLY with parameterized function
SELECT COLUMNS(i, j, k) APPLY(quantiles(0.5))
FROM columns_transformers;

EXPLAIN SYNTAX
SELECT COLUMNS(i, j, k) APPLY(quantiles(0.5))
FROM columns_transformers;

DROP TABLE columns_transformers;
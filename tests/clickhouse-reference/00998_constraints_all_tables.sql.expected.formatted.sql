DROP TABLE IF EXISTS constrained;

CREATE TABLE constrained
(
    URL String,
    CONSTRAINT is_censor CHECK domainWithoutWWW(URL) = 'censor.net',
    CONSTRAINT is_utf8 CHECK isValidUTF8(URL)
)
ENGINE = Null();

INSERT INTO constrained; -- { serverError VIOLATED_CONSTRAINT }

INSERT INTO constrained; -- { serverError VIOLATED_CONSTRAINT }

INSERT INTO constrained;

DROP TABLE constrained;

CREATE TABLE constrained
(
    URL String,
    CONSTRAINT is_censor CHECK domainWithoutWWW(URL) = 'censor.net',
    CONSTRAINT is_utf8 CHECK isValidUTF8(URL)
)
ENGINE = Memory();

SELECT count()
FROM constrained;

CREATE TABLE constrained
(
    URL String,
    CONSTRAINT is_censor CHECK domainWithoutWWW(URL) = 'censor.net',
    CONSTRAINT is_utf8 CHECK isValidUTF8(URL)
)
ENGINE = StripeLog();

CREATE TABLE constrained
(
    URL String,
    CONSTRAINT is_censor CHECK domainWithoutWWW(URL) = 'censor.net',
    CONSTRAINT is_utf8 CHECK isValidUTF8(URL)
)
ENGINE = TinyLog();

CREATE TABLE constrained
(
    URL String,
    CONSTRAINT is_censor CHECK domainWithoutWWW(URL) = 'censor.net',
    CONSTRAINT is_utf8 CHECK isValidUTF8(URL)
)
ENGINE = Log();

DROP TABLE IF EXISTS constrained2;

CREATE TABLE constrained2 AS constrained;

SHOW CREATE TABLE constrained;

SHOW CREATE TABLE constrained2;

INSERT INTO constrained2; -- { serverError VIOLATED_CONSTRAINT }

DROP TABLE constrained2;
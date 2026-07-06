SET enable_analyzer = '1';

DROP TABLE IF EXISTS date_table_pv;

CREATE TABLE date_table_pv
(
    id Int32,
    dt Date
)
ENGINE = Memory();

INSERT INTO date_table_pv;

INSERT INTO date_table_pv;

INSERT INTO date_table_pv;

DROP VIEW IF EXISTS date_pv;

CREATE VIEW date_pv
AS
SELECT *
FROM date_table_pv
WHERE dt = '2020-01-01';

SELECT id
FROM date_pv(dtparam = today());

SELECT id
FROM date_pv(dtparam = yesterday());

SELECT id
FROM date_pv(dtparam = yesterday() + 1);

SELECT id
FROM date_pv(dtparam = '1974-04-07');

SELECT id
FROM date_pv(dtparam = toDate('1974-04-07'));

SELECT id
FROM date_pv(dtparam = toString(toDate('1974-04-07')));

SELECT id
FROM date_pv(dtparam = toDate('1975-04-07'));

SELECT id
FROM date_pv(dtparam = (
        SELECT dt
        FROM date_table_pv
        WHERE id = 2
    ));

DROP TABLE IF EXISTS date32_table_pv;

CREATE TABLE date32_table_pv
(
    id Int32,
    dt Date32
)
ENGINE = Memory();

INSERT INTO date32_table_pv;

INSERT INTO date32_table_pv;

INSERT INTO date32_table_pv;

INSERT INTO date32_table_pv;

INSERT INTO date32_table_pv;

DROP VIEW IF EXISTS date32_pv;

CREATE VIEW date32_pv
AS
SELECT *
FROM date32_table_pv
WHERE dt = '2020-01-01';

SELECT id
FROM date32_pv(dtparam = today());

SELECT id
FROM date32_pv(dtparam = yesterday());

SELECT id
FROM date32_pv(dtparam = yesterday() + 1);

SELECT id
FROM date32_pv(dtparam = '2199-12-31');

SELECT id
FROM date32_pv(dtparam = toDate32('1900-01-01'));

SELECT id
FROM date32_pv(dtparam = (
        SELECT dt
        FROM date32_table_pv
        WHERE id = 3
    ));

SELECT id
FROM date32_pv(dtparam = (
        SELECT dt
        FROM date32_table_pv
        WHERE id = 4
    ));

DROP TABLE IF EXISTS uuid_table_pv;

CREATE TABLE uuid_table_pv
(
    id Int32,
    uu UUID
)
ENGINE = Memory();

INSERT INTO uuid_table_pv;

INSERT INTO uuid_table_pv;

INSERT INTO uuid_table_pv;

INSERT INTO uuid_table_pv SELECT
    4,
    serverUUID();

DROP VIEW IF EXISTS uuid_pv;

CREATE VIEW uuid_pv
AS
SELECT *
FROM uuid_table_pv
WHERE uu = '00000000-0000-0000-0000-000000000000';

SELECT id
FROM uuid_pv(uuidparam = serverUUID());

SELECT id
FROM uuid_pv(uuidparam = toUUID('11111111-2222-3333-4444-555555555555'));

SELECT id
FROM uuid_pv(uuidparam = '11111111-2222-3333-4444-555555555555');

SELECT id
FROM uuid_pv(uuidparam = (
        SELECT uu
        FROM uuid_table_pv
        WHERE id = 1
    ));

SELECT id
FROM uuid_pv(uuidparam = (
        SELECT uu
        FROM uuid_table_pv
        WHERE id = 2
    ));

-- generateUUIDv4() is not constant foldable, hence cannot be used as parameter value
SELECT id
FROM uuid_pv(uuidparam = generateUUIDv4()); -- { serverError UNKNOWN_QUERY_PARAMETER }

-- But nested "select generateUUIDv4()"  works!
SELECT id
FROM uuid_pv(uuidparam = (
        SELECT generateUUIDv4()
    ));

DROP VIEW IF EXISTS date_pv2;

CREATE VIEW date_pv2
AS
SELECT *
FROM date_table_pv
WHERE dt = '2020-01-01'
    AND id = 0;

SELECT id
FROM date_pv2(dtparam = today(), intparam = 1);

SELECT id
FROM date_pv2(dtparam = today(), intparam = length('A'));

SELECT id
FROM date_pv2(dtparam = '1974-04-07', intparam = length('AAA'));

SELECT id
FROM date_pv2(dtparam = toDate('1974-04-07'), intparam = length('BBB'));

DROP TABLE IF EXISTS ipv4_table_pv;

CREATE TABLE ipv4_table_pv
(
    id Int32,
    ipaddr IPv4
)
ENGINE = Memory();

INSERT INTO ipv4_table_pv;

INSERT INTO ipv4_table_pv;

INSERT INTO ipv4_table_pv;

DROP VIEW IF EXISTS ipv4_pv;

CREATE VIEW ipv4_pv
AS
SELECT *
FROM ipv4_table_pv
WHERE ipaddr = '0.0.0.0';

SELECT id
FROM ipv4_pv(ipv4param = '116.106.34.242');

SELECT id
FROM ipv4_pv(ipv4param = toIPv4('116.106.34.243'));

SELECT id
FROM ipv4_pv(ipv4param = (
        SELECT ipaddr
        FROM ipv4_table_pv
        WHERE id = 3
    ));

DROP VIEW date_pv;

DROP VIEW date_pv2;

DROP VIEW date32_pv;

DROP VIEW uuid_pv;

DROP VIEW ipv4_pv;

DROP TABLE date_table_pv;

DROP TABLE date32_table_pv;

DROP TABLE uuid_table_pv;

DROP TABLE ipv4_table_pv;
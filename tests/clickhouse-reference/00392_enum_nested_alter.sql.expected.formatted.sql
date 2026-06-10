DROP TABLE IF EXISTS enum_nested_alter;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE enum_nested_alter
(
    d Date DEFAULT '2000-01-01',
    x UInt64,
    n Nested(a String, e Enum8('Hello' = 1), b UInt8)
)
ENGINE = MergeTree(d, x, 1);

INSERT INTO enum_nested_alter (x, n.e);

SELECT *
FROM enum_nested_alter;

ALTER TABLE enum_nested_alter MODIFY COLUMN `n.e` Array(Enum8('Hello' = 1, 'World' = 2));

INSERT INTO enum_nested_alter (x, n.e);

SELECT *
FROM enum_nested_alter
ORDER BY x ASC;

ALTER TABLE enum_nested_alter MODIFY COLUMN `n.e` Array(Enum16('Hello' = 1, 'World' = 2, 'a' = 300));

ALTER TABLE enum_nested_alter MODIFY COLUMN `n.e` Array(UInt16);

ALTER TABLE enum_nested_alter MODIFY COLUMN `n.e` Array(String);

DROP TABLE enum_nested_alter;

CREATE TABLE enum_nested_alter
(
    d Date DEFAULT '2000-01-01',
    x UInt64,
    tasks Nested(errcategory Enum8('undefined' = 0, 'system' = 1, 'generic' = 2, 'asio.netdb' = 3, 'asio.misc' = 4, 'asio.addrinfo' = 5, 'rtb.client' = 6, 'rtb.logic' = 7, 'http.status' = 8), status Enum16('hello' = 1, 'world' = 2))
)
ENGINE = MergeTree(d, x, 1);

INSERT INTO enum_nested_alter (x, tasks.errcategory, tasks.status);

ALTER TABLE enum_nested_alter MODIFY COLUMN `tasks.errcategory` Array(Enum8('undefined' = 0, 'system' = 1, 'generic' = 2, 'asio.netdb' = 3, 'asio.misc' = 4, 'asio.addrinfo' = 5, 'rtb.client' = 6, 'rtb.logic' = 7, 'http.status' = 8, 'http.code' = 9)), MODIFY COLUMN `tasks.status` Array(Enum8('hello' = 1, 'world' = 2, 'goodbye' = 3));

INSERT INTO enum_nested_alter (x, tasks.errcategory, tasks.status);

CREATE TABLE enum_nested_alter
(
    d Date DEFAULT '2000-01-01',
    x UInt64,
    n Nested(a String, e Enum8('Hello.world' = 1), b UInt8)
)
ENGINE = MergeTree(d, x, 1);

INSERT INTO enum_nested_alter (x, n.e);

ALTER TABLE enum_nested_alter MODIFY COLUMN `n.e` Array(Enum8('Hello.world' = 1, 'a' = 2));
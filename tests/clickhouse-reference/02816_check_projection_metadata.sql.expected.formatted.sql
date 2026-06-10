CREATE TABLE kek
(
    uuid FixedString(16),
    id int,
    ns String,
    dt DateTime64(6),
    PROJECTION null_pk (SELECT * ORDER BY ns, 1, 4)
)
ENGINE = MergeTree()
ORDER BY (id, dt, uuid); -- {serverError ILLEGAL_COLUMN }
-- this query could segfault or throw LOGICAL_ERROR previously, when we did not check projection PK
-- insert into kek select * from generageRandom(10000);
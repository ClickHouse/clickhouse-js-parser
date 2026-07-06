DROP TABLE IF EXISTS local;

DROP TABLE IF EXISTS distr;

CREATE TABLE local
(
    a UInt64,
    b UInt64,
    c UInt64,
    d UInt64,
    e UInt64,
    f UInt64,
    g UInt64,
    h UInt64
)
ENGINE = Log();

CREATE TABLE distr AS local
ENGINE = Distributed('test_cluster_two_shards', currentDatabase(), local);

INSERT INTO local (a) SELECT number
FROM numbers(10);

SET max_columns_to_read = '1';

SELECT count()
FROM
    distr AS l
GLOBAL ALL LEFT JOIN distr AS r
    ON l.a = r.a;
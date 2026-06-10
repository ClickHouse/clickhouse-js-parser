#!/usr/bin/env -S ${HOME}/clickhouse-client --queries-file
DROP TABLE IF EXISTS with_fill_date__fuzz_0;

CREATE TABLE with_fill_date__fuzz_0
(
    d Date,
    d32 Nullable(Int32),
    d33 Int32
)
ENGINE = Memory();

INSERT INTO with_fill_date__fuzz_0;

SELECT count()
FROM with_fill_date__fuzz_0
ORDER BY
    count() ASC,
    count() IGNORE NULLS ASC,
    max(d) ASC WITH FILL STEP toIntervalDay(10);

SELECT count()
FROM with_fill_date__fuzz_0
ORDER BY
    any(d32) RESPECT NULLS ASC,
    any_respect_nulls(d32) ASC,
    max(d) ASC WITH FILL STEP toIntervalDay(10);

SELECT count()
FROM with_fill_date__fuzz_0
ORDER BY
    any(d32) ASC,
    any(d32) IGNORE NULLS ASC,
    any(d32) RESPECT NULLS ASC,
    any_respect_nulls(d32) IGNORE NULLS ASC,
    any_respect_nulls(d32) ASC,
    sum(d33) ASC,
    sum(d33) IGNORE NULLS ASC,
    max(d) ASC WITH FILL STEP toIntervalDay(10);
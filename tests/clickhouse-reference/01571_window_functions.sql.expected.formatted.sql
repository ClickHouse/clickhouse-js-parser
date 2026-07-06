-- { echo }
-- Another test for window functions because the other one is too long.
-- some craziness with a mix of materialized and unmaterialized const columns
-- after merging sorted transform, that used to break the peer group detection in
-- the window transform.
CREATE TABLE order_by_const
(
    a UInt64,
    b UInt64,
    c UInt64,
    d UInt64
)
ENGINE = MergeTree()
ORDER BY (a, b)
SETTINGS index_granularity = '8192';

TRUNCATE TABLE order_by_const;

SYSTEM STOP MERGES order_by_const;

INSERT INTO order_by_const (a, b, c, d);

INSERT INTO order_by_const (a, b, c, d);

INSERT INTO order_by_const (a, b, c, d);

-- output 1 sorted stream
SELECT row_number() OVER (ORDER BY 1 ASC, a ASC)
FROM order_by_const
SETTINGS query_plan_enable_multithreading_after_window_functions = '0';

DROP TABLE order_by_const;

-- expressions in window frame
SELECT count() OVER (ROWS BETWEEN 1 + 1 PRECEDING AND 1 + 1 FOLLOWING)
FROM numbers(10);

-- signed and unsigned in offset do not cause logical error
SELECT count() OVER (ROWS BETWEEN 2 FOLLOWING AND 1 + -1 FOLLOWING)
FROM numbers(10); -- { serverError BAD_ARGUMENTS }

-- default arguments of lagInFrame can be a subtype of the argument
SELECT
    number,
    lagInFrame(toNullable(number), 2, NULL) OVER w,
    lagInFrame(number, 2, 1) OVER w
FROM numbers(10)
WINDOW w AS (ORDER BY number ASC);

-- the case when current_row goes past the partition end at the block end
SELECT
    number,
    row_number() OVER (PARTITION BY number ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)
FROM numbers(4)
SETTINGS max_block_size = '2';
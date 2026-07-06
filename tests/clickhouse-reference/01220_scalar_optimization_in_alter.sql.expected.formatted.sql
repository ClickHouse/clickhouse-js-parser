DROP TABLE IF EXISTS cdp_segments;

DROP TABLE IF EXISTS cdp_customers;

CREATE TABLE cdp_segments
(
    seg_id String,
    mid_seqs AggregateFunction(groupBitmap, UInt32)
)
ENGINE = ReplacingMergeTree()
ORDER BY seg_id;

CREATE TABLE cdp_customers
(
    mid String,
    mid_seq UInt32
)
ENGINE = ReplacingMergeTree()
ORDER BY mid_seq;

ALTER TABLE cdp_segments UPDATE mid_seqs = bitmapOr(mid_seqs, (
    SELECT groupBitmapState(mid_seq)
    FROM cdp_customers
    WHERE mid IN ('6bf3c2ee-2b33-3030-9dc2-25c6c618d141')
)) WHERE seg_id = '1234567890';

DROP TABLE cdp_segments;

DROP TABLE cdp_customers;
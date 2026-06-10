CREATE TABLE labels_unordered
(
    idx Int64,
    score Float64,
    label Int64
)
ENGINE = MergeTree()
PRIMARY KEY idx
ORDER BY idx;

SELECT floor(arrayAUC(array_concat_agg([score]), array_concat_agg([label])), 5)
FROM labels_unordered;

INSERT INTO labels_unordered (idx, score, label);

CREATE TABLE labels_ordered
(
    idx Int64,
    score Float64,
    label Int64
)
ENGINE = MergeTree()
PRIMARY KEY idx
ORDER BY idx;

INSERT INTO labels_ordered (idx, score, label);

SELECT floor(arrayAUC(array_concat_agg([score]), array_concat_agg([label])), 5)
FROM labels_ordered;
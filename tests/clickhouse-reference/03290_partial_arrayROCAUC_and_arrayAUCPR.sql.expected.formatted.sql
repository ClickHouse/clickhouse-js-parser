-- CASE 1
-- scores = [0.1, 0.4, 0.35, 0.8]
-- labels = [0, 0, 1, 1]
SELECT
    floor(arrayAUCPR([0.1, 0.4, 0.35, 0.8], [0, 0, 1, 1]), 10),
    floor(arrayROCAUC([0.1, 0.4, 0.35, 0.8], [0, 0, 1, 1]), 10);

WITH partial_aucs AS (
    SELECT
        arrayAUCPR(scores, labels, pr_offsets) AS partial_pr_auc,
        arrayROCAUC(scores, labels, true, roc_offsets) AS partial_roc_auc
    FROM (
            SELECT
                [0.8] AS scores,
                [1] AS labels,
                [0, 0, 2] AS pr_offsets,
                [0, 0, 2, 2] AS roc_offsets
            UNION ALL
            SELECT
                [0.4] AS scores,
                [0] AS labels,
                [1, 0, 2] AS pr_offsets,
                [1, 0, 2, 2] AS roc_offsets
            UNION ALL
            SELECT
                [0.35] AS scores,
                [1] AS labels,
                [1, 1, 2] AS pr_offsets,
                [1, 1, 2, 2] AS roc_offsets
            UNION ALL
            SELECT
                [0.1] AS scores,
                [0] AS labels,
                [2, 1, 2] AS pr_offsets,
                [2, 1, 2, 2] AS roc_offsets
        )
)

SELECT
    floor(sum(partial_pr_auc), 10),
    floor(sum(partial_roc_auc), 10)
FROM partial_aucs;

WITH partial_aucs AS (
    SELECT
        arrayAUCPR(scores, labels, pr_offsets) AS partial_pr_auc,
        arrayROCAUC(scores, labels, true, roc_offsets) AS partial_roc_auc
    FROM (
            SELECT
                [0.8, 0.4] AS scores,
                [1, 0] AS labels,
                [0, 0, 2] AS pr_offsets,
                [0, 0, 2, 2] AS roc_offsets
            UNION ALL
            SELECT
                [0.35, 0.1] AS scores,
                [1, 0] AS labels,
                [1, 1, 2] AS pr_offsets,
                [1, 1, 2, 2] AS roc_offsets
        )
)

SELECT
    floor(sum(partial_pr_auc), 10),
    floor(sum(partial_roc_auc), 10)
FROM partial_aucs;

-- CASE 2
-- scores = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
-- labels = [1, 0, 1, 0, 0, 0, 1, 0, 0, 1]
SELECT
    floor(arrayAUCPR([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 0, 1, 0, 0, 0, 1, 0, 0, 1]), 10),
    floor(arrayROCAUC([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1, 0, 1, 0, 0, 0, 1, 0, 0, 1]), 10);

-- Example of a more robust query that can be used to calculate AUC for a large dataset
WITH score_with_group AS (
    SELECT
        scores[idx] AS score,
        labels[idx] AS label,
        FLOOR(score / 3) AS `group`
    FROM
        (
            SELECT
                range(1, 11) AS idx,
                [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] AS scores,
                [1, 0, 1, 0, 0, 0, 1, 0, 0, 1] AS labels
        )
    ARRAY JOIN idx
),

grouped_scores AS (
    SELECT
        `group`,
        groupArrayArray(array(score)) AS scores,
        groupArrayArray(array(label)) AS labels,
        countIf(label > 0) AS group_tp,
        countIf(label = 0) AS group_fp,
        COALESCE(SUM(group_tp) OVER (ORDER BY `group` DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS prev_group_tp,
        COALESCE(SUM(group_fp) OVER (ORDER BY `group` DESC ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING), 0) AS prev_group_fp
    FROM score_with_group
    GROUP BY `group`
),

partial_aucs AS (
    SELECT
        arrayAUCPR(scores, labels, [COALESCE(prev_group_tp, 0), COALESCE(prev_group_fp, 0), COALESCE(SUM(group_tp) OVER (), 0)]) AS partial_pr_auc,
        arrayROCAUC(scores, labels, true, [COALESCE(prev_group_tp, 0), COALESCE(prev_group_fp, 0), COALESCE(SUM(group_tp) OVER (), 0), COALESCE(SUM(group_fp) OVER (), 0)]) AS partial_roc_auc
    FROM grouped_scores
)

SELECT
    floor(sum(partial_pr_auc), 10) AS pr_auc,
    floor(sum(partial_roc_auc), 10) AS roc_auc
FROM partial_aucs;
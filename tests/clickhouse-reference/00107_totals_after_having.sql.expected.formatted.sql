SET max_rows_to_group_by = '100000';

SET max_block_size = '100001';

SET group_by_overflow_mode = 'any';

-- 'any' overflow mode might select different values for two-level and
-- single-level GROUP BY, so we set a big enough threshold here to ensure that
-- the switch doesn't happen, we only use single-level GROUP BY and get a
-- predictable result.
SET group_by_two_level_threshold_bytes = '100000000';

SET group_by_two_level_threshold = '1000000';

SET totals_mode = 'after_having_auto';

SELECT
    intDiv(number, 2) AS k,
    count(),
    argMax(toString(number), number)
FROM (
        SELECT number
        FROM `system`.numbers
        LIMIT 500000
    )
GROUP BY k
WITH TOTALS
ORDER BY k ASC
LIMIT 10;

SET totals_mode = 'after_having_inclusive';

SET totals_mode = 'after_having_exclusive';

SET totals_mode = 'before_having';

SET max_bytes_ratio_before_external_group_by = '0';

SET max_bytes_before_external_group_by = '1000000';

SET group_by_two_level_threshold = '100000';
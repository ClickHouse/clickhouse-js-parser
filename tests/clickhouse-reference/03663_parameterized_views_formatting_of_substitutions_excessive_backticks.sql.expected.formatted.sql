DROP VIEW IF EXISTS audit_size_column;

CREATE VIEW audit_size_column
AS
SELECT
    formatReadableSize(size) AS formatted,
    sum(column_bytes_on_disk) AS size,
    column,
    table,
    database
FROM `system`.parts_columns
WHERE active = 1
    AND (database = 'placeholder'
    OR database = currentDatabase())
    AND match(table, 'placeholder')
    AND match(column, 'placeholder')
GROUP BY
    database,
    table,
    column;

DETACH TABLE audit_size_column;

ATTACH TABLE audit_size_column;

SHOW CREATE TABLE audit_size_column FORMAT Raw;

DROP TABLE audit_size_column;
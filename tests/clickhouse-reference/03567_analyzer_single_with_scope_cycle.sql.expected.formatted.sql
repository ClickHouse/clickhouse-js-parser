CREATE TABLE tab
(
    x String,
    y UInt8
)
ENGINE = MergeTree()
ORDER BY tuple();

INSERT INTO tab SELECT
    'rue',
    1;

WITH a AS b

SELECT 1
FROM (
        WITH b AS c

        SELECT 1
        FROM (
                WITH c AS d

                SELECT 1
                FROM (
                        SELECT 1
                        FROM tab
                        WHERE e = 'true'
                    )
            )
    )
SETTINGS allow_experimental_analyzer = '0'; -- { serverError UNKNOWN_IDENTIFIER }

SET enable_scopes_for_with_statement = '0';

WITH a AS b

SELECT 1
FROM (
        WITH b AS c

        SELECT 1
        FROM (
                WITH c AS d

                SELECT 1
                FROM (
                        SELECT 1
                        FROM tab
                        WHERE e = 'true'
                    )
            )
    )
SETTINGS allow_experimental_analyzer = '1'; -- { serverError UNKNOWN_IDENTIFIER }
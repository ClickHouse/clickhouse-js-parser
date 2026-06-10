CREATE TABLE tba
(
    event_id Int64,
    event_dt Int64
)
ENGINE = MergeTree()
ORDER BY event_id;

INSERT INTO tba SELECT
    number % 500,
    20220822
FROM numbers(1000000.);

SELECT count()
FROM (
        SELECT event_dt
        FROM (
                SELECT
                    event_dt,
                    403 AS event_id
                FROM (
                        SELECT event_dt
                        FROM tba AS tba
                        WHERE event_id = 9
                            AND (tba.event_dt >= 20220822
                            AND tba.event_dt <= 20220822)
                    )
            ) AS tba
        WHERE tba.event_dt >= 20220822
            AND tba.event_dt <= 20220822
            AND event_id = 403
    );
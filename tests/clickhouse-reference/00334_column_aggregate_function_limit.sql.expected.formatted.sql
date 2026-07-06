DROP TABLE IF EXISTS ontime;

CREATE TABLE ontime
(
    FlightDate Date,
    Carrier String,
    FlightNum String
)
ENGINE = Memory();

INSERT INTO ontime;

SELECT ignore(finalizeAggregation(Users))
FROM (
        SELECT
            FlightDate,
            Carrier,
            uniqState(FlightNum) AS Users
        FROM ontime
        GROUP BY
            FlightDate,
            Carrier
        LIMIT 1
    );

DROP TABLE ontime;
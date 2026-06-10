DROP TABLE IF EXISTS visits1;

CREATE TABLE visits1
(
    Sign Int8,
    Arr Array(Int8),
    `ParsedParams.Key1` Array(String),
    `ParsedParams.Key2` Array(String),
    CounterID UInt32
)
ENGINE = Memory();

SELECT arrayMap((x -> x * Sign), Arr)
FROM visits1;

SELECT PP.Key2 AS `ym:s:pl2`
FROM
    visits1
ARRAY JOIN `ParsedParams.Key2` AS `PP.Key2`, `ParsedParams.Key1` AS `PP.Key1`, arrayEnumerateUniq(`ParsedParams.Key2`, arrayMap((x_0 -> 1), `ParsedParams.Key1`)) AS `upp_==_yes_`, arrayEnumerateUniq(`ParsedParams.Key2`) AS _uniq_ParsedParams
WHERE CounterID = 100500;

DROP TABLE visits1;

SELECT
    u,
    cumSum
FROM (
        SELECT
            u,
            min(d) AS mn,
            max(d) AS mx,
            groupArray(d) AS dg,
            groupArray(v) AS vg,
            arrayMap((x -> x + mn), range(toUInt32(mx - mn + 1))) AS days,
            toString(arrayCumSum(arrayMap((x -> vg[indexOf(dg, x)]), days))) AS cumSum
        FROM (
                SELECT
                    1 AS u,
                    today() - 1 AS d,
                    1 AS v
            )
        GROUP BY u
    );
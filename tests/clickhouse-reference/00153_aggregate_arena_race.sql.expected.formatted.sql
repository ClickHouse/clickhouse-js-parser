-- Tags: stateful, race
DROP TABLE IF EXISTS dest00153;

CREATE TEMPORARY TABLE dest00153
(
    s AggregateFunction(groupUniqArray, String)
)
ENGINE = Memory();

INSERT INTO dest00153 SELECT groupUniqArrayState(RefererDomain)
FROM test.hits
GROUP BY URLDomain;
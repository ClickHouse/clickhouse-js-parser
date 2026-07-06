-- Tags: no-fasttest
SET enable_json_type = '1';

SELECT dummy
FROM `system`.one
ORDER BY materialize('{"k":"v"}'::JSON) ASC;

SELECT dummy
FROM `system`.one
ORDER BY
    materialize('{"k":"v"}'::JSON) ASC,
    dummy ASC;

SELECT materialize('{"k":"v"}'::JSON)
SETTINGS extremes = '1';
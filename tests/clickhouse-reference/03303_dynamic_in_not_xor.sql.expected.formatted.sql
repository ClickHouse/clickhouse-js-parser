SET enable_dynamic_type = '1';

SELECT
    NOT materialize(1)::Dynamic AS res,
    toTypeName(res);

SELECT
    xor(materialize(1)::Dynamic, materialize(0)::Dynamic) AS res,
    toTypeName(res);

SELECT sum(NOT(CAST(materialize(1) AS Dynamic)) = true);
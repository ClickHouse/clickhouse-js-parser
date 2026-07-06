SELECT CAST('42' AS Dynamic) IN (42); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT materialize(42)::Dynamic IN (42); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT [CAST('42' AS Dynamic)] IN ([42]); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT [materialize(42)::Dynamic] IN ([42]); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT tuple(map(42, CAST('42' AS Dynamic))) IN (tuple(map(42, 42))); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT tuple(map(42, materialize(42)::Dynamic)) IN (tuple(map(42, 42))); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT '{}'::JSON IN ('{}'); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT materialize('{}'::JSON)::Dynamic IN ('{}'); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT ['{}'::JSON] IN (['{}']); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT [materialize('{}')::JSON] IN (['{}']); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT tuple(map(42, '{}'::JSON)) IN (tuple(map(42, '{}'))); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}

SELECT tuple(map(42, materialize('{}')::JSON)) IN (tuple(map(42, '{}'))); -- {serverError ILLEGAL_TYPE_OF_ARGUMENT}
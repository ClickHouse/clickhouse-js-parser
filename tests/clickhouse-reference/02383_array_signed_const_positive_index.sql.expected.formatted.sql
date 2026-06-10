-- { echo }
SELECT materialize([[13]])[CAST('1' AS Int8)];

SELECT materialize([['Hello']])[CAST('1' AS Int8)];

SELECT materialize([13])[CAST('1' AS Int8)];

SELECT materialize(['Hello'])[CAST('1' AS Int8)];

SELECT materialize([[13], [14]])[CAST('2' AS Int8)];

SELECT materialize([['Hello'], ['world']])[CAST('2' AS Int8)];

SELECT materialize([13, 14])[CAST('2' AS Int8)];

SELECT materialize(['Hello', 'world'])[CAST('2' AS Int8)];

SELECT materialize([[13], [14]])[CAST('3' AS Int8)];

SELECT materialize([['Hello'], ['world']])[CAST('3' AS Int8)];

SELECT materialize([13, 14])[CAST('3' AS Int8)];

SELECT materialize(['Hello', 'world'])[CAST('3' AS Int8)];

SELECT materialize([[13], [14]])[CAST('0' AS Int8)];

SELECT materialize([['Hello'], ['world']])[CAST('0' AS Int8)];

SELECT materialize([13, 14])[CAST('0' AS Int8)];

SELECT materialize(['Hello', 'world'])[CAST('0' AS Int8)];

SELECT materialize([[13], [14]])[-1];

SELECT materialize([['Hello'], ['world']])[-1];

SELECT materialize([13, 14])[-1];

SELECT materialize(['Hello', 'world'])[-1];

SELECT materialize([[13], [14]])[-9223372036854775808];

SELECT materialize([['Hello'], ['world']])[-9223372036854775808];

SELECT materialize([13, 14])[-9223372036854775808];

SELECT materialize(['Hello', 'world'])[-9223372036854775808];

SELECT materialize([[toNullable(13)], [14]])[-9223372036854775808];

SELECT materialize([['Hello'], [toNullable('world')]])[-9223372036854775808];

SELECT materialize([13, toNullable(14)])[-9223372036854775808];

SELECT materialize(['Hello', toLowCardinality('world')])[-9223372036854775808];
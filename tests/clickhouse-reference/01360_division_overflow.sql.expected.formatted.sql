SELECT intDiv(materialize(toInt32(1)), 4294967296);

SELECT intDiv(materialize(toInt32(1)), -4294967296);

SELECT intDiv(materialize(toInt32(1)), -9223372036854775808);

SELECT materialize(toInt32(1)) % -9223372036854775808;

SELECT value % -9223372036854775808
FROM (
        SELECT toInt32(arrayJoin([3, 5])) AS value
    );
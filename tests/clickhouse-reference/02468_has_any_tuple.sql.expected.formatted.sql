SELECT [(toUInt8(3), toUInt8(3))] = [(toInt16(3), toInt16(3))];

SELECT hasAny([(toInt16(3), toInt16(3))], [(toInt16(3), toInt16(3))]);

SELECT arrayFilter((x -> x = (toInt16(3), toInt16(3))), arrayZip([toUInt8(3)], [toUInt8(3)]));

SELECT hasAny([(toUInt8(3), toUInt8(3))], [(toInt16(3), toInt16(3))]);
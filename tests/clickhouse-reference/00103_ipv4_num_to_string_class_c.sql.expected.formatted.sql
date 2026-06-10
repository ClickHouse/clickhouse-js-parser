SELECT IPv4NumToStringClassC(toUInt32(0)) = '0.0.0.xxx';

SELECT IPv4NumToStringClassC(2130706433) = '127.0.0.xxx';

SELECT sum(IPv4NumToStringClassC(materialize(toUInt32(0))) = '0.0.0.xxx') = count()
FROM
    `system`.one
ARRAY JOIN range(1024) AS n;

SELECT sum(IPv4NumToStringClassC(materialize(2130706433)) = '127.0.0.xxx') = count()
FROM
    `system`.one
ARRAY JOIN range(1024) AS n;
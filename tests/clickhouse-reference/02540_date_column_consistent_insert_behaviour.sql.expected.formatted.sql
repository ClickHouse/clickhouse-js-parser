DROP TABLE IF EXISTS `02540_date`;

CREATE TABLE `02540_date`
(
    txt String,
    x Date
)
ENGINE = Memory();

-- Date: Supported range of values: [1970-01-01, 2149-06-06].
--                                  ^----closed interval---^
INSERT INTO `02540_date`;

INSERT INTO `02540_date`; -- #43370 weird one -> used to be 1970-01-01

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

-- 65536 will be done using the TZ settings (comments in #45914)
-- We can expect either 1970-01-01 or 1970-01-02
-- time_zone.toDayNum(std::min(time_t(from), time_t(0xFFFFFFFF)))
INSERT INTO `02540_date`;

INSERT INTO `02540_date`; -- Narrowing conversion 65536 ==> 0

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`; -- Narrowing conversion 65536 ==> 0

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

INSERT INTO `02540_date`;

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = '65535';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt16(65535)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toInt32(65535)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt32(65535)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toDate(65535)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65535 as UInt16)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65535 as Int32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65535 as UInt32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65535 as Date)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = '65534';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt16(65534)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toInt32(65534)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt32(65534)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toDate(65534)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65534 as UInt16)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65534 as Int32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65534 as UInt32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65534 as Date)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = '0';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt16(0)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toInt32(0)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt32(0)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toDate(0)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(0 as UInt16)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(0 as Int32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(0 as UInt32)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(0 as Date)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = '65536';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'toInt32(65536)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'toUInt32(65536)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'toDate(65536)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'CAST(65536 as Int32)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'CAST(65536 as UInt32)';

SELECT
    x = CAST(65536 AS Date),
    txt
FROM `02540_date`
WHERE txt = 'CAST(65536 as Date)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'toUInt16(65536)';

SELECT
    x,
    txt
FROM `02540_date`
WHERE txt = 'CAST(65536 as UInt16)';
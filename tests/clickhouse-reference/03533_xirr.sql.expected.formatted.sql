SELECT round(financialInternalRateOfReturnExtended([-10000, 5750, 4250, 3250], [toDate('2020-01-01'), toDate('2020-03-01'), toDate('2020-10-30'), toDate('2021-02-15')]), 6) AS xirr_rate;

SELECT round(financialInternalRateOfReturnExtended([-10000, 5750, 4250, 3250], [toDate('2020-01-01'), toDate('2020-03-01'), toDate('2020-10-30'), toDate('2021-02-15')], 0.5), 6) AS xirr_rate;

SELECT round(financialInternalRateOfReturnExtended([-10000, 5750, 4250, 3250], [toDate32('2020-01-01'), toDate32('2020-03-01'), toDate32('2020-10-30'), toDate32('2021-02-15')]), 6) AS xirr_rate;

SELECT
    round(financialInternalRateOfReturnExtended([100000, -110000], [toDate('2020-01-01'), toDate('2021-01-01')], 0.1, 'ACT_365F'), 6) AS xirr_365,
    round(financialInternalRateOfReturnExtended([100000, -110000], [toDate('2020-01-01'), toDate('2021-01-01')], 0.1, 'ACT_365_25'), 6) AS xirr_365_25;

SELECT financialInternalRateOfReturnExtended(123, toDate('2020-01-01')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturnExtended([123], toDate('2020-01-01')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturnExtended(123, [toDate('2020-01-01')]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT round(financialInternalRateOfReturnExtended([-10000], [toDate32('2020-01-01'), toDate32('2020-03-01'), toDate32('2020-10-30'), toDate32('2021-02-15')]), 6) AS xirr_rate; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT round(financialInternalRateOfReturnExtended([-10000, NULL, 4250, 3250], [toDate32('2020-01-01'), toDate32('2020-03-01'), toDate32('2020-10-30'), toDate32('2021-02-15')]), 6) AS xirr_rate; -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturnExtended([-100, 110], [toDate('2020-01-01'), toDate('2020-02-01')], 1); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturnExtended([-100, 110], [toDate('2020-01-01'), toDate('2020-02-01')], 1., 'QWERTY'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturnExtended(CAST('[]' AS Array(Float32)), CAST('[]' AS Array(Date)));

SELECT financialInternalRateOfReturnExtended([-10000], [toDate('2020-01-01')]);

SELECT financialInternalRateOfReturnExtended([-0., 0.], [toDate('2020-01-01'), toDate('2020-01-02')]);

SELECT round(financialInternalRateOfReturnExtended([-10000, 5750, 4250, 3250], [toDate('2025-01-01'), toDate('2020-03-01'), toDate('2020-10-30'), toDate('2021-02-15')]), 6) AS xirr_rate;

SELECT financialInternalRateOfReturnExtended([-100, 10], [toDate('2020-01-01'), toDate('2020-01-01')]);

CREATE TABLE IF NOT EXISTS `3533_xirr_test`
(
    tag String,
    date Date,
    date32 Date32,
    value Float64,
    r Float64
)
ENGINE = Memory();

INSERT INTO `3533_xirr_test`;

SELECT
    tag,
    round(financialInternalRateOfReturnExtended(groupArray(value), groupArray(date)), 6) AS result_f64_date,
    round(financialInternalRateOfReturnExtended(groupArray(value), groupArray(date32)), 6) AS result_f64_date32,
    round(financialInternalRateOfReturnExtended(groupArray(toFloat32(value)), groupArray(date)), 6) AS result_f32_date,
    round(financialInternalRateOfReturnExtended(groupArray(toFloat32(value)), groupArray(date32)), 6) AS result_f32_date32,
    round(financialInternalRateOfReturnExtended(groupArray(toInt64(value)), groupArray(date)), 6) AS result_i64_date,
    round(financialInternalRateOfReturnExtended(groupArray(toInt64(value)), groupArray(date32)), 6) AS result_i64_date32
FROM (
        SELECT
            tag,
            date,
            date32,
            value
        FROM `3533_xirr_test`
        ORDER BY
            tag ASC,
            date ASC
    )
GROUP BY tag
ORDER BY tag ASC;

SELECT financialInternalRateOfReturn(123); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturn([1, 2, NULL]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialInternalRateOfReturn([]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT
    [-100, 39, 59, 55, 20] AS cf,
    round(financialInternalRateOfReturn(cf), 6) AS irr_rate,
    round(financialNetPresentValue(irr_rate, cf), 6) AS financialNetPresentValue_from_irr;

SELECT financialInternalRateOfReturn([0., 39., 59., 55., 20.]);

SELECT financialNetPresentValueExtended(0.1, 123., [toDate('2020-01-01')]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValueExtended(0.1, [123.], toDate('2020-01-01')); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValueExtended(0.1, [-100, 110], [toDate('2020-01-01'), toDate('2020-02-01')], 'QWERTY'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValueExtended(0.1, [], []); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValueExtended(0.1, [-10], [toDate('2020-01-01')]);

SELECT financialNetPresentValueExtended(0.1, [-0., 0.], [toDate('2020-01-01'), toDate('2020-01-02')]);

SELECT round(financialNetPresentValueExtended(0.1, [-10000., 5750., 4250., 3250.], [toDate('2020-01-01'), toDate('2020-03-01'), toDate('2020-10-30'), toDate('2021-02-15')]), 6);

SELECT round(financialNetPresentValueExtended(0.1, [-10000., 5750., 4250., 3250.], [toDate('2020-01-01'), toDate('2020-03-01'), toDate('2020-10-30'), toDate('2021-02-15')], 'ACT_365_25'), 6);

SELECT
    tag,
    round(financialNetPresentValueExtended(any(r), groupArray(value), groupArray(date)), 6) AS financialNetPresentValueExtended_f64_date,
    round(financialNetPresentValueExtended(any(r), groupArray(value), groupArray(date32)), 6) AS financialNetPresentValueExtended_f64_date32,
    round(financialNetPresentValueExtended(any(toFloat32(r)), groupArray(toFloat32(value)), groupArray(date)), 6) AS financialNetPresentValueExtended_f32_date
FROM (
        SELECT
            tag,
            date,
            date32,
            value,
            r
        FROM `3533_xirr_test`
        ORDER BY
            tag ASC,
            date ASC
    )
GROUP BY tag
ORDER BY tag ASC;

SELECT financialNetPresentValue(0.1, 123., true); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValue(0.1, [1., 2.], 2.); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValue(0.1, [1., NULL]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT financialNetPresentValue(0.1, []); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT round(financialNetPresentValue(0.08, [-40000., 5000., 8000., 12000., 30000.]), 6);

SELECT round(financialNetPresentValue(0.08, [-40000., 5000., 8000., 12000., 30000.], true), 6);

SELECT round(financialNetPresentValue(0.08, [-40000., 5000., 8000., 12000., 30000.], false), 6);

SELECT
    tag,
    round(financialNetPresentValue(any(r), groupArray(value)), 6) AS financialNetPresentValueExtended_f64_date,
    round(financialNetPresentValue(any(r), groupArray(value)), 6) AS financialNetPresentValueExtended_f64_date32,
    round(financialNetPresentValue(any(toFloat32(r)), groupArray(toFloat32(value))), 6) AS financialNetPresentValueExtended_f32_date
FROM (
        SELECT
            tag,
            date,
            date32,
            value,
            r
        FROM `3533_xirr_test`
        ORDER BY
            tag ASC,
            date ASC
    )
GROUP BY tag
ORDER BY tag ASC;

DROP TABLE IF EXISTS `3533_xirr_test`;

SELECT round(financialNetPresentValue(0.1, [-10000, 3000, 4200, 6800], false), 6);

SELECT round(financialNetPresentValue(0.08, [8000., 9200., 10000., 12000., 14500.], false), 6) - 40000;

SELECT round(financialNetPresentValueExtended(0.09, [-10000, 2750, 4250, 3250, 2750], [toDate('2008-01-01'), toDate('2008-03-01'), toDate('2008-10-30'), toDate('2009-02-15'), toDate('2009-04-01')], 'ACT_365F'), 6);

SELECT round(financialInternalRateOfReturn([-70000, 12000, 15000, 18000, 21000, 26000]), 6);

SELECT round(financialInternalRateOfReturnExtended([-10000, 2750, 4250, 3250, 2750], [toDate32('2008-01-01'), toDate32('2008-03-01'), toDate32('2008-10-30'), toDate32('2009-02-15'), toDate32('2009-04-01')]), 6);
DROP TABLE IF EXISTS radacct;

DROP TABLE IF EXISTS mv_traffic_by_tadig15min;

SET allow_deprecated_syntax_for_merge_tree = '1';

CREATE TABLE radacct
(
    radacctid UInt64,
    f3gppchargingid Nullable(String),
    f3gppggsnaddress Nullable(String),
    f3gppggsnmccmnc Nullable(String),
    f3gppgprsqos Nullable(String),
    f3gppimeisv Nullable(String),
    f3gppimsi Nullable(UInt64),
    f3gppimsimccmnc Nullable(String),
    f3gpploci Nullable(String),
    f3gppnsapi Nullable(String),
    f3gpprattype Nullable(String),
    f3gppsgsnaddress Nullable(String),
    f3gppsgsnmccmnc Nullable(String),
    acctdelaytime Nullable(UInt32),
    acctinputoctets Nullable(UInt64),
    acctinputpackets Nullable(UInt64),
    acctoutputoctets Nullable(UInt64),
    acctoutputpackets Nullable(UInt64),
    acctsessionid String,
    acctstatustype Nullable(String),
    acctuniqueid String,
    calledstationid Nullable(String),
    callingstationid Nullable(String),
    framedipaddress Nullable(String),
    nasidentifier Nullable(String),
    nasipaddress Nullable(String),
    acctstarttime Nullable(DateTime),
    acctstoptime Nullable(DateTime),
    acctsessiontime Nullable(UInt32),
    acctterminatecause Nullable(String),
    acctstartdelay Nullable(UInt32),
    acctstopdelay Nullable(UInt32),
    connectinfo_start Nullable(String),
    connectinfo_stop Nullable(String),
    timestamp DateTime,
    username Nullable(String),
    realm Nullable(String),
    f3gppimsi_int UInt64,
    f3gppsgsnaddress_int Nullable(UInt32),
    timestamp_date Date,
    tac Nullable(String),
    mnc Nullable(String),
    tadig LowCardinality(String),
    country LowCardinality(String),
    tadig_op_ip Nullable(String) DEFAULT CAST('TADIG NOT FOUND' AS Nullable(String)),
    mcc Nullable(UInt16) MATERIALIZED toUInt16OrNull(substring(f3gppsgsnmccmnc, 1, 6))
)
ENGINE = MergeTree(timestamp_date, (timestamp, radacctid, acctuniqueid), 8192);

INSERT INTO radacct;

SELECT any(acctstatustype = 'Stop')
FROM radacct
WHERE acctstatustype = 'Stop'
    AND acctinputoctets + acctoutputoctets > 0;

CREATE MATERIALIZED VIEW mv_traffic_by_tadig15min
ENGINE = AggregatingMergeTree()
ORDER BY (ts, tadig)
PARTITION BY tadig
POPULATE
AS
SELECT
    toStartOfFifteenMinutes(timestamp) AS ts,
    toDayOfWeek(timestamp) AS dow,
    tadig,
    sumState(acctinputoctets + acctoutputoctets) AS traffic_bytes,
    maxState(timestamp) AS last_stop,
    minState(radacctid) AS min_radacctid,
    maxState(radacctid) AS max_radacctid
FROM radacct
WHERE acctstatustype = 'Stop'
    AND acctinputoctets + acctoutputoctets > 0
GROUP BY
    tadig,
    ts,
    dow;

SELECT
    tadig,
    ts,
    dow,
    sumMerge(traffic_bytes),
    maxMerge(last_stop),
    minMerge(min_radacctid),
    maxMerge(max_radacctid)
FROM mv_traffic_by_tadig15min
GROUP BY
    tadig,
    ts,
    dow;
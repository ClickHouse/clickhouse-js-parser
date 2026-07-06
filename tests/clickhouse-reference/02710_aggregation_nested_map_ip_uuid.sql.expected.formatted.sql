DROP TABLE IF EXISTS summing_table;

CREATE TABLE summing_table
(
    id UInt32,
    `ip4Map.value` Array(IPv4),
    `ip4Map.total` Array(UInt32),
    `ip6Map.value` Array(IPv6),
    `ip6Map.total` Array(UInt32),
    `uuidMap.value` Array(UUID),
    `uuidMap.total` Array(UInt32)
)
ENGINE = SummingMergeTree()
ORDER BY id;

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

OPTIMIZE TABLE summing_table FINAL;

SELECT *
FROM summing_table
ORDER BY
    id ASC,
    ip4Map.value ASC,
    ip4Map.total ASC,
    ip6Map.value ASC,
    ip6Map.total ASC,
    uuidMap.value ASC,
    uuidMap.total ASC;

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

INSERT INTO summing_table (id, ip4Map.value, ip4Map.total, ip6Map.value, ip6Map.total, uuidMap.value, uuidMap.total);

DROP TABLE summing_table;
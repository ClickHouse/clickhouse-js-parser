DROP TABLE IF EXISTS mt;

CREATE TABLE mt
(
    n int,
    s String
)
ENGINE = MergeTree()
ORDER BY n;

INSERT INTO mt;

SET allow_nondeterministic_mutations = '1';

ALTER TABLE mt UPDATE s = (
    SELECT toString(groupArray((*,)))
    FROM `system`.zookeeper
    WHERE path = '/'
) WHERE n = 1 SETTINGS mutations_sync = '2';

SELECT DISTINCT n
FROM mt;

DROP TABLE mt;
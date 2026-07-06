-- Tags: long, replica
DROP TABLE IF EXISTS replicated_constraints1;

DROP TABLE IF EXISTS replicated_constraints2;

CREATE TABLE replicated_constraints1
(
    a UInt32,
    b UInt32,
    CONSTRAINT a_constraint CHECK a < 10
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00988/alter_constraints', 'r1')
ORDER BY a;

CREATE TABLE replicated_constraints2
(
    a UInt32,
    b UInt32,
    CONSTRAINT a_constraint CHECK a < 10
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{database}/test_00988/alter_constraints', 'r2')
ORDER BY a;

INSERT INTO replicated_constraints1;

INSERT INTO replicated_constraints2;

SYSTEM SYNC REPLICA replicated_constraints1;

SYSTEM SYNC REPLICA replicated_constraints2;

INSERT INTO replicated_constraints1; -- { serverError VIOLATED_CONSTRAINT }

ALTER TABLE replicated_constraints1 DROP CONSTRAINT a_constraint SETTINGS alter_sync = '2';

INSERT INTO replicated_constraints2;

ALTER TABLE replicated_constraints1 ADD CONSTRAINT b_constraint CHECK b > 10 SETTINGS alter_sync = '2';

ALTER TABLE replicated_constraints2 ADD CONSTRAINT a_constraint CHECK a < 10 SETTINGS alter_sync = '2';

INSERT INTO replicated_constraints1; -- { serverError VIOLATED_CONSTRAINT }

INSERT INTO replicated_constraints2; -- { serverError VIOLATED_CONSTRAINT }

DROP TABLE replicated_constraints1;

DROP TABLE replicated_constraints2;
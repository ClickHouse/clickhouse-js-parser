CREATE TABLE t02155_t64_tz
(
    a DateTime64(9, 'America/Chicago')
)
ENGINE = Memory();

CREATE TABLE t02155_t_tz
(
    a DateTime('America/Chicago')
)
ENGINE = Memory();

DROP TABLE t02155_t64_tz;

DROP TABLE t02155_t_tz;
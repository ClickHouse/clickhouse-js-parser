DROP TABLE IF EXISTS data_01817;

DROP TABLE IF EXISTS buffer_01817;

CREATE TABLE data_01817
(
    key Int
)
ENGINE = Null();

-- w/ flush_*
CREATE TABLE buffer_01817
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data_01817, 1, 1, 86400, 1000000000., 1000000., 0, 4000000., 86400, 10, 0);

DROP TABLE buffer_01817;

-- w/o flush_*
CREATE TABLE buffer_01817
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data_01817, 1, 1, 86400, 1000000000., 1000000., 0, 4000000.);

-- not enough args
CREATE TABLE buffer_01817
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data_01817, 1, 1, 86400, 1000000000., 1000000., 0); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

-- too much args
CREATE TABLE buffer_01817
(
    key Int
)
ENGINE = Buffer(currentDatabase(), data_01817, 1, 1, 86400, 1000000000., 1000000., 0, 4000000., 86400, 10, 0, 0); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

DROP TABLE data_01817;
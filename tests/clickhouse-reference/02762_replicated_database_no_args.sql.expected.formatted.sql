-- Tags: no-parallel
CREATE DATABASE replicated_db_no_args
ENGINE = Replicated(); -- { serverError BAD_ARGUMENTS }
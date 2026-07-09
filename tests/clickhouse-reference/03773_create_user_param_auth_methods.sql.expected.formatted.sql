-- Tags: no-fasttest, no-parallel, no-replicated-database
-- Tag no-replicated-database: ON CLUSTER is not allowed
-- Test for issue #92010: Query parameters in authentication methods with ON CLUSTER
DROP USER IF EXISTS user_param_auth_03773;

SET param_password = 'test_password_03773';

-- Before fix: This would fail with UNKNOWN_QUERY_PARAMETER on remote nodes
CREATE USER user_param_auth_03773 IDENTIFIED WITH plaintext_password BY 'placeholder' ON CLUSTER test_shard_localhost;
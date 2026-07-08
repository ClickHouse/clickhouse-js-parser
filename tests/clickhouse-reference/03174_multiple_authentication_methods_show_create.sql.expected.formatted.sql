-- Tags: no-fasttest, no-parallel
-- Create user with mix both implicit and explicit auth type, starting with with
CREATE USER u_03174_multiple_auth_show_create IDENTIFIED WITH plaintext_password BY '1', BY '2', WITH bcrypt_password BY '3', BY '4';

SHOW CREATE USER u_03174_multiple_auth_show_create;

DROP USER IF EXISTS u_03174_multiple_auth_show_create;

-- Create user with mix both implicit and explicit auth type, starting with by
CREATE USER u_03174_multiple_auth_show_create IDENTIFIED BY '1', WITH plaintext_password BY '2', WITH bcrypt_password BY '3', BY '4';
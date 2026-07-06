SET allow_experimental_variant_type = '1';

CREATE TABLE test
(
    v Variant()
)
ENGINE = Variant(); -- {serverError BAD_ARGUMENTS}
DROP TABLE IF EXISTS enum_as_num;

CREATE TABLE enum_as_num
(
    Id Int32,
    Value Enum('a' = 1, '3' = 2, 'b' = 3)
)
ENGINE = Memory();

INSERT INTO enum_as_num FORMAT TSV;
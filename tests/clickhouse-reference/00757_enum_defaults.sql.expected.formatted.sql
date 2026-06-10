DROP TABLE IF EXISTS auto_assign_enum;

DROP TABLE IF EXISTS auto_assign_enum1;

DROP TABLE IF EXISTS auto_assign_enum2;

DROP TABLE IF EXISTS auto_assign_enum3;

CREATE TABLE auto_assign_enum
(
    x enum('a', 'b')
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO auto_assign_enum;

SELECT *
FROM auto_assign_enum;

SELECT CAST(x AS Int8)
FROM auto_assign_enum;

SELECT *
FROM auto_assign_enum
WHERE x = 1;

CREATE TABLE auto_assign_enum1
(
    x enum('a' = -1000, 'b')
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO auto_assign_enum1;

SELECT *
FROM auto_assign_enum1;

SELECT CAST(x AS Int16)
FROM auto_assign_enum1;

SELECT *
FROM auto_assign_enum1
WHERE x = -999;

CREATE TABLE auto_assign_enum2
(
    x enum('a' = -1000, 'b', 'c' = -99)
)
ENGINE = MergeTree()
ORDER BY x; -- { serverError UNEXPECTED_AST_STRUCTURE }

CREATE TABLE auto_assign_enum2
(
    x Enum8('00' = -128, '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '1A', '1B', '1C', '1D', '1E', '1F', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '2A', '2B', '2C', '2D', '2E', '2F', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '3A', '3B', '3C', '3D', '3E', '3F', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '4A', '4B', '4C', '4D', '4E', '4F', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '5A', '5B', '5C', '5D', '5E', '5F', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '6A', '6B', '6C', '6D', '6E', '6F', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '7A', '7B', '7C', '7D', '7E', '7F')
)
ENGINE = MergeTree()
ORDER BY x;

INSERT INTO auto_assign_enum2;

SELECT CAST(x AS Int8)
FROM auto_assign_enum2;

CREATE TABLE auto_assign_enum3
(
    x enum('a', 'b', NULL)
)
ENGINE = MergeTree()
ORDER BY x; -- { serverError UNEXPECTED_AST_STRUCTURE }

DROP TABLE auto_assign_enum;

DROP TABLE auto_assign_enum1;

DROP TABLE auto_assign_enum2;
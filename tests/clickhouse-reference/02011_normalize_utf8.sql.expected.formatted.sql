-- Tags: no-fasttest
DROP TABLE IF EXISTS normalize_test;

CREATE TABLE normalize_test
(
    id int,
    value String
)
ENGINE = MergeTree()
ORDER BY value;

SELECT
    'ё' AS norm,
    'ё' AS denorm,
    length(norm),
    length(denorm),
    normalizeUTF8NFC(norm) AS norm_nfc,
    normalizeUTF8NFC(denorm) AS denorm_nfc,
    length(norm_nfc),
    length(denorm_nfc);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

INSERT INTO normalize_test (id, value);

SELECT
    id,
    value,
    length(value),
    normalizeUTF8NFC(value) AS nfc,
    length(nfc) AS nfc_len,
    normalizeUTF8NFD(value) AS nfd,
    length(nfd) AS nfd_len,
    normalizeUTF8NFKC(value) AS nfkc,
    length(nfkc) AS nfkc_len,
    normalizeUTF8NFKD(value) AS nfkd,
    length(nfkd) AS nfkd_len
FROM normalize_test
ORDER BY id ASC;

SELECT
    char(228) AS value,
    normalizeUTF8NFC(value); -- { serverError CANNOT_NORMALIZE_STRING }

SELECT
    char(228) AS value,
    normalizeUTF8NFD(value); -- { serverError CANNOT_NORMALIZE_STRING }

SELECT
    char(228) AS value,
    normalizeUTF8NFKC(value); -- { serverError CANNOT_NORMALIZE_STRING }

SELECT
    char(228) AS value,
    normalizeUTF8NFKD(value); -- { serverError CANNOT_NORMALIZE_STRING }
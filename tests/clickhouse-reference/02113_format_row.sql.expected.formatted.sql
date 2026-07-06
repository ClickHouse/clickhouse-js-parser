SET output_format_write_statistics = '0';

SELECT formatRow('TSVWithNamesAndTypes', number, toDate(number))
FROM numbers(5);

SELECT formatRow('CSVWithNamesAndTypes', number, toDate(number))
FROM numbers(5);

SELECT formatRow('JSONCompactEachRowWithNamesAndTypes', number, toDate(number))
FROM numbers(5);

SELECT formatRow('XML', number, toDate(number))
FROM numbers(5);
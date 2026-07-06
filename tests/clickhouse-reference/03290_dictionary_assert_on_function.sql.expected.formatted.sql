CREATE DICTIONARY default.currency_conversion_dict
(
    a String,
    b Decimal(18, 8)
)
PRIMARY KEY a
SOURCE(clickhouse(TABLE '' STRUCTURE (A String B Decimal(18, 8))))
LIFETIME(MIN 0 MAX 3600)
LAYOUT(FLAT()); -- {serverError INCORRECT_DICTIONARY_DEFINITION}
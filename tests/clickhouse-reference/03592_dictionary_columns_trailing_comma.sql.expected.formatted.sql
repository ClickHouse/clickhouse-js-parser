CREATE DICTIONARY t_03592
(
    k UInt64,
    v Decimal(8)
)
PRIMARY KEY k
SOURCE(http(URL 'http://example.test/' FORMAT 'TSV'))
LIFETIME(MIN 0 MAX 1000)
LAYOUT(FLAT());
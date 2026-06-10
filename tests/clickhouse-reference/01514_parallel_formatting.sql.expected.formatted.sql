DROP TABLE IF EXISTS tsv;

SET output_format_parallel_formatting = '1';

SET max_read_buffer_size = '1048576';

SET max_block_size = '65505';

CREATE TABLE tsv
(
    a int,
    b int DEFAULT 7
)
ENGINE = File(TSV);

INSERT INTO tsv (a) SELECT number
FROM numbers(10000000);

SELECT count()
FROM tsv;

DROP TABLE tsv;
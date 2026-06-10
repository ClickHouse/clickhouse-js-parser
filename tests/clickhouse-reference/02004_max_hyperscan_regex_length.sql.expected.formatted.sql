-- Tags: no-debug, no-fasttest, use-vectorscan
SET max_hyperscan_regexp_length = '1';

SET max_hyperscan_regexp_total_length = '1';

SELECT multiMatchAny('123', ['1']);

SELECT multiMatchAny('123', ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAny('123', ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAnyIndex('123', ['1']);

SELECT multiMatchAnyIndex('123', ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAnyIndex('123', ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAllIndices('123', ['1']);

SELECT multiMatchAllIndices('123', ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAllIndices('123', ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAny('123', 0, ['1']);

SELECT multiFuzzyMatchAny('123', 0, ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAny('123', 0, ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAnyIndex('123', 0, ['1']);

SELECT multiFuzzyMatchAnyIndex('123', 0, ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAnyIndex('123', 0, ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAllIndices('123', 0, ['1']);

SELECT multiFuzzyMatchAllIndices('123', 0, ['12']); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAllIndices('123', 0, ['1', '2']); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAny(materialize('123'), materialize(['1']));

SELECT multiMatchAny(materialize('123'), materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAny(materialize('123'), materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAnyIndex(materialize('123'), materialize(['1']));

SELECT multiMatchAnyIndex(materialize('123'), materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAnyIndex(materialize('123'), materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAllIndices(materialize('123'), materialize(['1']));

SELECT multiMatchAllIndices(materialize('123'), materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiMatchAllIndices(materialize('123'), materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAny(materialize('123'), 0, materialize(['1']));

SELECT multiFuzzyMatchAny(materialize('123'), 0, materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAny(materialize('123'), 0, materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAnyIndex(materialize('123'), 0, materialize(['1']));

SELECT multiFuzzyMatchAnyIndex(materialize('123'), 0, materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAnyIndex(materialize('123'), 0, materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAllIndices(materialize('123'), 0, materialize(['1']));

SELECT multiFuzzyMatchAllIndices(materialize('123'), 0, materialize(['12'])); -- { serverError BAD_ARGUMENTS }

SELECT multiFuzzyMatchAllIndices(materialize('123'), 0, materialize(['1', '2'])); -- { serverError BAD_ARGUMENTS }
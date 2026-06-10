SELECT initializeAggregation('sumMap', [1, 2, 1], [1, 1, 1], [-1, NULL, 10]);

SELECT initializeAggregation('sumMap', [1, 2, 1], [1, 1, 1], [-1, NULL, NULL]);

SELECT initializeAggregation('sumMap', [1, 2, 1], [1, 1, 1], [NULL, NULL, NULL]); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT initializeAggregation('sumMap', [1, 2, 1], [1, 1, 1], [-1, 10, 10]);

SELECT initializeAggregation('sumMap', [1, 2, 1], [1, 1, 1], [-1, 10, NULL]);
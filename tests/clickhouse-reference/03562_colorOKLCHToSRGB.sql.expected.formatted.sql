SELECT '--- Wrong arguments';

SELECT colorOKLCHToSRGB(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT colorOKLCHToSRGB(1, 2); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorOKLCHToSRGB((1, 2)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorOKLCHToSRGB((1, 'a', 3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorOKLCHToSRGB((1, 2, 3), 'a'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

WITH colorOKLCHToSRGB((0, 0, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.628, 0.2577, 29.23)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.8664, 0.294827, 142.4953)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.452, 0.313214, 264.052)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.0823, 0.008, 240.75)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.833, 0.264, 144.44)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.5701, 0.194, 293.9)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.4466, 0.0991, 45.44), 1.) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.4466, 0.0991, 45.44), 1.8) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.4466, 0.0991, 45.44), 2.2) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.4466, 0.0991, 45.44), 2.4) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.4466, 0.0991, 45.44), 3.) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.6, 0, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((-0.591, 0.1047, 57.35)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.591, 0.1047, 237.35), 0) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.591, 0.1047, 237.35), -1000) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((0.591, 0.1047, 237.35), 1000) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((1000., 1000000., 180)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorOKLCHToSRGB((1000., 1000000., 180), materialize(0.)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));
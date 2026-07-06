SELECT '--- Wrong arguments';

SELECT colorSRGBToOKLAB(); -- { serverError NUMBER_OF_ARGUMENTS_DOESNT_MATCH }

SELECT colorSRGBToOKLAB(1, 2); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorSRGBToOKLAB((1, 2)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorSRGBToOKLAB((1, 'a', 3)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorSRGBToOKLAB((1, 2, 3), 'a'); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorSRGBToOKLAB((1, 2, 3), (4, 5, 6)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

SELECT colorSRGBToOKLAB((1, 2, 3, 4)); -- { serverError ILLEGAL_TYPE_OF_ARGUMENT }

-- Black (0, 0, 0)
WITH colorSRGBToOKLAB((0, 0, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- White (255, 255, 255)
WITH colorSRGBToOKLAB((255, 255, 255)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Red (255, 0, 0)
WITH colorSRGBToOKLAB((255, 0, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Green (0, 255, 0)
WITH colorSRGBToOKLAB((0, 255, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Blue (0, 0, 255)
WITH colorSRGBToOKLAB((0, 0, 255)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Yellow (255, 255, 0)
WITH colorSRGBToOKLAB((255, 255, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Cyan (0, 255, 255)
WITH colorSRGBToOKLAB((0, 255, 255)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Magenta (255, 0, 255)
WITH colorSRGBToOKLAB((255, 0, 255)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Gray (128, 128, 128)
WITH colorSRGBToOKLAB((128, 128, 128)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Dark Gray (64, 64, 64)
WITH colorSRGBToOKLAB((64, 64, 64)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Light Gray (192, 192, 192)
WITH colorSRGBToOKLAB((192, 192, 192)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Orange (255, 128, 0)
WITH colorSRGBToOKLAB((255, 128, 0)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Purple (128, 0, 128)
WITH colorSRGBToOKLAB((128, 0, 128)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Brown (165, 42, 42)
WITH colorSRGBToOKLAB((165, 42, 42)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Pink (255, 192, 203)
WITH colorSRGBToOKLAB((255, 192, 203)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Navy (0, 0, 128)
WITH colorSRGBToOKLAB((0, 0, 128)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Same color (128, 64, 32) with different gamma values
WITH colorSRGBToOKLAB((128, 64, 32), 1.) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((128, 64, 32), 1.8) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((128, 64, 32), 2.2) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((128, 64, 32), 2.4) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((128, 64, 32), 3.) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Very dark color (almost black)
WITH colorSRGBToOKLAB((1, 1, 1)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Almost white
WITH colorSRGBToOKLAB((254, 254, 254)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Negative RGB values (implementation-defined)
WITH colorSRGBToOKLAB((-10, -20, -30)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- RGB > 255 (implementation-defined)
WITH colorSRGBToOKLAB((300, 400, 500)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Gamma = 0 (should use fallback)
WITH colorSRGBToOKLAB((128, 64, 32), 0) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Negative gamma (implementation-defined)
WITH colorSRGBToOKLAB((128, 64, 32), -1000) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Very large gamma
WITH colorSRGBToOKLAB((128, 64, 32), 1000) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Very small gamma (close to 0)
WITH colorSRGBToOKLAB((128, 64, 32), 0.01) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Very large RGB values
WITH colorSRGBToOKLAB((1000000., 1000000., 1000000.)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Mixed edge cases
WITH colorSRGBToOKLAB((255, 0, 128)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Test with materialized gamma (non-constant)
WITH colorSRGBToOKLAB((128, 64, 32), materialize(2.2)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((255, 128, 0), materialize(1.8)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((1000000., 1000000., 1000000.), materialize(0.)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- These test that converting sRGB -> OKLAB -> sRGB gives back approximately the same values
WITH colorSRGBToOKLAB((128, 64, 32)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((255, 0, 0)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((0, 255, 0)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((0, 0, 255)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((128, 128, 128)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((255, 128, 0)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((0, 0, 0)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((255, 255, 255)) AS lab,

colorOKLABToSRGB(lab) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

-- Test that same gamma in both directions produces round-trip
WITH colorSRGBToOKLAB((200, 100, 50), 1.8) AS lab,

colorOKLABToSRGB(lab, 1.8) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((200, 100, 50), 2.4) AS lab,

colorOKLABToSRGB(lab, 2.4) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

WITH colorSRGBToOKLAB((200, 100, 50), 3.) AS lab,

colorOKLABToSRGB(lab, 3.) AS rgb_back

SELECT tuple(round((rgb_back).1, 2), round((rgb_back).2, 2), round((rgb_back).3, 2));

-- Test with different numeric types in tuple
WITH colorSRGBToOKLAB((toFloat32(128), toFloat64(64), toInt32(32))) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((toUInt8(255), toUInt16(128), toUInt32(0))) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

WITH colorSRGBToOKLAB((toInt8(100), toInt16(50), toInt32(25))) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- Mix of types with gamma
WITH colorSRGBToOKLAB((toUInt8(200), toUInt8(100), toUInt8(50)), toFloat64(2.2)) AS t

SELECT tuple(round((t).1, 6), round((t).2, 6), round((t).3, 6));

-- These test against expected OKLAB values for standard sRGB colors
-- Black should be approximately (0, 0, 0)
WITH colorSRGBToOKLAB((0, 0, 0)) AS t

SELECT (t).1 < 0.001
    AND abs((t).2) < 0.001
    AND abs((t).3) < 0.001;

-- White should be approximately (1, 0, 0)
WITH colorSRGBToOKLAB((255, 255, 255)) AS t

SELECT abs((t).1 - 1.) < 0.001
    AND abs((t).2) < 0.001
    AND abs((t).3) < 0.001;

-- Gray should have a and b near 0 (achromatic)
WITH colorSRGBToOKLAB((128, 128, 128)) AS t

SELECT abs((t).2) < 0.001
    AND abs((t).3) < 0.001;

-- Red should have positive a (towards red)
WITH colorSRGBToOKLAB((255, 0, 0)) AS t

SELECT (t).2 > 0;

-- Green should have negative a (towards green)
WITH colorSRGBToOKLAB((0, 255, 0)) AS t

SELECT (t).2 < 0;

-- Blue should have negative b (towards blue)
WITH colorSRGBToOKLAB((0, 0, 255)) AS t

SELECT (t).3 < 0;

-- Yellow should have positive b (towards yellow)
WITH colorSRGBToOKLAB((255, 255, 0)) AS t

SELECT (t).3 > 0;
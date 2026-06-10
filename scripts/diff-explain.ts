#!/usr/bin/env tsx

/**
 * Shows the EXPLAIN AST produced by formatExplain() for one or more reference
 * cases, the expected explain output committed in tests/clickhouse-reference, and
 * the diff between them.
 *
 * The expected file holds one entry per statement separated by blank lines, and
 * entries may be the placeholders `<Query Parameters>` or `<Explain Error>` (cases
 * ClickHouse could not explain). Those placeholders are preserved verbatim in the
 * actual output so they don't show up as spurious diffs.
 *
 * Run via: npm run diff:explain -- <reference> [options]   (see --help)
 */

import { computeExplain, parseCli, run } from './diff-lib.js';

const opts = parseCli(
  process.argv,
  'diff:explain',
  'formatExplain() output vs. expected explain output',
);

run(opts, '.expected.explain.txt', computeExplain);

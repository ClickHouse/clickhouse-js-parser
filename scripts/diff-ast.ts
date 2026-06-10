#!/usr/bin/env tsx

/**
 * Shows the AST produced by parse() for one or more reference cases, the expected
 * AST committed in tests/clickhouse-reference, and the diff between them.
 *
 * Run via: npm run diff:ast -- <reference> [options]   (see --help)
 */

import { computeAst, normalizeAstJson, parseCli, run } from './diff-lib.js';

const opts = parseCli(process.argv, 'diff:ast', 'parsed AST vs. expected AST');

// Normalize both sides by sorting object keys so reorderings of properties within an
// AST object aren't reported as diffs.
run(opts, '.expected.ast.json', (sql, expected) => computeAst(sql, expected), normalizeAstJson);

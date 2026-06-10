#!/usr/bin/env tsx

/**
 * Prints the AST produced by parse() for one or more reference cases, or for a raw
 * SQL string passed via --sql. Includes the library-only underscore-prefixed fields
 * (`_name`, `_fmt`, `_fmt_src`, ...) and comments; only the volatile `location`/`parent`
 * keys are stripped.
 *
 * Run via: npm run parse -- <reference> [options]
 *          npm run parse -- --sql "<SQL>"     (see --help)
 */

import { computeAstFull, parseOutputCli, runOutput } from './diff-lib.js';

const opts = parseOutputCli(process.argv, 'parse', 'parsed AST');

runOutput(opts, (sql) => computeAstFull(sql));

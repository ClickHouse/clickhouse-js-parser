#!/usr/bin/env tsx

/**
 * Prints the AST produced by parse() for one or more reference cases, or for a raw
 * SQL string passed via --sql. Includes the library-only underscore-prefixed fields
 * (`_name`, `_fmt`, `_fmt_src`, ...) and comments; the circular `parent` key is always
 * stripped. Each node's source `location` range is included by default and can be
 * omitted with `--no-locations` (mirroring parse()'s `locations` option).
 *
 * Run via: npm run parse -- <reference> [options]
 *          npm run parse -- --sql "<SQL>"     (see --help)
 */

import { computeAstFull, parseOutputCli, runOutput } from './diff-lib.js';

const opts = parseOutputCli(process.argv, 'parse', 'parsed AST');

runOutput(opts, (sql) => computeAstFull(sql, opts.locations));

# Claude Development Guide

## AST Shape

- The AST is intended to be a superset of ClickHouse's native AST, as produced by `EXPLAIN AST json=1 ...` from the `./clickhouse` binary.
- The AST includes additional properties for tracking source locations of each node, comments, and a few non-semantic properties required for formatExplain(). 
    - Deviations from the reference AST are permitted ONLY (a) to support library-only features such as query parameter parsing and comment round-tripping or (b) to represent semantic information not inferrable from the reference AST.
    - Semantics-preserving canonicalizations of formatted SQL are permitted and preferred over non-reference additions to the AST.
- The AST types and should not use `any` or `unknown` - they should be fully-typed, and discriminated unions should be used wherever possible to make type narrowing via type guards possible and make casting unnecessary.

## Best Practices

- Formatting functions (like `format()` or `formatExplain()` should not include parsing code. The parser should do all parsing, and store structured data in the AST. The formatter should then format SQL based solely on the AST data, without further parsing being required).
- In the grammar, use PEG grammar rules for parsing, not JavaScript code.
- All AST node `type`s should be included in `ASTNodeTypeMap` (and therefore `ASTNode`).
- All AST node types should include comment, location, and parent metadata.
- No syntax should be stored in the AST as raw strings when it is a syntactical structure. The AST should have enough information that a user could fully understand the input statement without further parsing of any raw strings.

## Non-Semantic Fields for Explain Formatting

- Some library-only fields (e.g. `with_trailing`, `agg_repeat`, `settings_before_format`, `settings_after_order_by`, `no_parens`) are non-semantic and exist ONLY to let `formatExplain()` reproduce ClickHouse's `EXPLAIN AST` text dump, which exposes internal child ordering/duplication that the `json=1` reference AST discards. They are absent from the reference AST, so `formatJsonExplain()` (used by the reference ast test) strips them along with node metadata. They are documented under "Non-Semantic Fields for Explain Formatting" in the README.
- These fields MUST be used only by `formatExplain()`. NEVER read them in `format()`; `format()` must emit a single canonical SQL form and treat the source variation these fields record as a semantics-preserving canonicalization.
- To add or change the set of library-only fields that the reference AST omits, update the `LIBRARY_ONLY_FIELDS` map in `src/json-explain.ts`, listing every node `type` each field is allowed on (so a same-named reference field on another node type is never dropped). Generally, strive to avoid doing this unless there is no way to capture or infer all semantic information from the reference fields alone. Semantics-preserving canonicalization of formatted SQL is preferable to introducing new library-only fields.
import type { Statement, ASTNodeLookupMap } from './ast';

/**
 * Recursively finds all AST nodes of the given node `type` in one or more
 * parsed statements. (TRANSITION kind→type rewrite: old-shape statement nodes
 * are still matched by their `kind` value.)
 *
 * @example
 * ```ts
 * import { parse, findNodes } from '@clickhouse/parser';
 *
 * const ast = parse('SELECT * FROM t WHERE id = {id:UInt64}');
 *
 * findNodes(ast, 'QueryParameter');
 * // [{ type: 'QueryParameter', name: 'id', param_type: 'UInt64' }]
 *
 * findNodes(ast, 'Identifier');
 * // [{ type: 'Identifier', name: 'id' }]
 * ```
 */
export function findNodes<K extends keyof ASTNodeLookupMap>(
  statements: Statement[],
  kind: K,
): ASTNodeLookupMap[K][] {
  const results: ASTNodeLookupMap[K][] = [];
  const seen = new Set<unknown>();

  function walk(node: unknown): void {
    if (node === null || node === undefined || typeof node !== 'object') {
      return;
    }

    if (seen.has(node)) return;
    seen.add(node);

    if (Array.isArray(node)) {
      for (const item of node) {
        walk(item);
      }
      return;
    }

    const obj = node as Record<string, unknown>;
    // New-shape nodes match on `type`; old-shape nodes match on `kind`.
    // (The `type` check must come first: native Function nodes carry a data
    // field also named `kind`, e.g. TABLE_ENGINE.)
    if (typeof obj.type === 'string' ? obj.type === kind : obj.kind === kind) {
      results.push(obj as ASTNodeLookupMap[K]);
    }

    for (const [key, value] of Object.entries(obj)) {
      if (key === 'parent') continue;
      if (typeof value === 'object' && value !== null) {
        walk(value);
      }
    }
  }

  walk(statements);
  return results;
}

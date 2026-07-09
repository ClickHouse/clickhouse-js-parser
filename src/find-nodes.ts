import type { Statement, ASTNodeLookupMap, WithoutLocations } from './ast';

/**
 * Recursively finds all AST nodes of the given node `type` in one or more
 * parsed statements.
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
// Overloads preserve location-ness: searching a located AST yields located
// result nodes (so `.location` is readable); searching a location-free AST
// (`parse(sql, { locations: false })`) yields location-free result nodes.
export function findNodes<K extends keyof ASTNodeLookupMap>(
  statements: Statement[],
  type: K,
): ASTNodeLookupMap[K][];
export function findNodes<K extends keyof ASTNodeLookupMap>(
  statements: WithoutLocations<Statement>[],
  type: K,
): WithoutLocations<ASTNodeLookupMap[K]>[];
export function findNodes<K extends keyof ASTNodeLookupMap>(
  statements: WithoutLocations<Statement>[],
  type: K,
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
    // Every AST node matches on its `type` discriminator.
    if (obj.type === type) {
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

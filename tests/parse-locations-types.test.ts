import { parse, format, formatExplain, findNodes, transformNodes } from '../src/index';
import type { Statement, WithoutLocations } from '../src/index';

/**
 * Compile-time type assertions for the `locations` parse option and the
 * required-`location` typing. These are checked by `npm run typecheck`
 * (tsconfig includes `tests`); the runtime `expect`s keep vitest happy and
 * confirm behavior end-to-end.
 */
describe('parse locations option typing', () => {
  it('default parse makes location a required property (present at runtime)', () => {
    const ast = parse('SELECT 1');
    // Type is Statement[]; `location` is required, so no `| undefined`.
    const loc: Statement['location'] = ast[0].location;
    expect(loc).toBeDefined();
    expect(ast[0].location.start.offset).toBe(0);
  });

  it('locations: false removes location from the static type and at runtime', () => {
    const ast = parse('SELECT a + 1 FROM t', { locations: false });
    // @ts-expect-error location is stripped from the returned type
    void ast[0].location;
    expect((ast[0] as { location?: unknown }).location).toBeUndefined();
  });

  it('a located AST is accepted by format/formatExplain/transform/findNodes', () => {
    const ast = parse('SELECT 1');
    // Located Statement[] is assignable to the WithoutLocations input type.
    expect(typeof format(ast)).toBe('string');
    expect(typeof formatExplain(ast)).toBe('string');
    expect(Array.isArray(findNodes(ast, 'Literal'))).toBe(true);
    // findNodes on a located AST yields located nodes: `.location` is readable.
    const lits = findNodes(ast, 'Literal');
    if (lits.length > 0) expect(lits[0].location).toBeDefined();
  });

  it('a location-free AST is also accepted by the consumer functions', () => {
    const ast = parse('SELECT 1', { locations: false });
    // WithoutLocations<Statement>[] is exactly the consumer input type.
    expect(typeof format(ast)).toBe('string');
    expect(typeof formatExplain(ast)).toBe('string');
    const result = transformNodes(ast, 'Literal', (n) => ({ ...n, value: '2' }));
    expect(findNodes(result, 'Literal')[0].value).toBe('2');
  });

  it('a location-free AST cannot be used where locations are required', () => {
    const ast = parse('SELECT 1', { locations: false });
    // @ts-expect-error WithoutLocations<Statement>[] is not assignable to Statement[]
    const asStatements: Statement[] = ast;
    void asStatements;
    expect(ast).toHaveLength(1);
  });

  it('WithoutLocations<T> is exported and strips location deeply', () => {
    type Stripped = WithoutLocations<Statement>;
    const ast = parse('SELECT 1', { locations: false });
    const s: Stripped = ast[0];
    // @ts-expect-error location removed by WithoutLocations
    void s.location;
    expect(s.type).toBeDefined();
  });
});

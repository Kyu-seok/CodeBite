import { UNKNOWN, typeRef, type TypeInfo, type TypeRef, type TypeTable } from './model';
import {
  elementType,
  indexType,
  isWordChar,
  lookup,
  matchBack,
  matchForward,
  occurrencesBefore,
  skipWs,
  skipWsBack,
} from './source';

/** What tells Java's declarations apart from C++'s. */
export interface CFamily {
  readonly table: TypeTable;
  readonly primitives: ReadonlySet<string>;
  /** The placeholder whose type comes from the initializer: `var` or `auto`. */
  readonly inferred: string;
  /** Java's `new T(...)`; C++ constructs with `T(...)` or `T{...}`. */
  readonly newKeyword: boolean;
  readonly stringLiteral: TypeRef;
}

const MAX_DEPTH = 4;
const QUALIFIERS = new Set(['const', 'final', 'static', 'volatile', 'struct', 'typename']);

/**
 * The type `name` was declared with in its latest declaration before `before`, or undefined when
 * nothing before it declares that name. A declaration is a known type, then the name, then one of
 * `= ; , ) ( { [ :` (initializer, end, parameter, constructor arguments, array size, range-for).
 */
export function declaredType(
  lang: CFamily,
  code: string,
  name: string,
  before: number,
  depth = 0,
): TypeRef | undefined {
  for (const at of occurrencesBefore(code, name, before)) {
    const next = skipWs(code, at + name.length);
    const follow = code[next];
    if (!'=;,)({[:'.includes(follow) || code[next + 1] === (follow === ':' ? ':' : '=')) continue;
    const start = typeStart(code, at);
    if (start < 0) continue;
    const parsed = parseType(code, start);
    if (!parsed || skipWs(code, parsed.end) !== at) continue;
    const type = parsed.type;
    if (type.name === lang.inferred) {
      if (depth >= MAX_DEPTH) return UNKNOWN;
      if (follow === '=') return expressionType(lang, code, next + 1, at, depth);
      if (follow === ':') return elementType(lang.table, expressionType(lang, code, next + 1, at, depth));
      return UNKNOWN;
    }
    if (lookup<TypeInfo>(lang.table, type.name) || lang.primitives.has(type.name)) return type;
  }
  return undefined;
}

/** Where the type before the name at `at` starts, walking back over `&`, `*`, `[]` and `<...>`. */
function typeStart(code: string, at: number): number {
  let i = skipWsBack(code, at);
  for (;;) {
    if (code[i - 1] === '&' || code[i - 1] === '*') i = skipWsBack(code, i - 1);
    else if (code[i - 1] === ']' && code[skipWsBack(code, i - 1) - 1] === '[') i = skipWsBack(code, skipWsBack(code, i - 1) - 1);
    else break;
  }
  if (code[i - 1] === '>') {
    if (code[i - 2] === '-') return -1;
    const open = matchBack(code, i - 1, '<', ';{}()=');
    if (open < 0) return -1;
    i = skipWsBack(code, open);
  }
  let start = i;
  while (isWordChar(code[start - 1])) start--;
  if (start === i) return -1;
  for (;;) {
    const separator = code[start - 1] === '.' ? 1 : code.slice(start - 2, start) === '::' ? 2 : 0;
    let qualifier = start - separator;
    while (separator && isWordChar(code[qualifier - 1])) qualifier--;
    if (!separator || qualifier === start - separator) return start;
    start = qualifier;
  }
}

function readWord(code: string, i: number): string | undefined {
  return /^[A-Za-z_]\w*/.exec(code.slice(i, i + 64))?.[0];
}

/** Reads a type such as `std::vector<std::vector<int>>&` or `Map.Entry<K, V>[]` from `i`. */
export function parseType(code: string, i: number): { type: TypeRef; end: number } | null {
  i = skipWs(code, i);
  if (code[i] === '?') {
    i = skipWs(code, i + 1);
    const bound = /^(extends|super)\b/.exec(code.slice(i, i + 8));
    return bound ? parseType(code, i + bound[0].length) : { type: UNKNOWN, end: i };
  }
  const number = /^\d+/.exec(code.slice(i, i + 32));
  if (number) return { type: UNKNOWN, end: i + number[0].length };

  let name = readWord(code, i);
  while (name && QUALIFIERS.has(name)) {
    i = skipWs(code, i + name.length);
    name = readWord(code, i);
  }
  if (!name) return null;
  i += name.length;
  for (;;) {
    const separator = code[i] === '.' ? 1 : code.startsWith('::', i) ? 2 : 0;
    const segment = separator ? readWord(code, i + separator) : undefined;
    if (!segment) break;
    name = segment;
    i += separator + segment.length;
  }

  const args: TypeRef[] = [];
  const open = skipWs(code, i);
  if (code[open] === '<') {
    i = skipWs(code, open + 1);
    while (code[i] !== '>') {
      const argument = parseType(code, i);
      if (!argument) return null;
      args.push(argument.type);
      i = skipWs(code, argument.end);
      if (code[i] === ',') i++;
      else if (code[i] !== '>') return null;
    }
    i++;
    if (code.startsWith('::', i)) return parseType(code, i + 2);
  }

  let type = typeRef(name, ...args);
  for (;;) {
    const k = skipWs(code, i);
    if (code[k] === '&' || code[k] === '*') i = k + 1;
    else if (code[k] === '[' && code[skipWs(code, k + 1)] === ']') {
      type = typeRef('[]', type);
      i = skipWs(code, k + 1) + 1;
    } else return { type, end: i };
  }
}

/**
 * The type of an initializer or range at `i`: `new ArrayList<>()`, `new int[n][m]`,
 * `vector<int>(n)`, a string literal, or another variable, maybe indexed. A method call or any
 * other expression is UNKNOWN. `scope` is the declaration's own position, so `var x = x` looks
 * further back.
 */
function expressionType(lang: CFamily, code: string, i: number, scope: number, depth: number): TypeRef {
  i = skipWs(code, i);
  if (code[i] === '"') return lang.stringLiteral;

  if (lang.newKeyword && /^new\b/.test(code.slice(i, i + 4))) {
    const created = parseType(code, i + 3);
    if (!created) return UNKNOWN;
    let type = created.type;
    for (let k = skipWs(code, created.end); code[k] === '['; ) {
      const close = matchForward(code, k);
      if (close < 0) break;
      type = typeRef('[]', type);
      k = skipWs(code, close + 1);
    }
    return type;
  }

  const constructed = lang.newKeyword ? null : parseType(code, i);
  if (constructed && '({'.includes(code[skipWs(code, constructed.end)] ?? ' ')) {
    if (constructed.type.name === 'make_pair') return typeRef('pair');
    return lookup<TypeInfo>(lang.table, constructed.type.name) ? constructed.type : UNKNOWN;
  }

  const variable = readWord(code, i);
  if (!variable) return UNKNOWN;
  let type = declaredType(lang, code, variable, scope, depth + 1) ?? UNKNOWN;
  let k = skipWs(code, i + variable.length);
  while (code[k] === '[') {
    const close = matchForward(code, k);
    if (close < 0) return UNKNOWN;
    type = indexType(lang.table, type);
    k = skipWs(code, close + 1);
  }
  return k >= code.length || ';,)'.includes(code[k]) ? type : UNKNOWN;
}

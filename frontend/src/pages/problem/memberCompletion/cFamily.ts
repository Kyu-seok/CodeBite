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
  /** The placeholder whose type comes from the initializer: `var` or `auto`. */
  readonly inferred: string;
  /** Java's `new T(...)`; C++ constructs with `T(...)` or `T{...}`. */
  readonly newKeyword: boolean;
  /** Java's `(a, b) -> ...` binds names without types; C++'s `a->b` is a member access. */
  readonly untypedLambdas: boolean;
  readonly stringLiteral: TypeRef;
}

const MAX_DEPTH = 4;
const QUALIFIERS = new Set(['const', 'final', 'static', 'volatile', 'struct', 'typename']);

/** Words that may stand before a declaration's type: `final int x`, `long long x`. */
const MODIFIERS = new Set([
  ...QUALIFIERS,
  'public',
  'private',
  'protected',
  'constexpr',
  'mutable',
  'register',
  'inline',
  'extern',
  'unsigned',
  'signed',
  'long',
  'short',
]);

/** Words that stand before a name without being its type: `return a;` declares nothing. */
const NOT_TYPES = new Set([
  'return',
  'new',
  'throw',
  'throws',
  'case',
  'else',
  'do',
  'delete',
  'goto',
  'sizeof',
  'instanceof',
  'assert',
  'yield',
  'extends',
  'implements',
  'class',
  'interface',
  'enum',
  'using',
  'namespace',
  'typedef',
  'operator',
  'import',
  'package',
]);

/**
 * The type `name` was declared with in its latest declaration before `before`, or undefined when
 * nothing before it declares that name. A declaration is a type, then the name, then one of
 * `= ; , ) ( { [ :` (initializer, end, parameter, constructor arguments, array size, range-for).
 * Its shape decides, not whether the type is known: `Node cur` hides an older `List<Integer> cur`.
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
    if (lang.untypedLambdas && isLambdaParameter(code, at, next)) return UNKNOWN;
    if (!'=;,)({[:'.includes(follow) || code[next + 1] === (follow === ':' ? ':' : '=')) continue;
    if (new RegExp(`\\b${lang.inferred}\\s*&{0,2}\\s*\\[[\\w\\s,]*$`).test(code.slice(Math.max(0, at - 128), at))) {
      return UNKNOWN;
    }
    const type = declarationType(code, at, follow) ?? laterDeclaratorType(code, at);
    if (!type) continue;
    if (type.name === lang.inferred) {
      if (depth >= MAX_DEPTH) return UNKNOWN;
      if (follow === '=') return expressionType(lang, code, next + 1, at, depth);
      if (follow === ':') return elementType(lang.table, expressionType(lang, code, next + 1, at, depth));
      return UNKNOWN;
    }
    return type;
  }
  return undefined;
}

/** `x -> ...` or `(a, b) -> ...`: a lambda's parameter, whose type nothing writes down. */
function isLambdaParameter(code: string, at: number, next: number): boolean {
  if (code.startsWith('->', next)) return true;
  return '(,'.includes(code[skipWsBack(code, at) - 1]) && /^(?:\s*,\s*[A-Za-z_]\w*)*\s*\)\s*->/.test(code.slice(next, next + 256));
}

/** The type of a declaration whose declarator at `at` follows its type: `int x`, `final List<T> x`. */
function declarationType(code: string, at: number, follow: string): TypeRef | null {
  const start = typeStart(code, at);
  if (start < 0 || NOT_TYPES.has(readWord(code, start) ?? '') || !startsDeclaration(code, start)) return null;
  const parsed = parseType(code, start);
  if (!parsed || skipWs(code, parsed.end) !== at) return null;
  if ('*&'.includes(code[skipWsBack(code, at) - 1]) && '[('.includes(follow)) return null;
  return parsed.type;
}

/** Whether a declaration may start at `start`: after a statement, a bracket, a comma or a modifier, never after an operator. */
function startsDeclaration(code: string, start: number): boolean {
  const i = skipWsBack(code, start);
  if (i === 0 || ';{}(,:'.includes(code[i - 1])) return true;
  let word = i;
  while (isWordChar(code[word - 1])) word--;
  return MODIFIERS.has(code.slice(word, i));
}

/** The type of a later declarator, `j` in `int i = 0, j = n;`: the type written at the statement's start. */
function laterDeclaratorType(code: string, at: number): TypeRef | null {
  let i = skipWsBack(code, at);
  while (code[i - 1] === '*' || code[i - 1] === '&') i = skipWsBack(code, i - 1);
  if (code[i - 1] !== ',') return null;
  let depth = 0;
  for (i -= 2; i >= 0; i--) {
    const c = code[i];
    if (c === ')' || c === ']') depth++;
    else if ((c === '(' || c === '[') && depth > 0) depth--;
    else if (';{}(['.includes(c)) break;
  }
  if (i >= 0 && (code[i] === '[' || (code[i] === '(' && !isForHeader(code, i)))) return null;
  const start = skipWs(code, i + 1);
  if (NOT_TYPES.has(readWord(code, start) ?? '')) return null;
  const parsed = parseType(code, start);
  if (!parsed || !readWord(code, skipWs(code, parsed.end))) return null;
  return MODIFIERS.has(parsed.type.name) ? UNKNOWN : parsed.type;
}

/** Whether the `(` at `open` starts a for loop's header. */
function isForHeader(code: string, open: number): boolean {
  const end = skipWsBack(code, open);
  return code.slice(end - 3, end) === 'for' && !isWordChar(code[end - 4]);
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

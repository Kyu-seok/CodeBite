import { UNKNOWN, typeRef, unpointered, type TypeInfo, type TypeRef, type TypeTable } from './model';
import { brackets, Scopes, type Brackets, type Range } from './scopes';
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

/** The code before the cursor, with the scope of every position. */
export interface Source {
  readonly code: string;
  readonly scopes: Scopes;
}

/**
 * The code's scopes: every `{...}` block, and every parenthesis together with the body it governs
 * (a method's, catch's or lambda's block, a lambda's expression, a for loop's statement), so a
 * parameter or loop variable is seen only there. A Java `x -> ...` lambda scopes `x` the same way.
 */
export function cFamilySource(lang: CFamily, code: string): Source {
  const br = brackets(code);
  const ranges: Range[] = [];
  for (let i = 0; i < code.length; i++) {
    const c = code[i];
    if (c === '{') ranges.push([i, br.close[i]]);
    else if (c === '(') ranges.push([i, governedEnd(lang, code, br, i)]);
    else if (lang.untypedLambdas && code.startsWith('->', i) && isWordChar(code[skipWsBack(code, i) - 1])) {
      let start = skipWsBack(code, i);
      while (isWordChar(code[start - 1])) start--;
      ranges.push([start, bodyEnd(code, br, skipWs(code, i + 2))]);
    }
  }
  return { code, scopes: new Scopes(code.length, ranges) };
}

const JAVA_BODY = /^\s*(?:throws\s+[\w.]+(?:\s*,\s*[\w.]+)*\s*)?(\{|->)/;
/** After a C++ parameter list: qualifiers, a trailing return type or a constructor's initializers, then the body. */
const CPP_BODY = /^\s*(?:(?:const|mutable|noexcept|override|final)\b\s*)*(?:->[^;{}]*|:[^;{}]*)?(\{)/;
const CONTROL = new Set(['for', 'while', 'if']);

/** Where the scope of the parenthesis at `open` ends: its body's end, or its own `)` when it has none. */
function governedEnd(lang: CFamily, code: string, br: Brackets, open: number): number {
  const close = br.close[open];
  if (close >= code.length) return close;
  const head = (lang.untypedLambdas ? JAVA_BODY : CPP_BODY).exec(code.slice(close + 1, close + 257));
  if (head) {
    const at = close + 1 + head[0].length - head[1].length;
    return head[1] === '{' ? br.close[at] : bodyEnd(code, br, skipWs(code, at + 2));
  }
  let word = skipWsBack(code, open);
  const end = word;
  while (isWordChar(code[word - 1])) word--;
  return CONTROL.has(code.slice(word, end)) ? statementEnd(code, br, close + 1, false) : close;
}

/** Where a lambda's body starting at `i` ends: its block, or its expression. */
function bodyEnd(code: string, br: Brackets, i: number): number {
  return code[i] === '{' ? br.close[i] : statementEnd(code, br, i, true);
}

/** Where the statement or expression from `i` ends: a `;` (or `,`) outside brackets, or the enclosing bracket's close. */
function statementEnd(code: string, br: Brackets, i: number, comma: boolean): number {
  for (; i < code.length; i++) {
    const c = code[i];
    if (c === '(' || c === '[' || c === '{') i = br.close[i];
    else if (c === ')' || c === ']' || c === '}' || c === ';' || (comma && c === ',')) return i;
  }
  return code.length;
}

/**
 * The type `name` was declared with in its latest declaration before `before` that is in scope
 * there, or undefined when none is. A declaration is a type, then the name, then one of
 * `= ; , ) ( { [ :` (initializer, end, parameter, constructor arguments, array size, range-for).
 * Its shape decides, not whether the type is known: `Node cur` hides an older `List<Integer> cur`.
 */
export function declaredType(
  lang: CFamily,
  src: Source,
  name: string,
  before: number,
  depth = 0,
): TypeRef | undefined {
  const { code } = src;
  for (const at of occurrencesBefore(code, name, before)) {
    if (!src.scopes.visible(at, before)) continue;
    const next = skipWs(code, at + name.length);
    const follow = code[next];
    if (lang.untypedLambdas && isLambdaParameter(code, at, next)) return UNKNOWN;
    if (!'=;,)({[:'.includes(follow) || code[next + 1] === (follow === ':' ? ':' : '=')) continue;
    if (isStructuredBinding(lang, code, at)) return UNKNOWN;
    const type = declarationType(code, at, follow) ?? laterDeclaratorType(code, at);
    if (!type) continue;
    if (unpointered(type).name === lang.inferred) {
      if (depth >= MAX_DEPTH) return UNKNOWN;
      if (follow === '=') return expressionType(lang, src, next + 1, at, depth);
      if (follow === ':') return elementType(lang.table, expressionType(lang, src, next + 1, at, depth));
      return UNKNOWN;
    }
    return arrayOf(code, next, type);
  }
  return undefined;
}

/** The type of a declarator with C-style dimensions from `i`: `adj` in `vector<int> adj[n]` is an array of vector. */
function arrayOf(code: string, i: number, type: TypeRef): TypeRef {
  while (code[i] === '[') {
    const close = matchForward(code, i);
    if (close < 0) return UNKNOWN;
    type = typeRef('[]', type);
    i = skipWs(code, close + 1);
  }
  return type;
}

/** `x -> ...` or `(a, b) -> ...`: a lambda's parameter, whose type nothing writes down. */
function isLambdaParameter(code: string, at: number, next: number): boolean {
  if (code.startsWith('->', next)) return true;
  const inParentheses = '(,'.includes(code[skipWsBack(code, at) - 1]);
  return inParentheses && /^(?:\s*,\s*[A-Za-z_]\w*)*\s*\)\s*->/.test(code.slice(next, next + 256));
}

/** `x` in `auto [x, y] = p;`, whose type the pair's would decide. */
function isStructuredBinding(lang: CFamily, code: string, at: number): boolean {
  return new RegExp(`\\b${lang.inferred}\\s*&{0,2}\\s*\\[[\\w\\s,]*$`).test(code.slice(Math.max(0, at - 128), at));
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

/**
 * Whether a declaration may start at `start`: after a statement, a bracket, a comma or a modifier,
 * never after an operator (`x * nums` in `s = x * nums[i]`) or a word such as `return`.
 */
function startsDeclaration(code: string, start: number): boolean {
  const i = skipWsBack(code, start);
  if (i === 0 || ';{}(,:'.includes(code[i - 1])) return true;
  let word = i;
  while (isWordChar(code[word - 1])) word--;
  return MODIFIERS.has(code.slice(word, i));
}

/**
 * The type of a later declarator, `j` in `int i = 0, j = n;`: the type written at the statement's
 * start, with the declarator's own `*`s (`fast` in `ListNode *slow, *fast` is a pointer).
 */
function laterDeclaratorType(code: string, at: number): TypeRef | null {
  let i = skipWsBack(code, at);
  let stars = 0;
  while (code[i - 1] === '*' || code[i - 1] === '&') {
    if (code[i - 1] === '*') stars++;
    i = skipWsBack(code, i - 1);
  }
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
  if (MODIFIERS.has(parsed.type.name)) return UNKNOWN;
  let type = unpointered(parsed.type);
  for (; stars > 0; stars--) type = typeRef('*', type);
  return type;
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
    if (code[k] === '&' || code[k] === '*') {
      if (code[k] === '*') type = typeRef('*', type);
      i = k + 1;
    } else if (code[k] === '[' && code[skipWs(code, k + 1)] === ']') {
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
function expressionType(lang: CFamily, src: Source, i: number, scope: number, depth: number): TypeRef {
  const { code } = src;
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
  let type = declaredType(lang, src, variable, scope, depth + 1) ?? UNKNOWN;
  let k = skipWs(code, i + variable.length);
  while (code[k] === '[') {
    const close = matchForward(code, k);
    if (close < 0) return UNKNOWN;
    type = indexType(lang.table, type);
    k = skipWs(code, close + 1);
  }
  return k >= code.length || ';,)'.includes(code[k]) ? type : UNKNOWN;
}

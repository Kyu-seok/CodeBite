import { UNKNOWN, typeRef, type TypeRef } from './model';
import { PYTHON_TYPES } from './pythonMembers';
import {
  elementType,
  indexType,
  isWordChar,
  lookup,
  matchForward,
  occurrencesBefore,
  skipWs,
  skipWsBack,
} from './source';

const MAX_DEPTH = 4;

/** typing's and collections' spellings of the types in PYTHON_TYPES. */
const TYPE_NAMES: Readonly<Record<string, string>> = {
  List: 'list',
  Dict: 'dict',
  Set: 'set',
  FrozenSet: 'frozenset',
  Tuple: 'tuple',
  Deque: 'deque',
  DefaultDict: 'defaultdict',
};

const CONSTRUCTORS = new Set([
  'list',
  'dict',
  'set',
  'frozenset',
  'str',
  'tuple',
  'deque',
  'Counter',
  'defaultdict',
  'OrderedDict',
  'int',
  'float',
]);

/**
 * What binds a name at one of its occurrences: an annotation to read, a value or an iterable whose
 * type (or item type) it takes, or a binding whose type can't be told.
 */
type Binding =
  | { readonly kind: 'annotation'; readonly at: number }
  | { readonly kind: 'value' | 'element'; readonly start: number; readonly end: number }
  | { readonly kind: 'unknown' };

const UNTYPED: Binding = { kind: 'unknown' };

/** Words that end a walk over assignment targets: `if s` or `in s` is never a target. */
const KEYWORDS = new Set([
  'in',
  'if',
  'elif',
  'else',
  'not',
  'and',
  'or',
  'is',
  'return',
  'yield',
  'lambda',
  'del',
  'assert',
  'await',
  'while',
  'with',
  'import',
  'from',
  'raise',
  'def',
  'class',
]);

/**
 * The type of `name` at its latest binding before `before`, or undefined when nothing binds it
 * there. Every way Python binds a name counts, and one whose type isn't written down or built
 * from a literal or constructor gives UNKNOWN, so an older binding never shows through.
 */
export function boundType(code: string, name: string, before: number, depth = 0): TypeRef | undefined {
  for (const at of occurrencesBefore(code, name, before)) {
    const binding = bindingAt(code, name, at, before);
    if (!binding) continue;
    if (binding.kind === 'annotation') return parseAnnotation(code, binding.at)?.type ?? UNKNOWN;
    if (binding.kind === 'unknown' || depth >= MAX_DEPTH) return UNKNOWN;
    const type = expressionType(code, binding.start, binding.end, at, depth);
    return binding.kind === 'value' ? type : elementType(PYTHON_TYPES, type);
  }
  return undefined;
}

/**
 * How the occurrence of `name` at `at` binds it, or null when it doesn't: `name: T`, a parameter,
 * `as name`, `def name`, `class name`, `name :=`, `global name`, a lambda's parameter, or an
 * assignment or for target. A comprehension's or lambda's binding counts only inside it.
 */
function bindingAt(code: string, name: string, at: number, before: number): Binding | null {
  if (code[at - 1] === '.') return null;
  const next = skipInline(code, at + name.length);
  const previous = skipWsBack(code, at);
  const opener = enclosingOpener(code, at);
  if (['as', 'def', 'class'].includes(wordBefore(code, previous))) return UNTYPED;
  if (code.startsWith(':=', next)) return UNTYPED;
  if (/^[ \t]*(?:global|nonlocal)[ \t][\w \t,]*$/.test(code.slice(code.lastIndexOf('\n', at - 1) + 1, at))) return UNTYPED;
  if (opener >= 0 && code[opener] === '(' && /\bdef\s+\w+\s*$/.test(code.slice(Math.max(0, opener - 64), opener))) {
    if (!'(,*'.includes(code[previous - 1]) || !',)=:'.includes(code[next])) return null;
    return code[next] === ':' ? { kind: 'annotation', at: next + 1 } : UNTYPED;
  }
  if (/\blambda\s[\w\s,*=]*$/.test(code.slice(Math.max(0, at - 128), at)) && ',:='.includes(code[next])) {
    return inScope(code, at, before, true) ? UNTYPED : null;
  }
  if (code[next] === ':' && code[next + 1] !== '=' && opener < 0 && startsStatement(code, at)) {
    return { kind: 'annotation', at: next + 1 };
  }
  return targetBinding(code, name, at, before);
}

/**
 * A name among the targets of an assignment (`a, b = ...`, `x = y = []`) or a for (`for i, s in`,
 * a comprehension's too): the value or iterable when it is the whole target, UNKNOWN when it is one
 * of several, and null when it is no target at all (`s[i] = 1`, `f(s=1)`, `s == 1`).
 */
function targetBinding(code: string, name: string, at: number, before: number): Binding | null {
  let start = at;
  let forAt = -1;
  for (;;) {
    const i = skipInlineBack(code, start);
    const c = code[i - 1] ?? '';
    if (c !== '' && ',()[]*'.includes(c)) start = i - 1;
    else if (c === '=' && !'=!<>:+-*/%&|^@'.includes(code[i - 2] ?? '')) start = i - 1;
    else if (isWordChar(c)) {
      const word = wordBefore(code, i);
      if (word === 'for') forAt = i - 3;
      if (word === 'for' || KEYWORDS.has(word)) break;
      start = i - word.length;
    } else break;
  }

  let end = at + name.length;
  for (;;) {
    end = skipInline(code, end);
    const c = code[end] ?? '';
    if (c !== '' && ',()[]*'.includes(c)) end++;
    else if (isWordChar(c) && !/\d/.test(c)) {
      const word = /^\w+/.exec(code.slice(end))![0];
      if (KEYWORDS.has(word)) break;
      end += word.length;
    } else break;
  }
  const assigned = code[end] === '=' && code[end + 1] !== '=';
  const iterated = forAt >= 0 && isWord(code, end, 'in');
  if (iterated) {
    if (enclosingOpener(code, forAt) >= 0 && !inScope(code, forAt, before, false)) return null;
  } else if (!assigned || forAt >= 0 || !startsStatement(code, start) || enclosingOpener(code, start) >= 0) {
    return null;
  }

  const target = ownTarget(code, iterated ? forAt + 3 : start, end, at, name);
  if (target === null) return null;
  if (!target) return UNTYPED;
  return iterated
    ? { kind: 'element', start: end + 2, end: statementEnd(code, end + 2, true) }
    : { kind: 'value', start: end + 1, end: statementEnd(code, end + 1, false) };
}

/**
 * Whether the name at `at` is the whole of its target in [start, end): true for `s = ...`, false
 * for `a, s = ...`, null when it is no target (`s[i] = ...`, `f(a, s=1)`). Chained targets are
 * split at each `=` outside brackets.
 */
function ownTarget(code: string, start: number, end: number, at: number, name: string): boolean | null {
  let from = start;
  let depth = 0;
  for (let i = start; i < at; i++) {
    if ('([{'.includes(code[i])) depth++;
    else if (')]}'.includes(code[i])) depth--;
    else if (depth === 0 && code[i] === '=') from = i + 1;
  }
  const target = code.slice(from, end);
  let balance = 0;
  for (const c of target) {
    if ('([{'.includes(c)) balance++;
    else if (')]}'.includes(c) && --balance < 0) return null;
  }
  if (balance !== 0 || '[.('.includes(code[skipInline(code, at + name.length)])) return null;
  const opener = enclosingOpener(code.slice(from, at), at - from);
  if (opener >= 0 && code[from + opener] === '[' && /[\w)\]]/.test(code[skipWsBack(code, from + opener) - 1] ?? '')) return null;
  return target.trim() === name;
}

/** The index of the unclosed bracket around `at`, or -1 at the top level. */
function enclosingOpener(code: string, at: number): number {
  let depth = 0;
  for (let i = at - 1; i >= 0; i--) {
    if (')]}'.includes(code[i])) depth++;
    else if ('([{'.includes(code[i]) && depth-- === 0) return i;
  }
  return -1;
}

/**
 * Whether a binding at `from`, scoped to its brackets (a comprehension's for) or also to its
 * statement (a lambda's parameter), still holds at `before`.
 */
function inScope(code: string, from: number, before: number, statement: boolean): boolean {
  let depth = 0;
  for (let i = from; i < before; i++) {
    const c = code[i];
    if ('([{'.includes(c)) depth++;
    else if (')]}'.includes(c) && --depth < 0) return false;
    else if (statement && depth === 0 && (c === ';' || (c === '\n' && code[i - 1] !== '\\'))) return false;
  }
  return true;
}

/** The word ending at `i`, or '' when none does. */
function wordBefore(code: string, i: number): string {
  let start = i;
  while (isWordChar(code[start - 1])) start--;
  return code.slice(start, i);
}

function skipInline(code: string, i: number): number {
  while (code[i] === ' ' || code[i] === '\t') i++;
  return i;
}

function skipInlineBack(code: string, i: number): number {
  while (code[i - 1] === ' ' || code[i - 1] === '\t') i--;
  return i;
}

/** Whether only indentation stands between `at` and the start of its line, a `;` or a block's `:`. */
function startsStatement(code: string, at: number): boolean {
  const i = skipInlineBack(code, at);
  return i === 0 || code[i - 1] === '\n' || code[i - 1] === ';' || code[i - 1] === ':';
}

function isWord(code: string, i: number, word: string): boolean {
  return i >= 0 && code.startsWith(word, i) && !isWordChar(code[i - 1]) && !isWordChar(code[i + word.length]);
}

/** Where the statement from `i` ends: a newline or `;` outside brackets, or `:` for a for loop's header. */
function statementEnd(code: string, i: number, colon: boolean): number {
  let depth = 0;
  for (; i < code.length; i++) {
    const c = code[i];
    if ('([{'.includes(c)) depth++;
    else if (')]}'.includes(c)) depth--;
    else if (depth === 0 && (c === ';' || (c === '\n' && code[i - 1] !== '\\') || (colon && c === ':'))) return i;
  }
  return i;
}

/** The type of the expression in [i, end), from its leading value: `[0] * n` is a list of int. */
function expressionType(code: string, i: number, end: number, scope: number, depth: number): TypeRef {
  const leading = atom(code, skipWs(code, i), end, scope, depth);
  if (!leading) return UNKNOWN;
  const k = skipWs(code, leading.end);
  return k >= end || code[k] === '*' || code[k] === '+' ? leading.type : UNKNOWN;
}

function atom(code: string, i: number, end: number, scope: number, depth: number): { type: TypeRef; end: number } | null {
  const c = code[i];
  if (c === '[' || c === '{' || c === '(') {
    const close = matchForward(code, i);
    const inner = close < 0 ? end : close;
    const after = close < 0 ? end : close + 1;
    const first = topLevel(code, i + 1, inner);
    const empty = first.end <= skipWs(code, i + 1);
    if (c === '[') {
      const item = empty ? UNKNOWN : expressionType(code, i + 1, first.end, scope, depth);
      return { type: item === UNKNOWN ? typeRef('list') : typeRef('list', item), end: after };
    }
    if (c === '{') return { type: typeRef(empty || first.colon ? 'dict' : 'set'), end: after };
    if (empty || code[skipWs(code, first.end)] === ',') return { type: typeRef('tuple'), end: after };
    if (first.end < skipWsBack(code, inner)) return { type: UNKNOWN, end: after };
    return { type: expressionType(code, i + 1, inner, scope, depth), end: after };
  }

  const literal = /^[rRbBfFuU]{0,2}(["'])/.exec(code.slice(i, i + 3));
  if (literal) {
    const quote = literal[1];
    const at = i + literal[0].length - 1;
    return { type: typeRef('str'), end: at + (code.startsWith(quote.repeat(6), at) ? 6 : 2) };
  }

  const number = /^\d[\w.]*/.exec(code.slice(i, end));
  if (number) return { type: typeRef(/[.eE]/.test(number[0]) ? 'float' : 'int'), end: i + number[0].length };

  const dotted = /^[A-Za-z_]\w*(?:\s*\.\s*[A-Za-z_]\w*)*/.exec(code.slice(i, end));
  if (!dotted) return null;
  const path = dotted[0].split('.').map((s) => s.trim());
  const k = skipWs(code, i + dotted[0].length);
  if (code[k] === '(') {
    const close = matchForward(code, k);
    const callee = path.length === 1 || (path.length === 2 && path[0] === 'collections') ? path[path.length - 1] : '';
    return { type: callType(code, callee, k + 1), end: close < 0 ? end : close + 1 };
  }
  if (path.length > 1) return { type: UNKNOWN, end: k };

  let type = boundType(code, path[0], scope, depth + 1) ?? UNKNOWN;
  let j = k;
  while (code[j] === '[') {
    const close = matchForward(code, j);
    if (close < 0) return { type: UNKNOWN, end };
    type = subscriptType(type, code.slice(j + 1, close));
    j = skipWs(code, close + 1);
  }
  return { type, end: j };
}

/** `x[i]` is an item of x, while a slice such as `x[1:]` or `s[::-1]` is x's own type. */
export function subscriptType(type: TypeRef, subscript: string): TypeRef {
  return topLevel(subscript, 0, subscript.length).colon ? type : indexType(PYTHON_TYPES, type);
}

/** The first item of a bracket's contents: where it ends (a top-level `,` or `for`), and whether a `:` came first. */
function topLevel(code: string, i: number, end: number): { end: number; colon: boolean } {
  let depth = 0;
  let colon = false;
  for (; i < end; i++) {
    const c = code[i];
    if ('([{'.includes(c)) depth++;
    else if (')]}'.includes(c)) depth--;
    else if (depth === 0 && (c === ',' || isWord(code, i, 'for'))) break;
    else if (depth === 0 && c === ':') colon = true;
  }
  return { end: skipWsBack(code, i), colon };
}

/** The type a call returns: `deque(...)`, `sorted(...)`, `defaultdict(list)`; anything else is UNKNOWN. */
function callType(code: string, callee: string, argsStart: number): TypeRef {
  if (callee === 'sorted') return typeRef('list');
  if (callee === 'defaultdict') {
    const factory = /^\s*([A-Za-z_]\w*)\s*[,)]/.exec(code.slice(argsStart, argsStart + 64))?.[1];
    return typeRef('defaultdict', UNKNOWN, factory ? callType(code, factory, code.length) : UNKNOWN);
  }
  return CONSTRUCTORS.has(callee) ? typeRef(callee) : UNKNOWN;
}

/** Reads an annotation such as `List[List[int]]`, `Optional[TreeNode]` or `dict[str, int] | None`. */
function parseAnnotation(code: string, i: number): { type: TypeRef; end: number } | null {
  i = skipWs(code, i);
  const quoted = /^(["'])\1/.exec(code.slice(i, i + 2));
  if (quoted) return { type: UNKNOWN, end: i + 2 };
  if (code.startsWith('...', i)) return { type: UNKNOWN, end: i + 3 };
  const dotted = /^[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*/.exec(code.slice(i, i + 128));
  if (!dotted) return null;
  const written = dotted[0].slice(dotted[0].lastIndexOf('.') + 1);
  let end = i + dotted[0].length;
  const args: TypeRef[] = [];
  if (code[skipInline(code, end)] === '[') {
    end = skipInline(code, end) + 1;
    while (code[skipWs(code, end)] !== ']') {
      const argument = parseAnnotation(code, end);
      if (!argument) return null;
      args.push(argument.type);
      end = skipWs(code, argument.end);
      if (code[end] === ',') end++;
      else if (code[end] !== ']') return null;
    }
    end = skipWs(code, end) + 1;
  }
  let type = written === 'Optional' && args[0] ? args[0] : typeRef(lookup(TYPE_NAMES, written) ?? written, ...args);
  const bar = skipInline(code, end);
  if (code[bar] === '|') {
    const other = parseAnnotation(code, bar + 1);
    if (!other) return null;
    if (type.name === 'None') type = other.type;
    else if (other.type.name !== 'None') type = UNKNOWN;
    end = other.end;
  }
  return { type, end };
}

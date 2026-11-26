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
 * The type of `name` at its latest binding before `before`, or undefined when nothing binds it
 * there. A binding is an annotation (`name: List[int]`, a parameter included), an assignment
 * starting a statement (`name = []`, never `name == x`), or a for loop (`for name in grid:`).
 */
export function boundType(code: string, name: string, before: number, depth = 0): TypeRef | undefined {
  for (const at of occurrencesBefore(code, name, before)) {
    if (code[at - 1] === '.') continue;
    const next = skipInline(code, at + name.length);
    const previous = code[skipWsBack(code, at) - 1];
    if (code[next] === ':' && code[next + 1] !== '=' && (startsStatement(code, at) || previous === '(' || previous === ',')) {
      return parseAnnotation(code, next + 1)?.type ?? UNKNOWN;
    }
    if (code[next] === '=' && code[next + 1] !== '=' && startsStatement(code, at)) {
      return depth < MAX_DEPTH ? expressionType(code, next + 1, statementEnd(code, next + 1, false), at, depth) : UNKNOWN;
    }
    if (isWord(code, skipWsBack(code, at) - 3, 'for') && isWord(code, next, 'in')) {
      if (depth >= MAX_DEPTH) return UNKNOWN;
      const iterable = expressionType(code, next + 2, statementEnd(code, next + 2, true), at, depth);
      return elementType(PYTHON_TYPES, iterable);
    }
  }
  return undefined;
}

function skipInline(code: string, i: number): number {
  while (code[i] === ' ' || code[i] === '\t') i++;
  return i;
}

/** Whether only indentation stands between `at` and the start of its line or a `;`. */
function startsStatement(code: string, at: number): boolean {
  let i = at;
  while (code[i - 1] === ' ' || code[i - 1] === '\t') i--;
  return i === 0 || code[i - 1] === '\n' || code[i - 1] === ';';
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

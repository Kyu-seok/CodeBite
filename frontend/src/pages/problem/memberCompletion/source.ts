import { UNKNOWN, type TypeInfo, type TypeRef, type TypeTable } from './model';

export function lookup<T>(record: Readonly<Record<string, T>>, key: string): T | undefined {
  return Object.hasOwn(record, key) ? record[key] : undefined;
}

export const indexType = (table: TypeTable, type: TypeRef): TypeRef =>
  lookup<TypeInfo>(table, type.name)?.index?.(type.args) ?? UNKNOWN;

export const elementType = (table: TypeTable, type: TypeRef): TypeRef =>
  lookup<TypeInfo>(table, type.name)?.element?.(type.args) ?? UNKNOWN;

/**
 * The code with comments removed and every string literal emptied (`"a.b"` becomes `""`), so a
 * `.` or bracket inside one never counts. Null when the text ends inside a comment or string:
 * the cursor is there, and nothing should be suggested.
 */
export function stripCommentsAndStrings(text: string, python: boolean): string | null {
  let out = '';
  let i = 0;
  while (i < text.length) {
    const c = text[i];
    const lineComment = python ? c === '#' : c === '/' && text[i + 1] === '/';
    if (lineComment) {
      const newline = text.indexOf('\n', i);
      if (newline < 0) return null;
      i = newline;
    } else if (!python && c === '/' && text[i + 1] === '*') {
      const close = text.indexOf('*/', i + 2);
      if (close < 0) return null;
      out += ' ';
      i = close + 2;
    } else if (c === '"' || (c === "'" && (python || !/\w/.test(text[i - 1] ?? '')))) {
      const quote = python && text.startsWith(c.repeat(3), i) ? c.repeat(3) : c;
      let j = i + quote.length;
      while (j < text.length && !text.startsWith(quote, j) && !(quote.length === 1 && text[j] === '\n')) {
        j += text[j] === '\\' ? 2 : 1;
      }
      if (j >= text.length) return null;
      out += quote + quote;
      i = text[j] === '\n' ? j : j + quote.length;
    } else {
      out += c;
      i++;
    }
  }
  return out;
}

export const isWordChar = (c: string | undefined) => c !== undefined && /\w/.test(c);

export function skipWs(code: string, i: number): number {
  while (i < code.length && /\s/.test(code[i])) i++;
  return i;
}

/** The index just after the last non-space character before `i`. */
export function skipWsBack(code: string, i: number): number {
  while (i > 0 && /\s/.test(code[i - 1])) i--;
  return i;
}

const CLOSER: Readonly<Record<string, string>> = { '(': ')', '[': ']', '{': '}' };

/** The index of the bracket closing the one at `open`, or -1 when the text ends first. */
export function matchForward(code: string, open: number): number {
  const opener = code[open];
  const closer = CLOSER[opener];
  let depth = 0;
  for (let i = open; i < code.length; i++) {
    if (code[i] === opener) depth++;
    else if (code[i] === closer && --depth === 0) return i;
  }
  return -1;
}

/** The index of the `opener` matching the closer at `close`, or -1; `stop` characters end the search. */
export function matchBack(code: string, close: number, opener: string, stop = ''): number {
  const closer = code[close];
  let depth = 0;
  for (let i = close; i >= 0; i--) {
    if (code[i] === closer) depth++;
    else if (code[i] === opener && --depth === 0) return i;
    else if (stop.includes(code[i])) return -1;
  }
  return -1;
}

/** Where `name` occurs as a whole word before `before`, latest first. */
export function occurrencesBefore(code: string, name: string, before: number): number[] {
  const found: number[] = [];
  for (const match of code.slice(0, before).matchAll(new RegExp(`\\b${name}\\b`, 'g'))) found.push(match.index);
  return found.reverse();
}

/**
 * The receiver of a member access the code ends in: `grid[i].` or `grid[i].si` is grid with one
 * subscript, `i` (what stands between each pair of brackets, the last one first); `arrow` when it
 * is reached through a pointer, as in `node->`.
 */
export interface Access {
  readonly receiver: { readonly name: string; readonly start: number } | 'string literal';
  readonly subscripts: readonly string[];
  readonly arrow: boolean;
}

export function trailingAccess(code: string, arrow: boolean): Access | null {
  let i = code.length;
  while (isWordChar(code[i - 1])) i--;
  i = skipWsBack(code, i);
  const isArrow = arrow && code.slice(i - 2, i) === '->';
  if (isArrow) i -= 2;
  else if (code[i - 1] === '.') i--;
  else return null;
  i = skipWsBack(code, i);

  const subscripts: string[] = [];
  while (code[i - 1] === ']') {
    const open = matchBack(code, i - 1, '[');
    if (open < 0) return null;
    subscripts.push(code.slice(open + 1, i - 1));
    i = skipWsBack(code, open);
  }

  if (/["']/.test(code[i - 1]) && code[i - 2] === code[i - 1]) {
    let open = i - 2;
    while (code[open - 1] === code[i - 1]) open--;
    // A bytes literal, `b"..."`, has no table.
    if (/[bB]/.test(/\w*$/.exec(code.slice(Math.max(0, open - 2), open))![0])) return null;
    return { receiver: 'string literal', subscripts, arrow: isArrow };
  }

  let start = i;
  while (isWordChar(code[start - 1])) start--;
  const name = code.slice(start, i);
  if (!/^[A-Za-z_]/.test(name)) return null;
  const before = skipWsBack(code, start);
  if (code[before - 1] === '.' || /->|::/.test(code.slice(before - 2, before))) return null;
  return { receiver: { name, start }, subscripts, arrow: isArrow };
}

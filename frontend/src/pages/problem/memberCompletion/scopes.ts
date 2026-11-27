/**
 * Every bracket of a comment- and string-free text, found in one pass: `close[i]` is where the
 * `(`, `[` or `{` at `i` closes (the text's length when it never does), and `opener[i]` is the
 * innermost bracket still open at `i` (-1 at the top level).
 */
export interface Brackets {
  readonly close: Int32Array;
  readonly opener: Int32Array;
}

export function brackets(code: string): Brackets {
  const close = new Int32Array(code.length).fill(code.length);
  const opener = new Int32Array(code.length);
  const open: number[] = [];
  for (let i = 0; i < code.length; i++) {
    opener[i] = open.length ? open[open.length - 1] : -1;
    const c = code[i];
    if (c === '(' || c === '[' || c === '{') open.push(i);
    else if ((c === ')' || c === ']' || c === '}') && open.length) close[open.pop()!] = i;
  }
  return { close, opener };
}

/** The positions a declaration is local to, both ends included: a block, a parameter list and its body. */
export type Range = readonly [start: number, end: number];

/**
 * Which declarations can be seen from where. The ranges nest, so each position has an innermost
 * one; a declaration inside a range is seen only from inside that same range, and one in none is
 * seen from everywhere after it.
 */
export class Scopes {
  private readonly innermost: Int32Array;
  private readonly ends: number[];

  constructor(length: number, ranges: readonly Range[]) {
    const sorted = [...ranges].sort((a, b) => a[0] - b[0] || b[1] - a[1]);
    this.ends = sorted.map((range) => range[1]);
    this.innermost = new Int32Array(length);
    const open: number[] = [];
    let next = 0;
    for (let i = 0; i < length; i++) {
      while (open.length && this.ends[open[open.length - 1]] < i) open.pop();
      while (next < sorted.length && sorted[next][0] === i) open.push(next++);
      this.innermost[i] = open.length ? open[open.length - 1] : -1;
    }
  }

  /** Whether a declaration at `at` can be seen from `from`, a later position. */
  visible(at: number, from: number): boolean {
    const scope = this.innermost[at];
    return scope < 0 || from <= this.ends[scope];
  }
}

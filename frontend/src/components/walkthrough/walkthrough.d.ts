// Types for the Walkthrough format (references/format.md) and the player.
export type Text = string | { [lang: string]: string };
export type Mark = 'lit' | 'good' | 'bad' | 'path' | 'dim';
export type Marks<K> = Partial<Record<Mark, K[]>>;

export type View =
  | { id: string; type: 'grid'; title?: Text; values?: Record<string, { label?: Text; tone?: 'a' | 'b' | 'c' | 'd' | 'empty' | 'wall' | 'plain'; glyph?: string }>; showValues?: boolean; /** a heavier line every this many rows and columns (a sudoku's 3) */ boxes?: number }
  | { id: string; type: 'array'; title?: Text; display?: 'cells' | 'bars'; max?: number }
  | { id: string; type: 'map'; title?: Text; empty?: Text }
  | { id: string; type: 'set'; title?: Text; empty?: Text; hit?: Text; miss?: Text }
  | { id: string; type: 'output'; title?: Text; empty?: Text }
  | { id: string; type: 'queue'; title?: Text; empty?: Text; deque?: boolean }
  | { id: string; type: 'intervals'; title?: Text; empty?: Text }
  | { id: string; type: 'graph'; title?: Text; directed?: boolean }
  | { id: string; type: 'table'; title?: Text }
  | { id: string; type: 'vars'; title?: Text };

export interface GridState {
  cells: unknown[][]; marks?: Marks<[number, number]>; tags?: [number, number, Text][];
  /** cells drawn on a soft band under any mark: a region in play, such as a cell's row, column and box */ shade?: [number, number][];
}
/** A named range of an array, `from`..`to` inclusive: above the cells (a live window), or `below` them, dashed (a record
 *  such as the best so far). `fade` fades the cells outside it that carry no mark. The label defaults to the name. */
export interface Span { from: number; to: number; label?: Text; mark?: Mark; below?: boolean; fade?: boolean }
export interface ArrayState {
  values: unknown[]; fill?: number[]; pointers?: Record<string, number | null>; marks?: Marks<number>; tags?: [number, Text][];
  /** by name; `null` hides one */ spans?: Record<string, Span | null>;
  /** cells not read yet, drawn dashed */ unread?: number[];
  /** a running value under a cell */ under?: [number, Text][];
}
export type Key = string | number;
/** A hash map: entries in insertion order with unique keys; a count is drawn as dots, a list as chips. `ranks` badges keys #1, #2…; `probe` is a lookup that hits or misses */
export interface MapState {
  /** `label` is written on the card in place of the key; `marks` mark chips of a list value by index */
  entries: { key: Key; value: unknown; label?: Text; marks?: Marks<number> }[]; marks?: Marks<Key>; ranks?: Key[];
  /** holds at most this many keys: the free slots are drawn, and a key beyond them is red */ slots?: number;
  /** keys leaving this step (a count that reached 0), struck through; they hold no slot */ struck?: Key[];
  /** a lookup of `key`: a hit rings its card, a miss is a red dashed chip; `label` replaces the key on the chip; `hit` (default: the key is held) is what the lookup found, for a step that stores the key after it */ probe?: { key: Key; label?: Text; hit?: boolean };
}
/** A set: members in insertion order, unique. A probe is a lookup drawn above the bag: `hit` (default: whether `value`
 *  is a member) lights the member it finds; a miss is drawn dashed. Address: a member. */
export interface SetState { members: Key[]; marks?: Marks<Key>; probes?: { value: Key; hit?: boolean; label?: Text }[] }
/** The answer as it forms: one chip per value. */
export interface OutputState { values: unknown[]; marks?: Marks<number> }
/** A queue as a horizontal pipe, front first: values join at the back (right) and leave from the front (left); a
 *  `deque` view is open at both ends. `tags` label positions above their value. Address: a position from the front. */
export interface QueueState { values: unknown[]; marks?: Marks<number>; tags?: [number, Text][] }
/** Intervals on one number line: groups (the input, the merged output) of [start, end] rows over a shared axis, which
 *  spans `domain` (default: every value in the frame). `points` draw a value across every row. Address: [group, index]. */
export interface IntervalsState {
  groups: { label?: Text; intervals: [number, number][]; marks?: Marks<number> }[];
  points?: { at: number; label?: Text; mark?: Mark }[];
  domain?: [number, number];
}
/** Address: a node id, or an edge as [from, to] (either order when the view isn't `directed`). A move from a node
 *  carries the value under it, one from an edge its label. */
export interface GraphState {
  nodes: { id: string | number; label?: Text; tag?: Text }[];
  edges: { from: string | number; to: string | number; label?: Text }[];
  values?: Record<string, unknown>; nodeMarks?: Marks<string | number>; edgeMarks?: Marks<number>;
}
export interface TableState { columns?: Text[]; rows: { label: Text; cells: unknown[] }[]; marks?: Marks<[number, number]> }
export interface VarsState { items: { label: Text; value: unknown; mark?: Mark | null; empty?: Text }[] }

/** A place in a view: an array or output index, a map key, a set member, a queue position from the front, a grid [row, col], a table [row, col], an intervals [group, index], a graph node id or [from, to] edge. Each view type that holds values defines its `at`. */
export interface Address { view: string; at: number | string | [number, number] | [string | number, string | number] }
/** A value going from one place to another. No `from`: created at `to`; no `to`: dropped from `from`.
 *  `value` is the chip's text (default: the source's); `mark` overrides the colour (default: path into an output, bad when dropped, else good). */
export interface Move { from?: Address; to?: Address; value?: unknown; mark?: 'good' | 'bad' | 'path' }
export interface Frame { caption: Text; views?: Record<string, object>; moves?: Move[]; answer?: unknown }
export interface Run { label: Text; input?: string; expected: unknown; extra?: boolean; setup?: Record<string, object>; frames: Frame[] }
export interface Walkthrough { format: 'walkthrough/1'; title: Text; approach: Text; views: View[]; runs: Run[] }

export interface MountOptions {
  lang?: string;
  theme?: 'light' | 'dark';
  start?: { run?: number | string | null; frame?: number | string | 'last' | null };
  interval?: number;
  hint?: boolean;
  ui?: Partial<Record<'front' | 'back' | 'empty' | 'expected' | 'extra' | 'step' | 'first' | 'prev' | 'next' | 'play' | 'pause' | 'hint', string>>;
  onChange?: (run: number, frame: number) => void;
}
export interface Player { show(run: number, frame: number | 'last'): void; destroy(): void }
export function mount(root: HTMLElement, walkthrough: Walkthrough, options?: MountOptions): Player;
/** The index of the edge a graph address `[from, to]` names, or -1; an undirected edge answers to either order. */
export function edgeAt(edges: GraphState['edges'], at: [string | number, string | number], directed: boolean): number;
/** Nodes evenly on a circle centred on 0,0 (y down), the first at the top, going clockwise. */
export function layoutGraph(nodes: GraphState['nodes']): { pos: Map<string, { x: number; y: number }>; radius: number };
/** The centre of a w × h label chip beside the middle of an edge, clear of it, on the side away from 0,0 (or `side`). */
export function edgeLabelAt(x1: number, y1: number, x2: number, y2: number, w: number, h: number, side?: number): { x: number; y: number };
export function axisTicks(min: number, max: number): number[];
export function textOf(text: Text | null | undefined, lang: string): string;
export const MARKS: Mark[];

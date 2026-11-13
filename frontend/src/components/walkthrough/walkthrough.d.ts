// Types for the Walkthrough format (references/format.md) and the player.
export type Text = string | { [lang: string]: string };
export type Mark = 'lit' | 'good' | 'bad' | 'path' | 'dim';
export type Marks<K> = Partial<Record<Mark, K[]>>;

export type View =
  | { id: string; type: 'grid'; title?: Text; values?: Record<string, { label?: Text; tone?: 'a' | 'b' | 'c' | 'd' | 'empty' | 'wall' | 'plain'; glyph?: string }>; showValues?: boolean }
  | { id: string; type: 'array'; title?: Text; display?: 'cells' | 'bars'; max?: number }
  | { id: string; type: 'map'; title?: Text; empty?: Text }
  | { id: string; type: 'output'; title?: Text; empty?: Text }
  | { id: string; type: 'graph'; title?: Text; directed?: boolean }
  | { id: string; type: 'table'; title?: Text }
  | { id: string; type: 'vars'; title?: Text };

export interface GridState { cells: unknown[][]; marks?: Marks<[number, number]>; tags?: [number, number, Text][] }
export interface ArrayState { values: unknown[]; fill?: number[]; pointers?: Record<string, number | null>; marks?: Marks<number>; tags?: [number, Text][] }
export type Key = string | number;
/** A hash map: entries in insertion order with unique keys; a count is drawn as dots, a list as chips. `ranks` badges keys #1, #2… */
export interface MapState { entries: { key: Key; value: unknown }[]; marks?: Marks<Key>; ranks?: Key[] }
/** The answer as it forms: one chip per value. */
export interface OutputState { values: unknown[]; marks?: Marks<number> }
export interface GraphState {
  nodes: { id: string | number; label?: Text; tag?: Text }[];
  edges: { from: string | number; to: string | number; label?: Text }[];
  values?: Record<string, unknown>; nodeMarks?: Marks<string | number>; edgeMarks?: Marks<number>;
}
export interface TableState { columns?: Text[]; rows: { label: Text; cells: unknown[] }[]; marks?: Marks<[number, number]> }
export interface VarsState { items: { label: Text; value: unknown; mark?: Mark | null; empty?: Text }[] }

/** A place in a view: an array or output index, a map key. Each view type that holds values defines its `at`. */
export interface Address { view: string; at: number | string | [number, number] }
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
  ui?: Partial<Record<'expected' | 'extra' | 'step' | 'first' | 'prev' | 'next' | 'play' | 'pause' | 'hint', string>>;
  onChange?: (run: number, frame: number) => void;
}
export interface Player { show(run: number, frame: number | 'last'): void; destroy(): void }
export function mount(root: HTMLElement, walkthrough: Walkthrough, options?: MountOptions): Player;
export function layoutGraph(nodes: GraphState['nodes'], edges: GraphState['edges'], directed: boolean): { pos: Map<string, { col: number; row: number }>; cols: number; rows: number };
export function textOf(text: Text | null | undefined, lang: string): string;
export const MARKS: Mark[];

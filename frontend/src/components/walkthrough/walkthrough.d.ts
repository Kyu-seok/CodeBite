// Types for the Walkthrough format (references/format.md) and the player.
export type Text = string | { [lang: string]: string };
export type Mark = 'lit' | 'good' | 'bad' | 'path' | 'dim';
export type Marks<K> = Partial<Record<Mark, K[]>>;

export type View =
  | { id: string; type: 'grid'; title?: Text; values?: Record<string, { label?: Text; tone?: 'a' | 'b' | 'c' | 'd' | 'empty' | 'wall' | 'plain'; glyph?: string }>; showValues?: boolean }
  | { id: string; type: 'array'; title?: Text; display?: 'cells' | 'bars'; max?: number }
  | { id: string; type: 'graph'; title?: Text; directed?: boolean }
  | { id: string; type: 'table'; title?: Text }
  | { id: string; type: 'vars'; title?: Text };

export interface GridState { cells: unknown[][]; marks?: Marks<[number, number]>; tags?: [number, number, Text][] }
export interface ArrayState { values: unknown[]; fill?: number[]; pointers?: Record<string, number | null>; marks?: Marks<number>; tags?: [number, Text][] }
export interface GraphState {
  nodes: { id: string | number; label?: Text; tag?: Text }[];
  edges: { from: string | number; to: string | number; label?: Text }[];
  values?: Record<string, unknown>; nodeMarks?: Marks<string | number>; edgeMarks?: Marks<number>;
}
export interface TableState { columns?: Text[]; rows: { label: Text; cells: unknown[] }[]; marks?: Marks<[number, number]> }
export interface VarsState { items: { label: Text; value: unknown; mark?: Mark | null; empty?: Text }[] }

export interface Frame { caption: Text; views?: Record<string, object>; answer?: unknown }
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

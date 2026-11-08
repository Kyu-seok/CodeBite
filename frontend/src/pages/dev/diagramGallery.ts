// The decisions behind the dev-only Diagram gallery (/dev/diagrams), free of React so Vitest can
// check them: which fenced blocks of a description are Diagrams, which example each sits under, and
// whether its directive parses.

import { parseDiagram } from "@/components/markdown/diagrams/parseDiagram";

/** One `diagram-*` fenced block of a description. */
export interface DiagramBlock {
  /** The fence's info string, e.g. `diagram-tree`. */
  info: string;
  /** The kind as the caption names it: tree, graph, grid, linked list, intervals. */
  kind: string;
  /** The block's lines between the fences. */
  body: string;
  /** The N of the nearest `**Example N:**` marker above the block, or null before any. */
  example: number | null;
  /** The block as it stands in the description, fences included: what the renderer draws. */
  source: string;
}

const EXAMPLE_MARKER = /\*\*Example (\d+):\*\*/;

export function findDiagramBlocks(description: string): DiagramBlock[] {
  const blocks: DiagramBlock[] = [];
  let example: number | null = null;
  let open: { info: string; lines: string[] } | null = null;
  for (const rawLine of description.split("\n")) {
    const line = rawLine.trim();
    if (open) {
      if (line === "```") {
        if (open.info.startsWith("diagram-")) {
          const body = open.lines.join("\n");
          blocks.push({
            info: open.info,
            kind: open.info.slice("diagram-".length).replace(/-/g, " "),
            body,
            example,
            source: "```" + open.info + "\n" + body + "\n```",
          });
        }
        open = null;
      } else {
        open.lines.push(rawLine);
      }
      continue;
    }
    const marker = EXAMPLE_MARKER.exec(line);
    if (marker) example = Number(marker[1]);
    if (line.startsWith("```")) open = { info: line.slice(3).trim(), lines: [] };
  }
  return blocks;
}

export type DiagramParseStatus = { ok: true } | { ok: false; message: string };

/**
 * Whether the renderer draws the block or falls back to the raw text, with the parser's message
 * when it falls back: the tile shows the raw block either way, this says why.
 */
export function diagramParseStatus(block: DiagramBlock): DiagramParseStatus {
  const parsed = parseDiagram(block.info, block.body);
  return parsed.ok ? { ok: true } : parsed;
}

/** Tile widths in px: a narrowed description pane, the default half-window pane, a wide one. */
export const WIDTH_PRESETS = [360, 640, 900] as const;
export type TileWidth = (typeof WIDTH_PRESETS)[number];
export const DEFAULT_WIDTH: TileWidth = 640;

export type GalleryAccess = "loading" | "denied" | "allowed";

/**
 * Whether the page may read the admin list and details: only an ADMIN session fetches anything;
 * signed out or USER gets the test-token message; a stored token still being checked gets neither.
 */
export function galleryAccess(auth: { loading: boolean; user: { role: string } | null }): GalleryAccess {
  if (auth.loading) return "loading";
  return auth.user?.role === "ADMIN" ? "allowed" : "denied";
}

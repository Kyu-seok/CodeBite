// The one place a `diagram-*` fence's info string meets its parser. MarkdownRenderer draws what
// this returns and the dev gallery (pages/dev/diagramGallery.ts) reports why a block isn't drawn,
// so a new kind is one entry in KINDS here plus its component case in the renderer.

import {
  parseGraphDirective,
  parseGridDirective,
  parseIntervalsDirective,
  parseLinkedListDirective,
  parseTreeDirective,
  type GraphDirective,
  type GridDirective,
  type IntervalsDirective,
  type LinkedListDirective,
  type TreeDirective,
} from "./parseDirective";

/** A parsed Diagram, tagged by the info string that named it. */
export type ParsedDiagram =
  | { info: "diagram-tree"; spec: TreeDirective }
  | { info: "diagram-graph"; spec: GraphDirective }
  | { info: "diagram-grid"; spec: GridDirective }
  | { info: "diagram-linked-list"; spec: LinkedListDirective }
  | { info: "diagram-intervals"; spec: IntervalsDirective };

export type DiagramInfo = ParsedDiagram["info"];

const KINDS: { [K in ParsedDiagram as K["info"]]: (body: string) => K["spec"] } = {
  "diagram-tree": parseTreeDirective,
  "diagram-graph": parseGraphDirective,
  "diagram-grid": parseGridDirective,
  "diagram-linked-list": parseLinkedListDirective,
  "diagram-intervals": parseIntervalsDirective,
};

/** Every info string a fence may carry to be drawn as a Diagram. */
export const DIAGRAM_INFOS = Object.keys(KINDS) as DiagramInfo[];

export type DiagramParse = { ok: true; diagram: ParsedDiagram } | { ok: false; message: string };

/**
 * Parses the body of a fence whose info string is `info`: the Diagram to draw, or the message
 * saying why it can't be (an info string no parser knows, or the parser's own complaint).
 */
export function parseDiagram(info: string, body: string): DiagramParse {
  if (!isDiagramInfo(info)) return { ok: false, message: `Unknown Diagram kind: ${info}` };
  try {
    // KINDS pairs each tag with a parser of its spec type; the cast only joins the two again.
    return { ok: true, diagram: { info, spec: KINDS[info](body) } as ParsedDiagram };
  } catch (e) {
    return { ok: false, message: e instanceof Error ? e.message : String(e) };
  }
}

function isDiagramInfo(info: string): info is DiagramInfo {
  return (DIAGRAM_INFOS as string[]).includes(info);
}

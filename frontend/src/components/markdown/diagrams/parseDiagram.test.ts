import { describe, expect, it } from "vitest";
import { DIAGRAM_INFOS, parseDiagram } from "./parseDiagram";

describe("parseDiagram", () => {
  it("tags a parsed Diagram with the info string that named it", () => {
    const parsed = parseDiagram("diagram-tree", "nodes: [3, 9, 20, null, null, 15, 7]");
    if (!parsed.ok || parsed.diagram.info !== "diagram-tree") throw new Error(`not a tree: ${JSON.stringify(parsed)}`);
    expect(parsed.diagram.spec.nodes).toEqual([3, 9, 20, null, null, 15, 7]);
  });

  it("parses every known kind", () => {
    const bodies: Record<string, string> = {
      "diagram-tree": "nodes: [1, 2]",
      "diagram-graph": "edges: [[0, 1]]",
      "diagram-grid": "cells: [[1, 0]]",
      "diagram-linked-list": "nodes: [1, 2]",
      "diagram-intervals": "intervals: [[1, 3]]",
    };
    expect(Object.keys(bodies).sort()).toEqual([...DIAGRAM_INFOS].sort());
    for (const info of DIAGRAM_INFOS) {
      const parsed = parseDiagram(info, bodies[info]);
      expect(parsed, info).toMatchObject({ ok: true, diagram: { info } });
    }
  });

  it("passes the parser's own complaint through for a malformed body", () => {
    expect(parseDiagram("diagram-tree", "nodes: [3, 9, 20")).toEqual({
      ok: false,
      message: 'Could not parse value for "nodes": [3, 9, 20',
    });
  });

  it("names an info string no parser knows", () => {
    expect(parseDiagram("diagram-heap", "nodes: [1]")).toEqual({
      ok: false,
      message: "Unknown Diagram kind: diagram-heap",
    });
  });
});

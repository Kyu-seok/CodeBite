import { describe, expect, it } from "vitest";
import { DEFAULT_WIDTH, WIDTH_PRESETS, diagramParseStatus, findDiagramBlocks, galleryAccess } from "./diagramGallery";

// A description as the migrations write it: the Diagram sits under its example's code block.
const REVERSE_LIST = [
  "Given the `head` of a singly linked list, reverse the list.",
  "",
  "**Example 1:**",
  "```",
  "Input: head = [1,2,3,4,5]",
  "Output: [5,4,3,2,1]",
  "```",
  "",
  "```diagram-linked-list",
  "nodes: [1,2,3,4,5]",
  "after: [5,4,3,2,1]",
  "```",
  "",
  "**Example 2:**",
  "```",
  "Input: head = [1,2]",
  "Output: [2,1]",
  "```",
].join("\n");

describe("findDiagramBlocks", () => {
  it("finds a Diagram with its kind, body and the example it sits under", () => {
    expect(findDiagramBlocks(REVERSE_LIST)).toEqual([
      {
        info: "diagram-linked-list",
        kind: "linked list",
        body: "nodes: [1,2,3,4,5]\nafter: [5,4,3,2,1]",
        example: 1,
        source: "```diagram-linked-list\nnodes: [1,2,3,4,5]\nafter: [5,4,3,2,1]\n```",
      },
    ]);
  });
});

describe("findDiagramBlocks across examples", () => {
  it("credits each Diagram to the example above it and skips the Input fences", () => {
    const sudoku = [
      "**Example 1:**",
      "```",
      "Input: board = [[\"5\",\"3\"],[\".\",\"8\"]]",
      "```",
      "```diagram-grid",
      'cells: [["5","3"],[".","8"]]',
      "```",
      "**Example 2:**",
      "```",
      "Input: board = [[\"8\",\"3\"],[\".\",\"8\"]]",
      "```",
      "```diagram-grid",
      'cells: [["8","3"],[".","8"]]',
      "highlight: [[0,0],[1,1]]",
      "```",
    ].join("\n");
    expect(findDiagramBlocks(sudoku).map((b) => [b.kind, b.example, b.body])).toEqual([
      ["grid", 1, 'cells: [["5","3"],[".","8"]]'],
      ["grid", 2, 'cells: [["8","3"],[".","8"]]\nhighlight: [[0,0],[1,1]]'],
    ]);
  });

  it("reports no example for a Diagram above the first marker", () => {
    const blocks = findDiagramBlocks("Intro.\n```diagram-tree\nnodes: [1]\n```\n**Example 1:**\n```\nInput: x\n```");
    expect(blocks).toHaveLength(1);
    expect(blocks[0].example).toBeNull();
  });

  it("finds nothing in a description without a Diagram", () => {
    expect(findDiagramBlocks("**Example 1:**\n```\nInput: nums = [1]\nOutput: 1\n```")).toEqual([]);
  });
});

describe("diagramParseStatus", () => {
  const block = (info: string, body: string) => findDiagramBlocks("```" + info + "\n" + body + "\n```")[0];

  it("accepts a block the renderer would draw", () => {
    expect(diagramParseStatus(block("diagram-tree", "nodes: [3, 9, 20, null, null, 15, 7]"))).toEqual({ ok: true });
  });

  it("names the parser's complaint about a malformed directive, as the raw block in the tile would not", () => {
    expect(diagramParseStatus(block("diagram-tree", "nodes: [3, 9, 20"))).toEqual({
      ok: false,
      message: 'Could not parse value for "nodes": [3, 9, 20',
    });
  });

  it("rejects a kind no renderer knows", () => {
    expect(diagramParseStatus(block("diagram-heap", "nodes: [1]"))).toEqual({
      ok: false,
      message: "Unknown Diagram kind: diagram-heap",
    });
  });
});

describe("galleryAccess", () => {
  it("waits while a stored token is still being checked, so no message flashes at an admin", () => {
    expect(galleryAccess({ loading: true, user: null })).toBe("loading");
  });

  it("denies a visitor and a signed-in USER alike: both get the test-token message, no detail requests", () => {
    expect(galleryAccess({ loading: false, user: null })).toBe("denied");
    expect(galleryAccess({ loading: false, user: { role: "USER" } })).toBe("denied");
  });

  it("allows an ADMIN", () => {
    expect(galleryAccess({ loading: false, user: { role: "ADMIN" } })).toBe("allowed");
  });
});

describe("width presets", () => {
  it("offers a narrowed pane, the default half-window pane and a wide one, defaulting to the middle", () => {
    expect(WIDTH_PRESETS).toEqual([360, 640, 900]);
    expect(DEFAULT_WIDTH).toBe(640);
  });
});

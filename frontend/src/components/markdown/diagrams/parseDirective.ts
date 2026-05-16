// Parse a `diagram-*` fenced-code-block body into a typed spec.
//
// Body format is YAML-ish: one `key: value` per line. The value side is
// JSON-parsed, so authors can paste LeetCode-style arrays verbatim:
//
//   nodes: [3, 9, 20, null, null, 15, 7]
//   highlight: [3, 6]
//
// Lines starting with `#` are comments. Throws on malformed input so the
// caller can fall back to rendering the raw block.

export type TreeNode = number | string | null;
export type GraphNode = number | string;
export type Edge = [GraphNode, GraphNode];

export interface TreeDirective {
  nodes: TreeNode[];
  highlight: number[];
  /** Optional second tree — when present, the diagram renders as a before→after pair. */
  after?: TreeNode[];
}

export interface GraphDirective {
  edges: Edge[];
  /** Optional explicit node list. If omitted, nodes are inferred from edges. */
  nodes?: GraphNode[];
  directed: boolean;
  /** Optional ordered list of nodes forming a path to emphasize. */
  highlight_path: GraphNode[];
  /** Optional second graph (edges only) for before→after pair rendering. */
  after?: Edge[];
}

function parseKeyValueLines(body: string): Map<string, unknown> {
  const map = new Map<string, unknown>();
  for (const rawLine of body.split("\n")) {
    const line = rawLine.trim();
    if (!line || line.startsWith("#")) continue;
    const colon = line.indexOf(":");
    if (colon === -1) {
      throw new Error(`Malformed directive line (expected "key: value"): ${line}`);
    }
    const key = line.slice(0, colon).trim();
    const valueRaw = line.slice(colon + 1).trim();
    if (!key) throw new Error(`Empty key in directive line: ${line}`);
    try {
      map.set(key, JSON.parse(valueRaw));
    } catch {
      throw new Error(`Could not parse value for "${key}": ${valueRaw}`);
    }
  }
  return map;
}

export function parseTreeDirective(body: string): TreeDirective {
  const map = parseKeyValueLines(body);

  const nodes = map.get("nodes");
  if (!Array.isArray(nodes)) {
    throw new Error("'nodes' must be an array (e.g. nodes: [3, 9, 20, null])");
  }
  for (const n of nodes) {
    if (n !== null && typeof n !== "number" && typeof n !== "string") {
      throw new Error("'nodes' entries must be number, string, or null");
    }
  }

  const highlightRaw = map.get("highlight") ?? [];
  if (!Array.isArray(highlightRaw) || !highlightRaw.every((v) => typeof v === "number")) {
    throw new Error("'highlight' must be an array of numbers (array indices)");
  }

  const afterRaw = map.get("after");
  let after: TreeNode[] | undefined;
  if (afterRaw !== undefined) {
    if (!Array.isArray(afterRaw)) {
      throw new Error("'after' must be an array (e.g. after: [5, 8, 3])");
    }
    for (const n of afterRaw) {
      if (n !== null && typeof n !== "number" && typeof n !== "string") {
        throw new Error("'after' entries must be number, string, or null");
      }
    }
    after = afterRaw as TreeNode[];
  }

  return {
    nodes: nodes as TreeNode[],
    highlight: highlightRaw as number[],
    after,
  };
}

function isEdgeArray(v: unknown): v is Edge[] {
  if (!Array.isArray(v)) return false;
  for (const e of v) {
    if (!Array.isArray(e) || e.length !== 2) return false;
    for (const node of e) {
      if (typeof node !== "number" && typeof node !== "string") return false;
    }
  }
  return true;
}

export function parseGraphDirective(body: string): GraphDirective {
  const map = parseKeyValueLines(body);

  const edges = map.get("edges");
  if (!isEdgeArray(edges)) {
    throw new Error(
      "'edges' must be an array of [from, to] pairs (e.g. edges: [[0,1],[1,2]])",
    );
  }

  const nodesRaw = map.get("nodes");
  let nodes: GraphNode[] | undefined;
  if (nodesRaw !== undefined) {
    if (
      !Array.isArray(nodesRaw) ||
      !nodesRaw.every((n) => typeof n === "number" || typeof n === "string")
    ) {
      throw new Error("'nodes' must be an array of numbers or strings");
    }
    nodes = nodesRaw as GraphNode[];
  }

  const directedRaw = map.get("directed") ?? false;
  if (typeof directedRaw !== "boolean") {
    throw new Error("'directed' must be a boolean (true or false)");
  }

  const highlightPathRaw = map.get("highlight_path") ?? [];
  if (
    !Array.isArray(highlightPathRaw) ||
    !highlightPathRaw.every((n) => typeof n === "number" || typeof n === "string")
  ) {
    throw new Error("'highlight_path' must be an array of node ids (numbers or strings)");
  }

  const afterRaw = map.get("after");
  let after: Edge[] | undefined;
  if (afterRaw !== undefined) {
    if (!isEdgeArray(afterRaw)) {
      throw new Error(
        "'after' must be an array of [from, to] pairs matching the edges shape",
      );
    }
    after = afterRaw;
  }

  return {
    edges,
    nodes,
    directed: directedRaw,
    highlight_path: highlightPathRaw as GraphNode[],
    after,
  };
}

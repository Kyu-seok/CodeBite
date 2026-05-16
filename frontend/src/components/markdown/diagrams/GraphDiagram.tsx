import { useId } from "react";
import type { Edge, GraphNode } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface GraphDiagramProps {
  edges: Edge[];
  nodes?: GraphNode[];
  directed?: boolean;
  highlight_path?: GraphNode[];
  /** When present, renders as a before→after pair side-by-side with an arrow. */
  after?: Edge[];
}

const NODE_R = 18;
const PADDING = NODE_R + 6;
const RADIUS = 90;
const SIZE = (RADIUS + PADDING) * 2;

export function GraphDiagram({
  edges,
  nodes,
  directed = false,
  highlight_path = [],
  after,
}: GraphDiagramProps) {
  if (after) {
    return (
      <BeforeAfterPair
        before={
          <SingleGraphSvg
            edges={edges}
            nodes={nodes}
            directed={directed}
            highlight_path={highlight_path}
          />
        }
        after={
          <SingleGraphSvg
            edges={after}
            nodes={collectNodes(after, undefined)}
            directed={directed}
          />
        }
      />
    );
  }
  return (
    <div className="my-4">
      <SingleGraphSvg
        edges={edges}
        nodes={nodes}
        directed={directed}
        highlight_path={highlight_path}
      />
    </div>
  );
}

function collectNodes(edges: Edge[], explicit: GraphNode[] | undefined): GraphNode[] {
  if (explicit && explicit.length > 0) return explicit;
  const seen = new Map<string, GraphNode>();
  for (const [a, b] of edges) {
    seen.set(String(a), a);
    seen.set(String(b), b);
  }
  return Array.from(seen.values());
}

interface SingleGraphProps {
  edges: Edge[];
  nodes?: GraphNode[];
  directed?: boolean;
  highlight_path?: GraphNode[];
}

function SingleGraphSvg({
  edges,
  nodes,
  directed = false,
  highlight_path = [],
}: SingleGraphProps) {
  const allNodes = collectNodes(edges, nodes);

  if (allNodes.length === 0) {
    return (
      <div className="flex justify-center text-xs italic text-muted-foreground">
        (empty graph)
      </div>
    );
  }

  // Circular layout: place nodes evenly around a circle. Start at top
  // (-90deg) so single-node and small graphs feel anchored.
  const cx = SIZE / 2;
  const cy = SIZE / 2;
  const positions = new Map<string, { x: number; y: number; node: GraphNode }>();
  allNodes.forEach((node, i) => {
    const theta = (-Math.PI / 2) + (i * 2 * Math.PI) / allNodes.length;
    positions.set(String(node), {
      x: cx + RADIUS * Math.cos(theta),
      y: cy + RADIUS * Math.sin(theta),
      node,
    });
  });

  // Highlighted edges = consecutive pairs in highlight_path, in either direction.
  const highlightedEdgeKeys = new Set<string>();
  for (let i = 0; i < highlight_path.length - 1; i++) {
    const a = String(highlight_path[i]);
    const b = String(highlight_path[i + 1]);
    highlightedEdgeKeys.add(`${a}|${b}`);
    if (!directed) highlightedEdgeKeys.add(`${b}|${a}`);
  }
  const highlightedNodeKeys = new Set(highlight_path.map(String));

  const arrowMarkerId = `gdiag-arrow-${useId().replace(/:/g, "")}`;

  return (
    <svg
      viewBox={`0 0 ${SIZE} ${SIZE}`}
      className="mx-auto block w-full max-w-sm text-foreground"
      role="img"
      aria-label="Graph diagram"
    >
      {directed && (
        <defs>
          <marker
            id={arrowMarkerId}
            viewBox="0 0 10 10"
            refX={10}
            refY={5}
            markerWidth={6}
            markerHeight={6}
            orient="auto-start-reverse"
          >
            <path d="M 0 0 L 10 5 L 0 10 z" fill="currentColor" />
          </marker>
        </defs>
      )}

      {/* Edges */}
      {edges.map(([a, b], idx) => {
        const pa = positions.get(String(a));
        const pb = positions.get(String(b));
        if (!pa || !pb) return null;
        const isHl = highlightedEdgeKeys.has(`${String(a)}|${String(b)}`);
        // For directed edges, shorten the line so the arrowhead lands at the
        // node's edge rather than its center.
        const { x1, y1, x2, y2 } = directed
          ? trimToCircle(pa.x, pa.y, pb.x, pb.y, NODE_R + 2)
          : { x1: pa.x, y1: pa.y, x2: pb.x, y2: pb.y };
        return (
          <line
            key={`e-${idx}`}
            x1={x1}
            y1={y1}
            x2={x2}
            y2={y2}
            stroke="currentColor"
            strokeOpacity={isHl ? 1 : 0.45}
            strokeWidth={isHl ? 2.5 : 1.5}
            className={isHl ? "text-accent-500" : undefined}
            markerEnd={directed ? `url(#${arrowMarkerId})` : undefined}
          />
        );
      })}

      {/* Nodes */}
      {Array.from(positions.values()).map((p) => {
        const isHl = highlightedNodeKeys.has(String(p.node));
        return (
          <g key={`n-${String(p.node)}`}>
            <circle
              cx={p.x}
              cy={p.y}
              r={NODE_R}
              className={
                isHl
                  ? "fill-accent-500 stroke-accent-500"
                  : "fill-background stroke-foreground/60"
              }
              strokeWidth={isHl ? 2.5 : 1.5}
            />
            <text
              x={p.x}
              y={p.y}
              textAnchor="middle"
              dominantBaseline="central"
              fontSize={13}
              fontWeight={isHl ? 600 : 500}
              className={isHl ? "fill-white" : "fill-foreground"}
            >
              {String(p.node)}
            </text>
          </g>
        );
      })}
    </svg>
  );
}

// Trim the endpoint of a directed edge so the arrowhead sits on the node's
// circumference instead of inside the circle.
function trimToCircle(x1: number, y1: number, x2: number, y2: number, r: number) {
  const dx = x2 - x1;
  const dy = y2 - y1;
  const len = Math.hypot(dx, dy);
  if (len === 0) return { x1, y1, x2, y2 };
  const t = (len - r) / len;
  return { x1, y1, x2: x1 + dx * t, y2: y1 + dy * t };
}


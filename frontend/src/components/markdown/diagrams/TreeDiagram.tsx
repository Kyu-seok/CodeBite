import type { TreeNode } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface TreeDiagramProps {
  nodes: TreeNode[];
  highlight?: number[];
  /** When present, renders as a before→after pair side-by-side with an arrow. */
  after?: TreeNode[];
}

const NODE_R = 18;
const ROW_H = 60;
const SLOT_W = 60;

interface PositionedNode {
  idx: number;
  x: number;
  y: number;
}

export function TreeDiagram({ nodes, highlight = [], after }: TreeDiagramProps) {
  if (after) {
    return (
      <BeforeAfterPair
        before={<SingleTreeSvg nodes={nodes} highlight={highlight} />}
        after={<SingleTreeSvg nodes={after} />}
      />
    );
  }
  return (
    <div className="my-4">
      <SingleTreeSvg nodes={nodes} highlight={highlight} />
    </div>
  );
}

interface SingleTreeProps {
  nodes: TreeNode[];
  highlight?: number[];
}

function SingleTreeSvg({ nodes, highlight = [] }: SingleTreeProps) {
  const highlightSet = new Set(highlight);

  let maxDepth = 0;
  for (let i = 0; i < nodes.length; i++) {
    if (nodes[i] === null) continue;
    const d = Math.floor(Math.log2(i + 1));
    if (d > maxDepth) maxDepth = d;
  }

  const slotsBottom = 2 ** maxDepth;
  const width = slotsBottom * SLOT_W;
  const height = (maxDepth + 1) * ROW_H + NODE_R * 2;

  const positions: PositionedNode[] = [];
  for (let i = 0; i < nodes.length; i++) {
    if (nodes[i] === null) continue;
    const depth = Math.floor(Math.log2(i + 1));
    const posInRow = i - (2 ** depth - 1);
    const slotsInRow = 2 ** depth;
    const x = ((posInRow + 0.5) / slotsInRow) * width;
    const y = depth * ROW_H + NODE_R + 4;
    positions.push({ idx: i, x, y });
  }
  const posByIdx = new Map(positions.map((p) => [p.idx, p]));

  if (positions.length === 0) {
    return (
      <div className="flex justify-center text-xs italic text-muted-foreground">
        (empty tree)
      </div>
    );
  }

  return (
    <svg
      viewBox={`0 0 ${width} ${height}`}
      className="mx-auto block w-full text-foreground"
      role="img"
      aria-label="Binary tree diagram"
    >
      {/* Edges */}
      {positions.map((p) => {
        if (p.idx === 0) return null;
        const parentIdx = Math.floor((p.idx - 1) / 2);
        const parent = posByIdx.get(parentIdx);
        if (!parent) return null;
        return (
          <line
            key={`e-${p.idx}`}
            x1={parent.x}
            y1={parent.y}
            x2={p.x}
            y2={p.y}
            stroke="currentColor"
            strokeOpacity={0.4}
            strokeWidth={1.5}
          />
        );
      })}
      {/* Nodes */}
      {positions.map((p) => {
        const isHl = highlightSet.has(p.idx);
        return (
          <g key={`n-${p.idx}`}>
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
              fontSize={14}
              fontWeight={isHl ? 600 : 500}
              className={isHl ? "fill-white" : "fill-foreground"}
            >
              {String(nodes[p.idx])}
            </text>
          </g>
        );
      })}
    </svg>
  );
}

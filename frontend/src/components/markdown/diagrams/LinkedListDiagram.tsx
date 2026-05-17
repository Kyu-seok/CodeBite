import type { ListNode } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface LinkedListDiagramProps {
  nodes: ListNode[];
  cycle_to?: number;
  highlight?: number[];
  /** When present, renders as a before→after pair (e.g. reverse, rotate). */
  after?: ListNode[];
}

const NODE_W = 44;
const NODE_H = 32;
const GAP = 28;
const ARROW = 14;
const PADDING_TOP = 6;
const PADDING_BOTTOM = 28; // room for the cycle loop curve below
const PADDING_X = 12;

export function LinkedListDiagram({
  nodes,
  cycle_to,
  highlight = [],
  after,
}: LinkedListDiagramProps) {
  if (after) {
    return (
      <BeforeAfterPair
        before={<SingleListSvg nodes={nodes} cycle_to={cycle_to} highlight={highlight} />}
        after={<SingleListSvg nodes={after} />}
      />
    );
  }
  return (
    <div className="my-4">
      <SingleListSvg nodes={nodes} cycle_to={cycle_to} highlight={highlight} />
    </div>
  );
}

interface SingleListProps {
  nodes: ListNode[];
  cycle_to?: number;
  highlight?: number[];
}

function SingleListSvg({ nodes, cycle_to, highlight = [] }: SingleListProps) {
  if (nodes.length === 0) {
    return (
      <div className="flex justify-center text-xs italic text-muted-foreground">
        (empty list)
      </div>
    );
  }

  const hasCycle = cycle_to !== undefined;
  const highlightSet = new Set(highlight);

  // Width: N nodes + (N-1) gaps + (final arrow to null OR cycle).
  // No "null" tail rendered when cycle is present.
  const tailExtra = hasCycle ? 0 : NODE_W + GAP;
  const width =
    PADDING_X * 2 + nodes.length * NODE_W + (nodes.length - 1) * GAP + tailExtra;
  const height = PADDING_TOP + NODE_H + (hasCycle ? PADDING_BOTTOM : PADDING_BOTTOM / 2);

  const cy = PADDING_TOP + NODE_H / 2;
  const nodeX = (i: number) => PADDING_X + i * (NODE_W + GAP);

  return (
    <svg
      viewBox={`0 0 ${width} ${height}`}
      className="mx-auto block w-full max-w-md text-foreground"
      role="img"
      aria-label="Linked list diagram"
    >
      <defs>
        <marker
          id="llist-arrow"
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

      {/* Forward arrows between consecutive nodes */}
      {nodes.map((_, i) => {
        if (i === nodes.length - 1) return null;
        const x1 = nodeX(i) + NODE_W;
        const x2 = nodeX(i + 1);
        return (
          <line
            key={`arr-${i}`}
            x1={x1}
            y1={cy}
            x2={x2 - 2}
            y2={cy}
            stroke="currentColor"
            strokeOpacity={0.6}
            strokeWidth={1.5}
            markerEnd="url(#llist-arrow)"
          />
        );
      })}

      {/* Tail: either → null, or curving back to cycle_to */}
      {!hasCycle && (
        <>
          <line
            x1={nodeX(nodes.length - 1) + NODE_W}
            y1={cy}
            x2={nodeX(nodes.length) - 2}
            y2={cy}
            stroke="currentColor"
            strokeOpacity={0.6}
            strokeWidth={1.5}
            markerEnd="url(#llist-arrow)"
          />
          <text
            x={nodeX(nodes.length) + NODE_W / 2 - ARROW}
            y={cy}
            textAnchor="middle"
            dominantBaseline="central"
            fontSize={12}
            fontStyle="italic"
            className="fill-foreground/60"
          >
            null
          </text>
        </>
      )}
      {hasCycle && (
        <CycleLoop
          fromX={nodeX(nodes.length - 1) + NODE_W / 2}
          toX={nodeX(cycle_to!) + NODE_W / 2}
          y={cy}
        />
      )}

      {/* Nodes */}
      {nodes.map((val, i) => {
        const isHl = highlightSet.has(i);
        const x = nodeX(i);
        return (
          <g key={`n-${i}`}>
            <rect
              x={x}
              y={PADDING_TOP}
              width={NODE_W}
              height={NODE_H}
              rx={6}
              ry={6}
              className={
                isHl
                  ? "fill-accent-500 stroke-accent-500"
                  : "fill-background stroke-foreground/60"
              }
              strokeWidth={isHl ? 2.5 : 1.5}
            />
            <text
              x={x + NODE_W / 2}
              y={cy}
              textAnchor="middle"
              dominantBaseline="central"
              fontSize={13}
              fontWeight={isHl ? 600 : 500}
              className={isHl ? "fill-white" : "fill-foreground"}
            >
              {String(val)}
            </text>
          </g>
        );
      })}
    </svg>
  );
}

interface CycleLoopProps {
  fromX: number;
  toX: number;
  y: number;
}

// A semicircle-ish curve below the row of nodes connecting the tail's
// bottom edge back to the cycle-target's bottom edge.
function CycleLoop({ fromX, toX, y }: CycleLoopProps) {
  const bottom = y + NODE_H / 2;
  const curveDepth = 20;
  // Use a quadratic bezier — visually a smooth arc beneath the chain.
  const cx = (fromX + toX) / 2;
  return (
    <path
      d={`M ${fromX} ${bottom} Q ${cx} ${bottom + curveDepth} ${toX} ${bottom}`}
      stroke="currentColor"
      strokeOpacity={0.7}
      strokeWidth={1.5}
      fill="none"
      markerEnd="url(#llist-arrow)"
    />
  );
}

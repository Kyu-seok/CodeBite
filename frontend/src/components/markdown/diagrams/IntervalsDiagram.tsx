import type { Interval } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface IntervalsDiagramProps {
  intervals: Interval[];
  /** Indices into intervals to emphasize. */
  highlight?: number[];
  /** When present, renders as a before→after pair on the same axis range. */
  after?: Interval[];
  /** An interval the input adds, drawn as an extra accent row. */
  added?: Interval;
  /** Values marked by a vertical line across every bar. */
  points?: number[];
}

const MIN_TICKS = 5;
const MAX_TICKS = 10;

/**
 * Labeled axis ticks between `min` and `max`: every multiple of a round step
 * (1, 2 or 5 times a power of ten). The smallest step giving 5–10 ticks wins;
 * when none does, the step whose count is nearest that range (by ratio).
 */
export function axisTicks(min: number, max: number): number[] {
  const ticksAt = (step: number) => {
    const first = Math.ceil(min / step) * step;
    const count = Math.floor((max - first) / step) + 1;
    return Array.from({ length: count }, (_, i) => first + i * step);
  };
  const miss = (count: number) =>
    count < MIN_TICKS ? MIN_TICKS / count : count > MAX_TICKS ? count / MAX_TICKS : 1;

  let best = ticksAt(1);
  // A larger step never adds ticks, so stop once the count falls below the range.
  for (let power = 1; ; power *= 10) {
    for (const m of [1, 2, 5]) {
      const ticks = ticksAt(m * power);
      if (miss(ticks.length) === 1) return ticks;
      if (miss(ticks.length) < miss(best.length)) best = ticks;
      if (ticks.length < MIN_TICKS) return best;
    }
  }
}

/**
 * Every value that is an endpoint of two or more intervals, ascending. A
 * guide line there tells touching ([1,3] and [3,8]) apart from overlapping.
 */
export function sharedEndpoints(intervals: Interval[]): number[] {
  const seen = new Map<number, number>();
  for (const [start, end] of intervals) {
    for (const v of new Set([start, end])) seen.set(v, (seen.get(v) ?? 0) + 1);
  }
  return [...seen].filter(([, n]) => n >= 2).map(([v]) => v).sort((a, b) => a - b);
}

export function IntervalsDiagram({
  intervals,
  highlight = [],
  after,
  added,
  points = [],
}: IntervalsDiagramProps) {
  // One axis range over every value in the block, so both sides of a pair line up.
  const values = [...intervals, ...(after ?? []), ...(added ? [added] : [])].flat();
  values.push(...points);
  const domain: [number, number] = [Math.min(...values), Math.max(...values)];

  const before = (
    <IntervalsSvg
      intervals={intervals}
      highlight={highlight}
      added={added}
      points={points}
      domain={domain}
    />
  );
  if (after) {
    return (
      <BeforeAfterPair
        before={before}
        after={<IntervalsSvg intervals={after} domain={domain} />}
      />
    );
  }
  return <div className="my-4">{before}</div>;
}

const LABEL_CHAR_W = 7.3; // 12px monospace
const PLOT_W = 280;
const PAD_X = 12;
const ROW_H = 24;
const BAR_H = 12;
const TOP = 18; // room for point labels
const AXIS_H = 26;
const MIN_BAR_W = 4;

type RowKind = "plain" | "highlight" | "added";

/** How each kind of row draws: its label and its bar. */
const ROW_STYLES: Record<
  RowKind,
  { prefix: string; labelWeight: number; labelClass: string; barClass: string; barDash?: string }
> = {
  plain: {
    prefix: "",
    labelWeight: 500,
    labelClass: "fill-foreground/80",
    barClass: "fill-foreground/15 stroke-foreground/60",
  },
  highlight: {
    prefix: "",
    labelWeight: 600,
    labelClass: "fill-accent-500",
    barClass: "fill-accent-500 stroke-accent-500",
  },
  added: {
    prefix: "+ ",
    labelWeight: 600,
    labelClass: "fill-accent-500",
    barClass: "fill-accent-500/20 stroke-accent-500",
    barDash: "4 2",
  },
};

interface IntervalsSvgProps {
  intervals: Interval[];
  highlight?: number[];
  added?: Interval;
  points?: number[];
  domain: [number, number];
}

function IntervalsSvg({ intervals, highlight = [], added, points = [], domain }: IntervalsSvgProps) {
  const [lo, hi] = domain;
  const span = hi - lo || 1;
  const rows: { interval: Interval; kind: RowKind }[] = intervals.map(
    (interval, i) => ({ interval, kind: highlight.includes(i) ? "highlight" : "plain" }),
  );
  if (added) rows.push({ interval: added, kind: "added" });
  const label = (kind: RowKind, [start, end]: Interval) =>
    `${ROW_STYLES[kind].prefix}[${start}, ${end}]`;

  const labelW = PAD_X + Math.max(...rows.map((r) => label(r.kind, r.interval).length)) * LABEL_CHAR_W;
  const plotX = labelW + PAD_X;
  const xOf = (v: number) => plotX + (hi === lo ? PLOT_W / 2 : ((v - lo) / span) * PLOT_W);

  const width = plotX + PLOT_W + PAD_X;
  const plotBottom = TOP + rows.length * ROW_H;
  const height = plotBottom + AXIS_H;
  const guides = sharedEndpoints(rows.map((r) => r.interval));

  return (
    <svg
      viewBox={`0 0 ${width} ${height}`}
      className="mx-auto block w-full max-w-md text-foreground"
      role="img"
      aria-label="Intervals diagram"
    >
      {/* Guide lines at endpoints two intervals share */}
      {guides.map((v) => (
        <line
          key={`g-${v}`}
          x1={xOf(v)}
          y1={TOP - 4}
          x2={xOf(v)}
          y2={plotBottom}
          className="stroke-foreground/30"
          strokeWidth={1}
        />
      ))}

      {/* Point markers */}
      {points.map((v, i) => (
        <g key={`p-${i}`}>
          <line
            x1={xOf(v)}
            y1={TOP - 4}
            x2={xOf(v)}
            y2={plotBottom}
            className="stroke-foreground/70"
            strokeWidth={1.5}
            strokeDasharray="4 3"
          />
          <text
            x={xOf(v)}
            y={TOP - 8}
            textAnchor="middle"
            fontSize={11}
            fontWeight={600}
            className="fill-foreground"
          >
            {v}
          </text>
        </g>
      ))}

      {/* One row per interval, in input order */}
      {rows.map(({ interval: [start, end], kind }, i) => {
        const cy = TOP + i * ROW_H + ROW_H / 2;
        const style = ROW_STYLES[kind];
        const barStart = xOf(start);
        const barLength = xOf(end) - barStart;
        // A point-like interval still gets a visible bar, centered on its value.
        const barW = Math.max(barLength, MIN_BAR_W);
        const barX = barLength < MIN_BAR_W ? barStart - MIN_BAR_W / 2 : barStart;
        return (
          <g key={`r-${i}`}>
            <text
              x={labelW}
              y={cy}
              textAnchor="end"
              dominantBaseline="central"
              fontSize={12}
              fontWeight={style.labelWeight}
              className={`font-mono ${style.labelClass}`}
            >
              {label(kind, [start, end])}
            </text>
            <rect
              x={barX}
              y={cy - BAR_H / 2}
              width={barW}
              height={BAR_H}
              rx={3}
              ry={3}
              className={style.barClass}
              strokeWidth={1.5}
              strokeDasharray={style.barDash}
            />
          </g>
        );
      })}

      {/* Axis */}
      <line
        x1={plotX}
        y1={plotBottom + 4}
        x2={plotX + PLOT_W}
        y2={plotBottom + 4}
        className="stroke-foreground/50"
        strokeWidth={1}
      />
      {axisTicks(lo, hi).map((v) => (
        <g key={`t-${v}`}>
          <line
            x1={xOf(v)}
            y1={plotBottom + 4}
            x2={xOf(v)}
            y2={plotBottom + 8}
            className="stroke-foreground/50"
            strokeWidth={1}
          />
          <text
            x={xOf(v)}
            y={plotBottom + 18}
            textAnchor="middle"
            fontSize={10}
            className="fill-foreground/60"
          >
            {v}
          </text>
        </g>
      ))}
    </svg>
  );
}

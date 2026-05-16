import type { Cell, CellCoord } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface GridDiagramProps {
  cells: Cell[][];
  highlight?: CellCoord[];
  /** When present, renders as a before→after pair with a transformation arrow. */
  after?: Cell[][];
}

export function GridDiagram({ cells, highlight = [], after }: GridDiagramProps) {
  if (after) {
    return (
      <BeforeAfterPair
        before={<SingleGrid cells={cells} highlight={highlight} />}
        after={<SingleGrid cells={after} />}
      />
    );
  }
  return (
    <div className="my-4">
      <SingleGrid cells={cells} highlight={highlight} />
    </div>
  );
}

interface SingleGridProps {
  cells: Cell[][];
  highlight?: CellCoord[];
}

function SingleGrid({ cells, highlight = [] }: SingleGridProps) {
  const cols = cells[0]?.length ?? 0;
  const highlightSet = new Set(highlight.map(([r, c]) => `${r}|${c}`));

  if (cols === 0) {
    return (
      <div className="flex justify-center text-xs italic text-muted-foreground">
        (empty grid)
      </div>
    );
  }

  // Cell size scales down for wider grids so a 6×6 still fits comfortably.
  const sizeClass =
    cols >= 6 ? "h-8 w-8 text-xs" : cols >= 4 ? "h-10 w-10 text-sm" : "h-12 w-12";

  return (
    <div
      className="mx-auto inline-grid gap-1"
      style={{ gridTemplateColumns: `repeat(${cols}, minmax(0, auto))` }}
    >
      {cells.map((row, r) =>
        row.map((cell, c) => {
          const isHl = highlightSet.has(`${r}|${c}`);
          return (
            <div
              key={`${r}-${c}`}
              className={
                "flex items-center justify-center rounded border font-mono " +
                sizeClass +
                " " +
                (isHl
                  ? "border-accent-500 bg-accent-500/15 text-foreground ring-2 ring-accent-500"
                  : "border-foreground/30 bg-background text-foreground")
              }
            >
              {String(cell)}
            </div>
          );
        }),
      )}
    </div>
  );
}

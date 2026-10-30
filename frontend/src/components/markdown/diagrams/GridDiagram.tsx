import type { Cell, CellCoord } from "./parseDirective";
import { BeforeAfterPair } from "./BeforeAfterPair";

interface GridDiagramProps {
  cells: Cell[][];
  highlight?: CellCoord[];
  /** When present, renders as a before→after pair with a transformation arrow. */
  after?: Cell[][];
  /** Sub-box size: a thicker border every `boxes` rows and columns. */
  boxes?: number;
  /** Cell value drawn as an empty square. */
  blank?: Cell;
}

export function GridDiagram({ cells, highlight = [], after, boxes, blank }: GridDiagramProps) {
  if (after) {
    return (
      <BeforeAfterPair
        before={<SingleGrid cells={cells} highlight={highlight} boxes={boxes} blank={blank} />}
        after={<SingleGrid cells={after} boxes={boxes} blank={blank} />}
      />
    );
  }
  return (
    <div className="my-4">
      <SingleGrid cells={cells} highlight={highlight} boxes={boxes} blank={blank} />
    </div>
  );
}

/**
 * Which inner edges of cell (r, c) close a sub-box. The grid's outer edge is
 * drawn by the container, so the last row and column never report one.
 */
export function boxEdges(
  r: number,
  c: number,
  rows: number,
  cols: number,
  boxes: number,
): { right: boolean; bottom: boolean } {
  return {
    right: (c + 1) % boxes === 0 && c + 1 < cols,
    bottom: (r + 1) % boxes === 0 && r + 1 < rows,
  };
}

interface SingleGridProps {
  cells: Cell[][];
  highlight?: CellCoord[];
  boxes?: number;
  blank?: Cell;
}

function SingleGrid({ cells, highlight = [], boxes, blank }: SingleGridProps) {
  const rows = cells.length;
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

  // With sub-boxes the cells touch, like a Sudoku board: thin lines between
  // cells, thick ones around each box and the board.
  return (
    <div
      className={
        "mx-auto inline-grid " +
        (boxes ? "border-2 border-foreground/70" : "gap-1")
      }
      style={{ gridTemplateColumns: `repeat(${cols}, minmax(0, auto))` }}
    >
      {cells.map((row, r) =>
        row.map((cell, c) => {
          const isHl = highlightSet.has(`${r}|${c}`);
          const edges = boxes ? boxEdges(r, c, rows, cols, boxes) : undefined;
          return (
            <div
              key={`${r}-${c}`}
              className={
                "flex items-center justify-center font-mono " +
                sizeClass +
                " " +
                (edges
                  ? "border-foreground/25 " +
                    (c + 1 < cols ? (edges.right ? "border-r-2 border-r-foreground/70 " : "border-r ") : "") +
                    (r + 1 < rows ? (edges.bottom ? "border-b-2 border-b-foreground/70 " : "border-b ") : "")
                  : "rounded border ") +
                (isHl
                  ? "border-accent-500 bg-accent-500/15 text-foreground ring-2 ring-accent-500" +
                    (edges ? " ring-inset" : "")
                  : (edges ? "" : "border-foreground/30 ") + "bg-background text-foreground")
              }
            >
              {cell === blank ? "" : String(cell)}
            </div>
          );
        }),
      )}
    </div>
  );
}

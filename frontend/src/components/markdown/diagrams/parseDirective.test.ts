import { describe, expect, it } from "vitest";
import { parseGridDirective } from "./parseDirective";
import { boxEdges } from "./GridDiagram";

describe("parseGridDirective", () => {
  it("leaves boxes and blank unset when the directive has neither", () => {
    const spec = parseGridDirective("cells: [[1,2],[3,4]]");
    expect(spec.boxes).toBeUndefined();
    expect(spec.blank).toBeUndefined();
  });

  it("reads a Sudoku board's sub-box size and blank value", () => {
    const spec = parseGridDirective('cells: [["5","."],[".","3"]]\nboxes: 3\nblank: "."');
    expect(spec.boxes).toBe(3);
    expect(spec.blank).toBe(".");
  });

  it.each(["boxes: 0", "boxes: 1.5", 'boxes: "3"'])("rejects %s", (line) => {
    expect(() => parseGridDirective(`cells: [[1]]\n${line}`)).toThrow(/boxes/);
  });

  it("rejects a blank that is not a single cell value", () => {
    expect(() => parseGridDirective('cells: [[1]]\nblank: ["."]')).toThrow(/blank/);
  });
});

describe("boxEdges", () => {
  it("closes a 3×3 box after every third row and column of a 9×9 board", () => {
    expect(boxEdges(0, 2, 9, 9, 3)).toEqual({ right: true, bottom: false });
    expect(boxEdges(2, 0, 9, 9, 3)).toEqual({ right: false, bottom: true });
    expect(boxEdges(5, 5, 9, 9, 3)).toEqual({ right: true, bottom: true });
    expect(boxEdges(4, 4, 9, 9, 3)).toEqual({ right: false, bottom: false });
  });

  it("reports no box edges without boxes, so a plain grid has only thin lines", () => {
    expect(boxEdges(0, 2, 9, 9)).toEqual({ right: false, bottom: false });
  });

  // The container draws the board's outer border, so the cells must not double it.
  it("never reports the board's outer edge", () => {
    expect(boxEdges(8, 8, 9, 9, 3)).toEqual({ right: false, bottom: false });
  });
});

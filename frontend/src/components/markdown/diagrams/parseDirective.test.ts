import { describe, expect, it } from "vitest";
import { parseGridDirective, parseIntervalsDirective } from "./parseDirective";
import { boxEdges } from "./GridDiagram";
import { axisTicks, sharedEndpoints } from "./IntervalsDiagram";

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

describe("parseIntervalsDirective", () => {
  it("reads intervals alone, leaving every optional key empty", () => {
    const spec = parseIntervalsDirective("intervals: [[1,4],[7,10]]");
    expect(spec).toEqual({ intervals: [[1, 4], [7, 10]], highlight: [], points: [] });
  });

  it("reads after, added, points and highlight", () => {
    const spec = parseIntervalsDirective(
      "intervals: [[1,3],[6,9]]\nadded: [2,5]\nafter: [[1,5],[6,9]]\npoints: [3,6]\nhighlight: [1]",
    );
    expect(spec.after).toEqual([[1, 5], [6, 9]]);
    expect(spec.added).toEqual([2, 5]);
    expect(spec.points).toEqual([3, 6]);
    expect(spec.highlight).toEqual([1]);
  });

  it.each([
    ["no intervals", "points: [1]", /intervals/],
    ["an empty list", "intervals: []", /intervals/],
    ["a non-pair", "intervals: [[1,2,3]]", /intervals/],
    ["a backwards interval", "intervals: [[5,1]]", /intervals/],
    ["a highlight past the end", "intervals: [[1,2]]\nhighlight: [1]", /highlight/],
    ["a malformed after", "intervals: [[1,2]]\nafter: [1,2]", /after/],
    ["an added list instead of one pair", "intervals: [[1,2]]\nadded: [[1,2]]", /added/],
    ["non-numeric points", 'intervals: [[1,2]]\npoints: ["a"]', /points/],
  ])("rejects %s", (_, body, message) => {
    expect(() => parseIntervalsDirective(body)).toThrow(message);
  });
});

describe("axisTicks", () => {
  it("labels a small range at every whole number", () => {
    expect(axisTicks(1, 10)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });

  it("steps a wider range at a round number, keeping 5–10 ticks", () => {
    expect(axisTicks(0, 100)).toEqual([0, 20, 40, 60, 80, 100]);
    expect(axisTicks(3, 21)).toEqual([4, 6, 8, 10, 12, 14, 16, 18, 20]);
    expect(axisTicks(900, 1730)).toEqual([900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700]);
    expect(axisTicks(0, 12)).toEqual([0, 2, 4, 6, 8, 10, 12]);
  });

  it("gives one tick when every value is the same", () => {
    expect(axisTicks(5, 5)).toEqual([5]);
  });
});

describe("sharedEndpoints", () => {
  it("finds an endpoint two intervals touch at", () => {
    expect(sharedEndpoints([[1, 3], [3, 8]])).toEqual([3]);
  });

  it("finds none when intervals only overlap", () => {
    expect(sharedEndpoints([[18, 20], [19, 21]])).toEqual([]);
  });

  it("counts a start shared by two intervals, listing each value once", () => {
    expect(sharedEndpoints([[1, 4], [1, 6], [4, 9], [6, 9]])).toEqual([1, 4, 6, 9]);
  });
});

import { describe, expect, it } from "vitest";
import { lineToFill, TUTORIAL_STEPS, tutorialSpotlight, type TutorialStepName } from ".";

const idle = { judging: false, signedIn: true };

describe("tutorialSpotlight", () => {
  it("spotlights the description for step 1 and moves on with Next", () => {
    expect(tutorialSpotlight("read", idle)).toEqual({
      step: "read",
      anchor: "description",
      lit: ["description"],
      copy: "read",
      action: "next",
    });
  });

  it("spotlights the editor for step 2, which the user may also move past with Next", () => {
    expect(tutorialSpotlight("function", idle)).toMatchObject({ anchor: "editor", lit: ["editor"], action: "next" });
  });

  it("points at Run for step 3 and keeps the editor usable, moving on only when a Run finishes", () => {
    expect(tutorialSpotlight("run", idle)).toMatchObject({ anchor: "run", lit: ["editor", "run"], action: null });
  });

  it("points at the failing result for step 4 and keeps the editor usable to fix it", () => {
    expect(tutorialSpotlight("readFailure", idle)).toMatchObject({
      anchor: "result",
      lit: ["result", "editor"],
      copy: "readFailure",
      action: null,
    });
  });

  it("points at Submit for step 5", () => {
    expect(tutorialSpotlight("submit", idle)).toMatchObject({ anchor: "submit", lit: ["submit", "editor", "result"], copy: "submit" });
  });

  it("says before step 5's Submit that it needs signing in, when signed out", () => {
    expect(tutorialSpotlight("submit", { judging: false, signedIn: false }).copy).toBe("submitSignIn");
  });

  it("celebrates on the result for step 6 and closes with Done", () => {
    expect(tutorialSpotlight("accepted", idle)).toEqual({
      step: "accepted",
      anchor: "result",
      lit: ["result"],
      copy: "accepted",
      action: "done",
    });
  });

  it("moves to the result while a Run or Submit is judging, so nothing points at a button that has done its job", () => {
    for (const step of ["run", "readFailure", "submit"] as const) {
      expect(tutorialSpotlight(step, { judging: true, signedIn: true })).toEqual({
        step,
        anchor: "result",
        lit: ["result"],
        copy: "judging",
        action: null,
      });
    }
  });

  it("lights its anchor on every step, judging or not", () => {
    for (const step of TUTORIAL_STEPS as readonly TutorialStepName[]) {
      for (const judging of [false, true]) {
        const spotlight = tutorialSpotlight(step, { judging, signedIn: false });
        expect(spotlight.lit).toContain(spotlight.anchor);
      }
    }
  });
});

describe("lineToFill", () => {
  it("marks the placeholder comment and the stand-in line after it", () => {
    const java = [
      "class Solution {",
      "    public int totalCoins(int firstBank, int secondBank) {",
      "        // Write your solution here",
      "        return 0;",
      "    }",
      "}",
    ].join("\n");
    expect(lineToFill(java)).toEqual({ start: 3, end: 4 });

    const python = [
      "class Solution:",
      "    def totalCoins(self, firstBank: int, secondBank: int) -> int:",
      "        # Write your solution here",
      "        pass",
    ].join("\n");
    expect(lineToFill(python)).toEqual({ start: 3, end: 4 });
  });

  it("marks the comment alone when the body closes right after it", () => {
    const js = ["class Solution {", "    totalCoins(firstBank, secondBank) {", "        // Write your solution here", "    }", "}"].join(
      "\n",
    );
    expect(lineToFill(js)).toEqual({ start: 3, end: 3 });
  });

  it("marks nothing once the placeholder is gone, so the whole editor is spotlit instead", () => {
    expect(lineToFill("class Solution:\n    def totalCoins(self, a, b):\n        return a + b")).toBeNull();
  });
});

import type { TutorialStepName } from "./tutorial";

/**
 * The parts of the workspace a Tutorial step can spotlight. `failingCase` is the first failing row of
 * a Run's result, inside `result`.
 */
export type TourTarget = "description" | "editor" | "run" | "submit" | "result" | "failingCase";

/** The text a coach mark shows: one per step, plus the signed-out Submit and the wait for a verdict. */
export type SpotlightCopy = TutorialStepName | "submitSignIn" | "judging";

/**
 * How a Tutorial step is shown (docs/adr/0008): the page is dimmed except for `lit`, blocked except
 * for `usable` (everything lit, and sometimes the panel around it), and the coach mark points at
 * `anchor`, one of `lit`. `action` is the coach mark's own button, for
 * the steps that move on without the user doing anything in the workspace; the rest move on through
 * `tutorialStep` when the user edits, Runs or Submits.
 */
export interface Spotlight {
  step: TutorialStepName;
  anchor: TourTarget;
  lit: readonly TourTarget[];
  usable: readonly TourTarget[];
  copy: SpotlightCopy;
  action: "next" | "done" | null;
}

export interface SpotlightContext {
  /** A Run or Submit is waiting for its result. */
  judging: boolean;
  signedIn: boolean;
  /** The result on screen has a failing case to point at (a settled Run that failed). */
  failingCase: boolean;
}

/**
 * The spotlight for `step`. Every step that is moved on by an action keeps the editor usable, so a
 * newcomer can keep fixing their code; while a Run or Submit is judging, the result is all there is
 * to look at.
 */
export function tutorialSpotlight(step: TutorialStepName, { judging, signedIn, failingCase }: SpotlightContext): Spotlight {
  const show = (
    anchor: TourTarget,
    lit: TourTarget[],
    copy: SpotlightCopy = step,
    action: Spotlight["action"] = null,
    usable: TourTarget[] = lit,
  ): Spotlight => ({ step, anchor, lit, usable, copy, action });
  if (judging && (step === "run" || step === "readFailure" || step === "submit")) {
    return show("result", ["result"], "judging");
  }
  switch (step) {
    case "read":
      return show("description", ["description"], "read", "next");
    case "function":
      return show("editor", ["editor"], "function", "next");
    case "run":
      return show("run", ["editor", "run"]);
    case "readFailure":
      // The failing case and the editor to fix it in; the rest of the result stays usable (scrolling
      // to other cases, switching tabs). Without a failing case on screen, the whole result.
      return failingCase
        ? show("failingCase", ["failingCase", "editor"], step, null, ["failingCase", "editor", "result"])
        : show("result", ["result", "editor"]);
    case "submit":
      return show("submit", ["submit", "editor", "result"], signedIn ? "submit" : "submitSignIn");
    case "accepted":
      return show("result", ["result"], "accepted", "done");
  }
}

/** Lines in the editor, 1-based and inclusive. */
export interface LineRange {
  start: number;
  end: number;
}

/** The placeholder every Starter Code puts where the answer goes. */
const PLACEHOLDER = /(\/\/|#)\s*Write your solution here/;
const CLOSING = /^\s*[}\]);]*\s*$/;

/**
 * The lines (1-based, inclusive) step 2 marks in the editor: the placeholder comment and the
 * stand-in line under it (`return 0;`, `pass`), or null when the placeholder is gone.
 */
export function linesToFill(code: string): LineRange | null {
  const lines = code.split("\n");
  const at = lines.findIndex((line) => PLACEHOLDER.test(line));
  if (at < 0) return null;
  const next = lines[at + 1];
  const start = at + 1;
  return { start, end: next != null && !CLOSING.test(next) ? start + 1 : start };
}

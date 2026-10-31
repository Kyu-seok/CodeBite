import type { TutorialStepName } from "./tutorial";

/**
 * The parts of the workspace a Tutorial step can spotlight. `failedRow` is the first row of a Run's
 * result whose case failed (`caseFailed`), inside `result`.
 */
export type TourTarget = "description" | "editor" | "run" | "submit" | "result" | "failedRow";

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
  /** The result on screen has a failed row to point at (a settled Run with a case that failed). */
  failedRow: boolean;
}

/**
 * The spotlight for `step`. Every step that is moved on by an action keeps the editor usable, so a
 * newcomer can keep fixing their code; while a Run or Submit is judging, the result is all there is
 * to look at.
 */
export function tutorialSpotlight(step: TutorialStepName, { judging, signedIn, failedRow }: SpotlightContext): Spotlight {
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
      // The first failed row and the editor to fix it in; the rest of the result stays usable
      // (scrolling to other cases, switching tabs). Without a failed row on screen, the whole result.
      return failedRow
        ? show("failedRow", ["failedRow", "editor"], step, null, ["failedRow", "editor", "result"])
        : show("result", ["result", "editor"]);
    case "submit":
      return show("submit", ["submit", "editor", "result"], signedIn ? "submit" : "submitSignIn");
    case "accepted":
      return show("result", ["result"], "accepted", "done");
  }
}

/** Where focus is while a step shows: the coach mark, the editor itself, anything else in `usable`, or the blocked page. */
export type TourFocus = "coachMark" | "editor" | "usable" | "elsewhere";

/**
 * A key pressed while a step shows. `phase` is when the page sees it: `before` the focused element
 * (the editor indents on Tab and prevents the default), or `after`, with `defaultPrevented` saying
 * whether something already handled it.
 */
export interface TourKeyPress {
  key: string;
  focus: TourFocus;
  phase: "before" | "after";
  defaultPrevented: boolean;
  /** The last key in the editor was Escape (see `afterEditorEscape`). */
  afterEditorEscape: boolean;
}

/**
 * What a key does during the Tutorial (docs/adr/0008): Tab and Shift+Tab cycle among the coach mark
 * and the usable elements, and Escape returns to the coach mark. The editor keeps its own Escape
 * (closing suggestions, Vim) and Tab (indenting); a keyboard user leaves it with Escape then Tab or
 * Shift+Tab, or by the editor's Tab-focus mode, which lets Tab through.
 */
export function tourKeyMove(press: TourKeyPress): "toCoachMark" | "cycle" | null {
  const { key, focus, phase, defaultPrevented } = press;
  if (phase === "before") return key === "Tab" && focus === "editor" && press.afterEditorEscape ? "cycle" : null;
  if (defaultPrevented) return null;
  if (key === "Escape") return focus === "editor" ? null : "toCoachMark";
  if (key === "Tab") return "cycle";
  return null;
}

const MODIFIERS = new Set(["Shift", "Control", "Alt", "Meta"]);

/** Whether the next Tab leaves the editor: set by Escape there, kept through modifier keys, cleared by anything else. */
export function afterEditorEscape(was: boolean, key: string, focus: TourFocus): boolean {
  if (key === "Escape") return focus === "editor";
  return was && MODIFIERS.has(key);
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

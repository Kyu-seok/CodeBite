import type { RunResponse, SubmissionResponse, SubmissionStatus } from "@/types/submission";

/** Every Tip (GLOSSARY.md): a short explanation shown the first time something happens, until dismissed. */
export const TIPS = [
  "wrongAnswer",
  "returnedNothing",
  "compileError",
  "runtimeError",
  "timeLimitExceeded",
  "firstAccepted",
] as const;

export type Tip = (typeof TIPS)[number];

export type JudgedResult = { mode: "run"; result: RunResponse } | { mode: "submit"; result: SubmissionResponse };

/** What a function that returned nothing prints once the Driver writes its result out. */
const NOTHING = new Set(["", "None", "null", "undefined"]);

function isNothing(output: string | null): boolean {
  return output == null || NOTHING.has(output.trim());
}

function statusOf(judged: JudgedResult): SubmissionStatus {
  return judged.mode === "run" ? judged.result.overallStatus : judged.result.status;
}

/** The outputs of the Wrong Answer cases the result shows: a Run's judged ones, a Submit's Failing Case. */
function wrongOutputs(judged: JudgedResult): (string | null)[] {
  if (judged.mode === "submit") {
    const failing = judged.result.failingCase;
    return failing?.status === "WRONG_ANSWER" ? [failing.actualOutput] : [];
  }
  return judged.result.results
    .filter((r) => r.judged && r.status === "WRONG_ANSWER")
    .map((r) => r.actualOutput);
}

/** The Tip that explains this result, seen or not. */
function explaining(result: JudgedResult): Tip | null {
  switch (statusOf(result)) {
    case "WRONG_ANSWER":
      return wrongOutputs(result).some(isNothing) ? "returnedNothing" : "wrongAnswer";
    case "COMPILATION_ERROR":
      return "compileError";
    case "RUNTIME_ERROR":
      return "runtimeError";
    case "TIME_LIMIT_EXCEEDED":
      return "timeLimitExceeded";
    case "ACCEPTED":
      // A passing Run saves nothing; the first Accepted Tip points at the Streak and the Review.
      return result.mode === "submit" ? "firstAccepted" : null;
    default:
      // Pending has nothing to explain yet; an Internal Error is CodeBite's fault, not the code's.
      return null;
  }
}

/**
 * The one Tip to show next to a Run or Submit result, or null when it has been seen. "Returned
 * nothing" wins over the plain Wrong Answer Tip, and once seen it is not replaced by it: dismissing
 * a Tip never swaps another in on the same result.
 */
export function tipFor(result: JudgedResult, seenTips: ReadonlySet<Tip>): Tip | null {
  const tip = explaining(result);
  return tip && !seenTips.has(tip) ? tip : null;
}

import { describe, expect, it } from "vitest";
import type { FailingCase, RunResponse, RunTestCaseResult, SubmissionResponse, SubmissionStatus } from "@/types/submission";
import { tipFor, type JudgedResult, type Tip } from ".";

const NONE_SEEN: ReadonlySet<Tip> = new Set();

function failingCase(status: SubmissionStatus, actualOutput: string | null): FailingCase {
  return { testCaseId: 1, position: 1, total: 3, hidden: false, status, input: "1 2", expectedOutput: "3", actualOutput, errors: [] };
}

function submitted(status: SubmissionStatus, failing: FailingCase | null = null): JudgedResult {
  const result = {
    id: 1,
    problemSlug: "piggy-bank-total",
    language: "python",
    status,
    runtimeMs: null,
    memoryKb: null,
    sourceCode: "",
    results: [],
    createdAt: "2026-10-31T00:00:00Z",
    notes: null,
    confidence: null,
    solveTimeSeconds: null,
    solutionCommit: null,
    failingCase: failing,
  } satisfies SubmissionResponse;
  return { mode: "submit", result };
}

function runCase(status: SubmissionStatus, actualOutput: string | null, extra: Partial<RunTestCaseResult> = {}): RunTestCaseResult {
  return { input: "1 2", expectedOutput: "3", actualOutput, status, stderr: null, compileOutput: null, errors: [], isCustom: false, judged: true, ...extra };
}

function ran(overallStatus: SubmissionStatus, results: RunTestCaseResult[] = []): JudgedResult {
  const result = { overallStatus, results } satisfies RunResponse;
  return { mode: "run", result };
}

describe("tipFor", () => {
  it("explains a first Wrong Answer", () => {
    expect(tipFor(submitted("WRONG_ANSWER", failingCase("WRONG_ANSWER", "4")), NONE_SEEN)).toBe("wrongAnswer");
  });

  it.each([null, "", "  \n", "None", "null", "undefined", "None\n"])(
    "says the function returned nothing when the failing case's output is %j",
    (output) => {
      expect(tipFor(submitted("WRONG_ANSWER", failingCase("WRONG_ANSWER", output)), NONE_SEEN)).toBe("returnedNothing");
    },
  );

  it("explains a Run's Wrong Answer", () => {
    const result = ran("WRONG_ANSWER", [runCase("ACCEPTED", "3"), runCase("WRONG_ANSWER", "4")]);
    expect(tipFor(result, NONE_SEEN)).toBe("wrongAnswer");
  });

  it("says the function returned nothing when any failing case of a Run printed None", () => {
    const result = ran("WRONG_ANSWER", [runCase("WRONG_ANSWER", "4"), runCase("WRONG_ANSWER", "None")]);
    expect(tipFor(result, NONE_SEEN)).toBe("returnedNothing");
  });

  it("ignores an unjudged custom case's empty output", () => {
    const result = ran("WRONG_ANSWER", [
      runCase("WRONG_ANSWER", "4"),
      runCase("ACCEPTED", null, { isCustom: true, judged: false, expectedOutput: null }),
    ]);
    expect(tipFor(result, NONE_SEEN)).toBe("wrongAnswer");
  });

  it.each([
    ["COMPILATION_ERROR", "compileError"],
    ["RUNTIME_ERROR", "runtimeError"],
    ["TIME_LIMIT_EXCEEDED", "timeLimitExceeded"],
  ] as const)("explains a %s on a Run and on a Submit", (status, tip) => {
    expect(tipFor(ran(status, [runCase(status, null)]), NONE_SEEN)).toBe(tip);
    expect(tipFor(submitted(status, failingCase(status, null)), NONE_SEEN)).toBe(tip);
  });

  it("celebrates a first Accepted submission", () => {
    expect(tipFor(submitted("ACCEPTED"), NONE_SEEN)).toBe("firstAccepted");
  });

  it("gives a passing Run no Tip, since nothing was saved", () => {
    expect(tipFor(ran("ACCEPTED", [runCase("ACCEPTED", "3")]), NONE_SEEN)).toBeNull();
  });

  it("never blames the code for an Internal Error", () => {
    expect(tipFor(ran("INTERNAL_ERROR"), NONE_SEEN)).toBeNull();
    expect(tipFor(submitted("INTERNAL_ERROR"), NONE_SEEN)).toBeNull();
  });

  it("gives a pending submission no Tip", () => {
    expect(tipFor(submitted("PENDING"), NONE_SEEN)).toBeNull();
  });

  it("never brings back a Tip already seen", () => {
    expect(tipFor(submitted("ACCEPTED"), new Set<Tip>(["firstAccepted"]))).toBeNull();
    expect(tipFor(ran("RUNTIME_ERROR"), new Set<Tip>(["runtimeError"]))).toBeNull();
    expect(tipFor(ran("WRONG_ANSWER", [runCase("WRONG_ANSWER", "4")]), new Set<Tip>(["wrongAnswer"]))).toBeNull();
  });

  it("gives a function that returned nothing no other Tip once that one is seen", () => {
    // Dismissing it must not swap in the Wrong Answer Tip on the same result.
    const result = submitted("WRONG_ANSWER", failingCase("WRONG_ANSWER", "None"));
    expect(tipFor(result, new Set<Tip>(["returnedNothing"]))).toBeNull();
  });
});

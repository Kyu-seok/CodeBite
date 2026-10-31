import { describe, expect, it } from "vitest";
import type { FailingCase, SubmissionResponse, SubmissionResult } from "@/types/submission";
import { submissionOutcome } from "./submissionOutcome";

function result(status: SubmissionResult["status"], overrides: Partial<SubmissionResult> = {}): SubmissionResult {
  return {
    testCaseId: 1,
    status,
    input: "",
    expectedOutput: "",
    actualOutput: null,
    runtimeMs: null,
    memoryKb: null,
    errors: [],
    ...overrides,
  };
}

function submission(overrides: Partial<SubmissionResponse>): SubmissionResponse {
  return {
    id: 1,
    problemSlug: "two-sum",
    language: "python",
    status: "PENDING",
    runtimeMs: null,
    memoryKb: null,
    sourceCode: "",
    results: [],
    createdAt: "2026-10-31T00:00:00Z",
    notes: null,
    confidence: null,
    solveTimeSeconds: null,
    solutionCommit: null,
    failingCase: null,
    ...overrides,
  };
}

describe("submissionOutcome", () => {
  it("shows only the summary for an Accepted submission, however many cases it passed", () => {
    const accepted = submission({
      status: "ACCEPTED",
      results: [result("ACCEPTED"), result("ACCEPTED"), result("ACCEPTED")],
    });
    expect(submissionOutcome(accepted)).toEqual({ kind: "summary" });
  });

  it("shows the Failing Case the server named for a Wrong Answer", () => {
    const failingCase: FailingCase = {
      testCaseId: 7,
      position: 2,
      total: 3,
      hidden: true,
      status: "WRONG_ANSWER",
      input: "[1,2]",
      expectedOutput: "3",
      actualOutput: "4",
      errors: [],
    };
    const wrong = submission({
      status: "WRONG_ANSWER",
      results: [result("ACCEPTED"), result("WRONG_ANSWER"), result("ACCEPTED")],
      failingCase,
    });
    expect(submissionOutcome(wrong)).toEqual({ kind: "failingCase", failingCase });
  });

  it("shows the compiler's errors for a Compilation Error, once, not per case", () => {
    const error = {
      line: 3, column: 5, endLine: null, endColumn: null,
      message: "expected ';'", severity: "ERROR" as const, inUserCode: true,
    };
    const ce = submission({
      status: "COMPILATION_ERROR",
      results: [result("COMPILATION_ERROR", { errors: [error] }), result("COMPILATION_ERROR", { errors: [error] })],
    });
    expect(submissionOutcome(ce)).toEqual({ kind: "compileErrors", errors: [error] });
  });

  it("blames CodeBite, not the code, for an Internal Error", () => {
    const internal = submission({
      status: "INTERNAL_ERROR",
      results: [result("ACCEPTED"), result("INTERNAL_ERROR")],
    });
    expect(submissionOutcome(internal)).toEqual({ kind: "internalError" });
  });

  it("is still pending while the submission is being judged", () => {
    expect(submissionOutcome(submission({ status: "PENDING" }))).toEqual({ kind: "pending" });
  });
});

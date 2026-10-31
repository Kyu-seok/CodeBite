import type { Confidence } from "./review";

export type SubmissionStatus =
  | "PENDING"
  | "ACCEPTED"
  | "WRONG_ANSWER"
  | "TIME_LIMIT_EXCEEDED"
  | "RUNTIME_ERROR"
  | "COMPILATION_ERROR"
  | "INTERNAL_ERROR";

export type ErrorSeverity = "ERROR" | "WARNING";

export interface CodeError {
  line: number | null;
  column: number | null;
  endLine: number | null;
  endColumn: number | null;
  message: string;
  severity: ErrorSeverity;
  inUserCode: boolean;
}

export interface SubmissionResult {
  testCaseId: number;
  status: SubmissionStatus;
  input: string;
  expectedOutput: string;
  actualOutput: string | null;
  runtimeMs: number | null;
  memoryKb: number | null;
  errors: CodeError[];
}

export interface SubmissionResponse {
  id: number;
  problemSlug: string;
  language: string;
  status: SubmissionStatus;
  runtimeMs: number | null;
  memoryKb: number | null;
  sourceCode: string;
  results: SubmissionResult[];
  createdAt: string;
  notes: string | null;
  confidence: Confidence | null;
  solveTimeSeconds: number | null;
  /** Null when the submission has no Solution Commit (not Accepted, or no GitHub Link). */
  solutionCommit: SolutionCommit | null;
  /** Days until review for each rating if this submission were rated now; null while PENDING. */
  reviewIntervalDays?: Record<Confidence, number> | null;
  /**
   * The Failing Case (GLOSSARY.md): the first case, in order, that is not Accepted. Null when
   * Accepted, still pending, a Compilation Error or an Internal Error. Given even when hidden.
   */
  failingCase?: FailingCase | null;
}

/** The Failing Case of a submission; the one hidden case a submission reveals (docs/adr/0006). */
export interface FailingCase {
  testCaseId: number;
  /** 1-based, among `total` graded cases. */
  position: number;
  total: number;
  hidden: boolean;
  status: SubmissionStatus;
  input: string;
  expectedOutput: string;
  /** Null when the program printed nothing (or crashed / timed out before it did). */
  actualOutput: string | null;
  errors: CodeError[];
}

export type SolutionCommitStatus = "PENDING" | "COMMITTED" | "FAILED";

/** Whether an Accepted submission reached the user's Solution Repository on GitHub. */
export interface SolutionCommit {
  status: SolutionCommitStatus;
  /** Set only when COMMITTED. */
  commitUrl: string | null;
}

export interface SubmissionListItem {
  id: number;
  status: SubmissionStatus;
  language: string;
  runtimeMs: number | null;
  memoryKb: number | null;
  createdAt: string;
  notes: string | null;
  confidence: Confidence | null;
  solveTimeSeconds: number | null;
}

export interface SubmitRequest {
  language: string;
  sourceCode: string;
}

export interface CustomTestCaseInput {
  input: string;
  expectedOutput: string;
}

export interface RunRequest {
  language: string;
  sourceCode: string;
  customTestCases?: CustomTestCaseInput[];
}

export interface RunTestCaseResult {
  input: string;
  expectedOutput: string | null;
  actualOutput: string | null;
  status: SubmissionStatus;
  stderr: string | null;
  compileOutput: string | null;
  errors: CodeError[];
  isCustom: boolean;
  judged: boolean;
}

export interface RunResponse {
  overallStatus: SubmissionStatus;
  results: RunTestCaseResult[];
}

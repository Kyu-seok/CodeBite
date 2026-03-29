export type SubmissionStatus =
  | "PENDING"
  | "ACCEPTED"
  | "WRONG_ANSWER"
  | "TIME_LIMIT_EXCEEDED"
  | "RUNTIME_ERROR"
  | "COMPILATION_ERROR"
  | "INTERNAL_ERROR";

export interface SubmissionResult {
  testCaseId: number;
  status: SubmissionStatus;
  input: string;
  expectedOutput: string;
  actualOutput: string | null;
  runtimeMs: number | null;
  memoryKb: number | null;
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
}

export interface SubmissionListItem {
  id: number;
  status: SubmissionStatus;
  language: string;
  runtimeMs: number | null;
  memoryKb: number | null;
  createdAt: string;
  notes: string | null;
}

export interface SubmitRequest {
  language: string;
  sourceCode: string;
}

export interface RunTestCaseResult {
  input: string;
  expectedOutput: string;
  actualOutput: string | null;
  status: SubmissionStatus;
  stderr: string | null;
  compileOutput: string | null;
}

export interface RunResponse {
  overallStatus: SubmissionStatus;
  results: RunTestCaseResult[];
}

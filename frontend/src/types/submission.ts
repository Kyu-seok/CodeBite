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

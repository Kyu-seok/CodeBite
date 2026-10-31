import type { CodeError, FailingCase, SubmissionResponse } from '@/types/submission';

/**
 * What a submission's result shows below its status line: nothing yet while pending, nothing
 * more when Accepted, its Failing Case, the compiler's errors, or an apology for a failure on
 * CodeBite's side.
 */
export type SubmissionOutcome =
  | { kind: 'pending' }
  | { kind: 'summary' }
  | { kind: 'failingCase'; failingCase: FailingCase }
  | { kind: 'compileErrors'; errors: CodeError[] }
  | { kind: 'internalError' };

export function submissionOutcome(submission: SubmissionResponse): SubmissionOutcome {
  switch (submission.status) {
    case 'PENDING':
      return { kind: 'pending' };
    case 'COMPILATION_ERROR':
      // A compile error is the same on every case, so the first result's errors are the compiler's.
      return { kind: 'compileErrors', errors: submission.results[0]?.errors ?? [] };
    case 'INTERNAL_ERROR':
      return { kind: 'internalError' };
    default:
      // The server names the Failing Case (docs/adr/0006); the client never works it out.
      return submission.failingCase
        ? { kind: 'failingCase', failingCase: submission.failingCase }
        : { kind: 'summary' };
  }
}

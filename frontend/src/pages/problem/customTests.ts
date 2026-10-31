import type { CustomTestCaseInput } from '@/types/submission';

/** As many custom test cases as the Test panel holds. */
export const MAX_CUSTOM_TESTS = 5;

export type AddCustomTestOutcome = 'added' | 'duplicate' | 'full';

/**
 * Adds a case to the custom test cases unless one with the same input is already there or the
 * list is full. Only inputs are compared, trimmed: the same input expects the same output.
 */
export function addCustomTest(
  current: CustomTestCaseInput[],
  next: CustomTestCaseInput,
  max = MAX_CUSTOM_TESTS,
): { tests: CustomTestCaseInput[]; outcome: AddCustomTestOutcome } {
  if (current.some((tc) => tc.input.trim() === next.input.trim())) {
    return { tests: current, outcome: 'duplicate' };
  }
  if (current.length >= max) return { tests: current, outcome: 'full' };
  return { tests: [...current, next], outcome: 'added' };
}

import type { CustomTestCaseInput } from '@/types/submission';

/** As many custom test cases as the Test panel holds. */
export const MAX_CUSTOM_TESTS = 5;

export type AddCustomTestOutcome = 'added' | 'duplicate' | 'full';

/**
 * Adds a case to the custom test cases unless one with the same input is already there or the
 * list is full. Inputs and outputs are compared trimmed, the way the judge compares them.
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

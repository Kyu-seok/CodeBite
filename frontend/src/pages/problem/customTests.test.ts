import { describe, expect, it } from 'vitest';
import { addCustomTest } from './customTests';

const tc = (input: string, expectedOutput = 'x') => ({ input, expectedOutput });

describe('addCustomTest', () => {
  it('appends a new case', () => {
    expect(addCustomTest([tc('1')], tc('2'))).toEqual({ tests: [tc('1'), tc('2')], outcome: 'added' });
  });

  it('keeps the list when the input is already there, ignoring surrounding whitespace', () => {
    const current = [tc('[1,2]\n')];
    expect(addCustomTest(current, tc('[1,2]'))).toEqual({ tests: current, outcome: 'duplicate' });
  });

  it('keeps the list when it is full', () => {
    const current = [tc('1'), tc('2')];
    expect(addCustomTest(current, tc('3'), 2)).toEqual({ tests: current, outcome: 'full' });
  });
});

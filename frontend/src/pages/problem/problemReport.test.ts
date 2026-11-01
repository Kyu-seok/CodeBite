import { describe, expect, it } from 'vitest';
import type { FailingCase } from '@/types/submission';
import {
  MAX_CASE_TEXT,
  canSendReport,
  problemReportFields,
  problemReportUrl,
  type ProblemReport,
} from './problemReport';

function failingCase(overrides: Partial<FailingCase> = {}): FailingCase {
  return {
    testCaseId: 99,
    position: 8,
    total: 11,
    hidden: true,
    status: 'WRONG_ANSWER',
    input: '[1,3,5,7,9]\n10',
    expectedOutput: '[1,5]',
    actualOutput: '[2,4]',
    errors: [],
    ...overrides,
  };
}

function report(overrides: Partial<ProblemReport> = {}): ProblemReport {
  return {
    problemSlug: 'two-menu-sum',
    language: 'Python',
    category: 'wrongTestCase',
    categoryLabel: 'Test case is wrong',
    pageUrl: 'https://code-bite.com/problems/two-menu-sum',
    description: '',
    ...overrides,
  };
}

describe('problemReportFields', () => {
  it('names a hidden case by position and leaves out its input and expected output', () => {
    const fields = problemReportFields(report({ reportedCase: { submissionId: 42, failingCase: failingCase() } }));
    expect(fields.case).toBe('Case 8 of 11 (hidden)');
    expect(fields.output).toBe('[2,4]');
    expect(fields.submission).toBe('42');
    expect(Object.values(fields).join('\n')).not.toContain('[1,3,5,7,9]');
    expect(Object.values(fields).join('\n')).not.toContain('[1,5]');
  });

  it('carries a sample case whole, since the problem page shows it anyway', () => {
    const fields = problemReportFields(
      report({ reportedCase: { submissionId: 42, failingCase: failingCase({ hidden: false, position: 2 }) } }),
    );
    expect(fields.case).toBe('Case 2 of 11 (sample)\nInput:\n[1,3,5,7,9]\n10\nExpected output:\n[1,5]');
  });

  it('cuts long case text so the URL stays short enough to open', () => {
    const long = 'x'.repeat(MAX_CASE_TEXT + 50);
    const fields = problemReportFields(
      report({ reportedCase: { submissionId: 1, failingCase: failingCase({ actualOutput: long }) } }),
    );
    expect(fields.output).toBe(`${'x'.repeat(MAX_CASE_TEXT)}… (cut)`);
  });

  it('has no case fields for a report made from the editor', () => {
    const fields = problemReportFields(report({ description: '  typo in example 2 ' }));
    expect(fields).toEqual({
      problem: 'two-menu-sum',
      category: 'Test case is wrong',
      language: 'Python',
      page: 'https://code-bite.com/problems/two-menu-sum',
      description: 'typo in example 2',
    });
  });
});

describe('problemReportUrl', () => {
  it('opens the problem-bug issue form with a title naming the problem and category', () => {
    const url = new URL(problemReportUrl(report()));
    expect(url.origin + url.pathname).toBe('https://github.com/Kyu-seok/CodeBite/issues/new');
    expect(url.searchParams.get('template')).toBe('problem-bug.yml');
    expect(url.searchParams.get('title')).toBe('[Problem bug] two-menu-sum: Test case is wrong');
    expect(url.searchParams.get('problem')).toBe('two-menu-sum');
  });
});

describe('canSendReport', () => {
  it('needs a description from the editor but not from a Failing Case', () => {
    expect(canSendReport('   ')).toBe(false);
    expect(canSendReport('the example is wrong')).toBe(true);
    expect(canSendReport('', { submissionId: 1, failingCase: failingCase() })).toBe(true);
  });
});

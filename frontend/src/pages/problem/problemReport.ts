import type { FailingCase } from '@/types/submission';

/**
 * A Problem Report (GLOSSARY.md) as a prefilled GitHub issue: CodeBite receives nothing, the
 * user posts it on the public repository, through the issue form
 * `.github/ISSUE_TEMPLATE/problem-bug.yml`, which labels it for triage.
 */
export const ISSUE_FORM_URL = 'https://github.com/Kyu-seok/CodeBite/issues/new';
export const ISSUE_FORM_TEMPLATE = 'problem-bug.yml';

/** In the order the dialog lists them; `wrongTestCase` is the one a Test Case Correction answers. */
export const REPORT_CATEGORIES = ['wrongTestCase', 'descriptionUnclear', 'starterCodeIssue', 'other'] as const;
export type ReportCategory = (typeof REPORT_CATEGORIES)[number];

/** Case text longer than this is cut, so the issue URL stays short enough to open. */
export const MAX_CASE_TEXT = 1000;

/** The Failing Case a report is made from, with the submission it failed. */
export interface ReportedCase {
  submissionId: number;
  failingCase: FailingCase;
}

export interface ProblemReport {
  problemSlug: string;
  language: string;
  category: ReportCategory;
  /** The category as the issue names it: issues are triaged in English. */
  categoryLabel: string;
  pageUrl: string;
  description: string;
  reportedCase?: ReportedCase | null;
}

/**
 * The issue form's fields, by the ids `problem-bug.yml` gives them. A hidden case contributes
 * its position and the user's output only: its input and expected output would be published.
 */
export function problemReportFields(report: ProblemReport): Record<string, string> {
  const fields: Record<string, string> = {
    problem: report.problemSlug,
    category: report.categoryLabel,
    language: report.language,
    page: report.pageUrl,
    description: report.description.trim(),
  };
  const reported = report.reportedCase;
  if (reported) {
    const { position, total, hidden, input, expectedOutput, actualOutput } = reported.failingCase;
    fields.submission = String(reported.submissionId);
    const where = `Case ${position} of ${total} (${hidden ? 'hidden' : 'sample'})`;
    fields.case = hidden
      ? where
      : [where, 'Input:', cut(input), 'Expected output:', cut(expectedOutput ?? '')].join('\n');
    fields.output = cut(actualOutput ?? '');
  }
  return fields;
}

export function problemReportUrl(report: ProblemReport): string {
  const params = new URLSearchParams({
    template: ISSUE_FORM_TEMPLATE,
    title: `[Problem bug] ${report.problemSlug}: ${report.categoryLabel}`,
    ...problemReportFields(report),
  });
  return `${ISSUE_FORM_URL}?${params}`;
}

/** A report from a Failing Case says enough on its own; any other needs the user's words. */
export function canSendReport(description: string, reportedCase?: ReportedCase | null): boolean {
  return reportedCase != null || description.trim() !== '';
}

function cut(text: string): string {
  return text.length > MAX_CASE_TEXT ? `${text.slice(0, MAX_CASE_TEXT)}… (cut)` : text;
}

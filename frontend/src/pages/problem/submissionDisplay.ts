import i18n from '@/lib/i18n';
import type { SubmissionStatus } from '@/types/submission';

/**
 * Monaco language ids by CodeBite language code. Display only, like the labels: which languages
 * a problem offers is the keys of its starter code (see `problemLanguages`).
 */
export const MONACO_LANGUAGE: Record<string, string> = {
  java: 'java',
  python: 'python',
  javascript: 'javascript',
  cpp: 'cpp',
};

export const LANGUAGE_LABELS: Record<string, string> = {
  java: 'Java',
  python: 'Python',
  javascript: 'JavaScript',
  cpp: 'C++',
};

export function languageLabel(code: string) {
  return LANGUAGE_LABELS[code] ?? code;
}

/** The languages a problem offers, from its starter code's keys, in label order (unknown codes last). */
export function problemLanguages(starterCode: Record<string, string>): string[] {
  const order = Object.keys(LANGUAGE_LABELS);
  const rank = (code: string) => {
    const i = order.indexOf(code);
    return i < 0 ? order.length : i;
  };
  return Object.keys(starterCode).sort((a, b) => rank(a) - rank(b));
}

/** Text colour for a verdict: the 700 step on paper, the 400 step on night (Wash-and-Text rule). */
export const STATUS_TEXT_CLASS: Record<SubmissionStatus, string> = {
  ACCEPTED: 'text-success-700 dark:text-success-400',
  WRONG_ANSWER: 'text-error-700 dark:text-error-400',
  RUNTIME_ERROR: 'text-error-700 dark:text-error-400',
  TIME_LIMIT_EXCEEDED: 'text-warning-700 dark:text-warning-400',
  COMPILATION_ERROR: 'text-warning-700 dark:text-warning-400',
  PENDING: 'text-muted-foreground',
  INTERNAL_ERROR: 'text-muted-foreground',
};

/** Keys in the `common` namespace. */
export const STATUS_KEYS: Record<SubmissionStatus, string> = {
  ACCEPTED: 'status.accepted',
  WRONG_ANSWER: 'status.wrongAnswer',
  TIME_LIMIT_EXCEEDED: 'status.timeLimitExceeded',
  RUNTIME_ERROR: 'status.runtimeError',
  COMPILATION_ERROR: 'status.compilationError',
  PENDING: 'status.pending',
  INTERNAL_ERROR: 'status.internalError',
};

/**
 * A date in the UI language (i18n.language), e.g. "Oct 27, 2026" or "2026년 10월 27일".
 * A missing or unparseable date shows the localized "N/A" rather than "Invalid Date".
 */
export function formatDate(dateStr: string | null | undefined, locale: string, withTime = false) {
  const date = dateStr ? new Date(dateStr) : null;
  if (!date || isNaN(date.getTime())) return i18n.t('common:label.na');
  return date.toLocaleDateString(locale, {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    ...(withTime ? { hour: 'numeric', minute: '2-digit' } : {}),
  });
}

export function formatMemory(kb: number) {
  return `${(kb / 1024).toFixed(1)} MB`;
}

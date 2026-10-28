import { useEffect, useRef, useState, type ReactNode } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Editor from '@monaco-editor/react';
import { Check, CircleAlert, Copy, ExternalLink, FileInput, GitCommitHorizontal, Share2, X } from 'lucide-react';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import Spinner from '@/components/ui/Spinner';
import LoadError from '@/components/ui/LoadError';
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '@/components/ui/Tooltip';
import { getSubmission } from '@/api/submissions';
import { useAuth } from '@/context/AuthContext';
import { useTheme } from '@/context/ThemeContext';
import type { SolutionCommit, SubmissionResponse } from '@/types/submission';
import { ConfidencePrompt } from '@/components/review/ConfidencePrompt';
import { useReviewState } from '@/hooks/useReviewState';
import { useSolutionCommit } from '@/hooks/useSolutionCommit';
import { clearSubmissionReview } from '@/api/reviews';
import type { Confidence } from '@/types/review';
import { formatElapsed } from '@/components/layout/Layout';
import {
  MONACO_LANGUAGE,
  STATUS_KEYS,
  STATUS_TEXT_CLASS,
  formatMemory,
  formatDate,
  languageLabel,
} from './submissionDisplay';

interface SubmissionDetailProps {
  submissionId: number;
  onBack: () => void;
  onUpdateNote?: (id: number, notes: string) => void;
  onLoadIntoEditor?: (code: string, language: string) => void;
}

export function SubmissionDetail({
  submissionId,
  onBack,
  onUpdateNote,
  onLoadIntoEditor,
}: SubmissionDetailProps) {
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth();
  const { t, i18n } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  const { theme } = useTheme();
  const [submission, setSubmission] = useState<SubmissionResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadAttempt, setLoadAttempt] = useState(0);
  const [expandedCase, setExpandedCase] = useState<number | null>(null);
  const [editingNote, setEditingNote] = useState(false);
  const [noteDraft, setNoteDraft] = useState('');
  const [reviewBusy, setReviewBusy] = useState(false);
  const { submit: submitReview } = useReviewState(
    submission?.problemSlug,
    isAuthenticated && submission != null && submission.status !== 'PENDING',
  );

  useEffect(() => {
    setLoading(true);
    getSubmission(submissionId)
      .then((res) => setSubmission(res.data))
      .catch(() => setSubmission(null))
      .finally(() => setLoading(false));
  }, [submissionId, loadAttempt]);

  // Kept current while the Solution Commit is still reaching GitHub.
  const solutionCommit = useSolutionCommit(submission);

  if (loading) {
    return (
      <Spinner size="sm" className="py-16" />
    );
  }

  if (!submission) {
    return (
      <div className="p-6">
        <button onClick={onBack} className="mb-4 text-sm text-muted-foreground hover:text-foreground transition-colors">
          &larr; {t('submissions.backToSubmissions')}
        </button>
        <LoadError message={t('submissions.failedToLoad')} onRetry={() => setLoadAttempt((n) => n + 1)} />
      </div>
    );
  }

  const passedCount = submission.results.filter((r) => r.status === 'ACCEPTED').length;
  const totalCount = submission.results.length;
  const canReview = isAuthenticated && submission.status !== 'PENDING';

  const handleReviewSubmit = async (c: Confidence, notes: string | null) => {
    setReviewBusy(true);
    try {
      await submitReview(submission.id, c, notes);
      setSubmission((prev) =>
        prev
          ? {
              ...prev,
              confidence: c,
              notes: notes ?? prev.notes,
            }
          : prev,
      );
    } finally {
      setReviewBusy(false);
    }
  };

  const handleReviewClear = async () => {
    setReviewBusy(true);
    try {
      await clearSubmissionReview(submission.id);
      setSubmission((prev) =>
        prev ? { ...prev, confidence: null } : prev,
      );
    } finally {
      setReviewBusy(false);
    }
  };

  return (
    <div className="flex flex-col overflow-auto">
      {/* Header */}
      <div className="sticky top-0 z-10 border-b border-border bg-background px-4 py-2.5">
        <button
          onClick={onBack}
          className="flex items-center gap-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
        >
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M19 12H5" />
            <path d="m12 19-7-7 7-7" />
          </svg>
          {t('submissions.allSubmissions')}
        </button>
      </div>

      <div className="p-4 space-y-4">
        {/* Status + meta */}
        <div>
          <h2 className={`text-lg font-semibold ${STATUS_TEXT_CLASS[submission.status]}`}>
            {tc(STATUS_KEYS[submission.status])}
          </h2>
          <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
            <span>{formatDate(submission.createdAt, i18n.language, true)}</span>
            <span className="text-border" aria-hidden="true">|</span>
            <Badge variant="secondary" className="text-xs px-1.5 py-0">
              {languageLabel(submission.language)}
            </Badge>
            {totalCount > 0 && (
              <>
                <span className="text-border" aria-hidden="true">|</span>
                <span>
                  {t('submissions.testCasesPassed', { n: `${passedCount}/${totalCount}` })}
                </span>
              </>
            )}
          </div>
          {solutionCommit && (
            <SolutionCommitLine solutionCommit={solutionCommit} />
          )}
          <div className="mt-2">
            <Button
              variant="outline"
              size="sm"
              onClick={() => {
                const target = `/problems/${submission.problemSlug}/solutions/new?fromSubmission=${submission.id}`;
                if (!isAuthenticated) {
                  sessionStorage.setItem('returnUrl', target);
                  navigate('/login');
                  return;
                }
                navigate(target);
              }}>
              <Share2 className="h-3.5 w-3.5" />
              {t('solutions.shareAsSolution')}
            </Button>
          </div>
        </div>

        {/* Confidence prompt — available for any non-PENDING submission */}
        {canReview && (
          <ConfidencePrompt
            key={submission.id}
            onSubmit={handleReviewSubmit}
            onClear={handleReviewClear}
            busy={reviewBusy}
            currentRating={submission.confidence}
            defaultNotes={submission.confidence ? submission.notes : null}
            intervalDays={submission.reviewIntervalDays}
            title={t(submission.confidence ? 'submissions.updateRating' : 'submissions.markForReview')}
            subtitle={t(
              submission.confidence ? 'submissions.updateRatingHint' : 'submissions.markForReviewHint',
            )}
          />
        )}

        {/* Performance metrics */}
        {(submission.runtimeMs != null ||
          submission.memoryKb != null ||
          submission.solveTimeSeconds != null) && (
          <div className="flex gap-4">
            {submission.runtimeMs != null && (
              <div className="flex-1 rounded-lg border border-border bg-muted/30 px-3 py-2">
                <div className="text-xs text-muted-foreground">{tc('label.runtime')}</div>
                <div className="font-mono text-sm font-semibold tabular-nums text-foreground">{submission.runtimeMs} ms</div>
              </div>
            )}
            {submission.memoryKb != null && (
              <div className="flex-1 rounded-lg border border-border bg-muted/30 px-3 py-2">
                <div className="text-xs text-muted-foreground">{tc('label.memory')}</div>
                <div className="font-mono text-sm font-semibold tabular-nums text-foreground">{formatMemory(submission.memoryKb)}</div>
              </div>
            )}
            {submission.solveTimeSeconds != null && (
              <div className="flex-1 rounded-lg border border-border bg-muted/30 px-3 py-2">
                <div className="text-xs text-muted-foreground">{t('submissions.solveTime')}</div>
                <div className="font-mono text-sm font-semibold tabular-nums text-foreground">{formatElapsed(submission.solveTimeSeconds)}</div>
              </div>
            )}
          </div>
        )}

        {/* Submitted code */}
        <div>
          <div className="mb-2 flex items-center justify-between">
            <h3 className="text-xs font-medium text-muted-foreground uppercase tracking-wider">
              {t('submissions.submittedCode')}
            </h3>
            <CodeActions
              sourceCode={submission.sourceCode}
              language={submission.language}
              onLoadIntoEditor={onLoadIntoEditor}
            />
          </div>
          <div className="overflow-hidden rounded-lg border border-border">
            <Editor
              height="240px"
              language={MONACO_LANGUAGE[submission.language] || submission.language}
              value={submission.sourceCode}
              theme={theme === 'dark' ? 'vs-dark' : 'light'}
              options={{
                readOnly: true,
                minimap: { enabled: false },
                scrollBeyondLastLine: false,
                fontSize: 13,
                lineNumbers: 'on',
                folding: false,
                wordWrap: 'on',
                domReadOnly: true,
                contextmenu: false,
                overviewRulerBorder: false,
                hideCursorInOverviewRuler: true,
                renderLineHighlight: 'none',
                scrollbar: { vertical: 'auto', horizontal: 'auto' },
              }}
            />
          </div>
        </div>

        {/* Test case results */}
        {submission.results.length > 0 && (
          <div>
            <h3 className="mb-2 text-xs font-medium text-muted-foreground uppercase tracking-wider">
              {t('submissions.testCases')}
            </h3>
            <div className="space-y-1">
              {submission.results.map((r, i) => {
                const isExpanded = expandedCase === i;
                const passed = r.status === 'ACCEPTED';
                const hasSampleData = r.input != null;

                return (
                  <div key={r.testCaseId} className="rounded-lg border border-border overflow-hidden">
                    <CaseRow
                      expandable={hasSampleData}
                      expanded={isExpanded}
                      onToggle={() => setExpandedCase(isExpanded ? null : i)}
                    >
                      {/* Pass/fail icon */}
                      <span className="sr-only">{tc(STATUS_KEYS[r.status])}</span>
                      {passed ? (
                        <svg aria-hidden="true" className="h-4 w-4 shrink-0 text-success-600 dark:text-success-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                          <polyline points="20 6 9 17 4 12" />
                        </svg>
                      ) : (
                        <svg aria-hidden="true" className="h-4 w-4 shrink-0 text-destructive" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                          <line x1="18" y1="6" x2="6" y2="18" />
                          <line x1="6" y1="6" x2="18" y2="18" />
                        </svg>
                      )}
                      <span className="flex-1 text-left text-foreground">
                        {t('test.case', { n: i + 1 })}
                        {!hasSampleData && (
                          <span className="ml-1.5 text-xs text-muted-foreground">{t('submissions.hidden')}</span>
                        )}
                      </span>
                      {r.runtimeMs != null && (
                        <span className="font-mono text-xs tabular-nums text-muted-foreground">{r.runtimeMs} ms</span>
                      )}
                      {hasSampleData && (
                        <svg
                          aria-hidden="true"
                          className={`h-3.5 w-3.5 text-muted-foreground transition-transform ${isExpanded ? 'rotate-180' : ''}`}
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          strokeWidth="2"
                          strokeLinecap="round"
                          strokeLinejoin="round"
                        >
                          <polyline points="6 9 12 15 18 9" />
                        </svg>
                      )}
                    </CaseRow>

                    {isExpanded && hasSampleData && (
                      <div className="border-t border-border bg-muted/20 px-3 py-2 space-y-2 text-xs">
                        <div>
                          <div className="font-medium text-muted-foreground mb-0.5">{t('test.input')}</div>
                          <pre className="rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                            {r.input}
                          </pre>
                        </div>
                        <div>
                          <div className="font-medium text-muted-foreground mb-0.5">{t('submissions.expectedOutput')}</div>
                          <pre className="rounded bg-muted px-2 py-1 text-foreground whitespace-pre-wrap break-all">
                            {r.expectedOutput}
                          </pre>
                        </div>
                        {r.actualOutput != null && (
                          <div>
                            <div className="font-medium text-muted-foreground mb-0.5">{t('submissions.yourOutput')}</div>
                            <pre className={`rounded px-2 py-1 whitespace-pre-wrap break-all ${passed ? 'bg-success-100 text-success-700 dark:bg-success-950 dark:text-success-400' : 'bg-error-100 text-error-700 dark:bg-error-950 dark:text-error-400'}`}>
                              {r.actualOutput}
                            </pre>
                          </div>
                        )}
                      </div>
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        )}

        {/* Notes */}
        <div>
          <h3 className="mb-2 text-xs font-medium text-muted-foreground uppercase tracking-wider">
            {t('submissions.notes')}
          </h3>
          {editingNote ? (
            <div>
              <textarea
                aria-label={t('submissions.notes')}
                value={noteDraft}
                onChange={(e) => setNoteDraft(e.target.value)}
                maxLength={500}
                rows={3}
                placeholder={t('submissions.notesPlaceholder')}
                className="w-full resize-none rounded-lg border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <div className="mt-2 flex justify-end gap-2">
                <button
                  onClick={() => setEditingNote(false)}
                  className="rounded-md px-3 py-1 text-xs text-muted-foreground hover:text-foreground transition-colors"
                >
                  {tc('button.cancel')}
                </button>
                <button
                  onClick={() => {
                    onUpdateNote?.(submissionId, noteDraft);
                    setSubmission((prev) => prev ? { ...prev, notes: noteDraft } : prev);
                    setEditingNote(false);
                  }}
                  className="rounded-md bg-primary-800 px-3 py-1 text-xs font-medium text-primary-50 hover:bg-primary-700 dark:bg-primary-50 dark:text-primary-800 dark:hover:bg-primary-200 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                >
                  {tc('button.save')}
                </button>
              </div>
            </div>
          ) : (
            <button
              onClick={() => {
                setNoteDraft(submission.notes || '');
                setEditingNote(true);
              }}
              className="w-full rounded-lg border border-dashed border-border px-3 py-2 text-left text-sm text-muted-foreground hover:border-muted-foreground hover:text-foreground transition-colors"
            >
              {submission.notes || t('submissions.clickToAddNote')}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

/** Whether this submission reached the user's Solution Repository on GitHub. */
function SolutionCommitLine({ solutionCommit }: { solutionCommit: SolutionCommit }) {
  const { t } = useTranslation('problem');
  const { status, commitUrl } = solutionCommit;
  return (
    <div className="mt-1.5 flex flex-wrap items-center gap-1.5 text-xs" aria-live="polite">
      {status === 'PENDING' && (
        <>
          <Spinner size="xs" announce={false} className="p-0" />
          <span className="text-muted-foreground">{t('submissions.solutionCommit.pending')}</span>
        </>
      )}
      {status === 'COMMITTED' && (
        <>
          <GitCommitHorizontal className="h-3.5 w-3.5 text-success-600 dark:text-success-400" />
          <span className="text-muted-foreground">{t('submissions.solutionCommit.committed')}</span>
          {commitUrl && (
            <a
              href={commitUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-0.5 text-accent-700 hover:underline dark:text-accent-400">
              {t('submissions.solutionCommit.viewCommit')}
              <ExternalLink className="h-3 w-3" />
            </a>
          )}
        </>
      )}
      {status === 'FAILED' && (
        <>
          <CircleAlert className="h-3.5 w-3.5 text-destructive" />
          <span className="text-destructive">{t('submissions.solutionCommit.failed')}</span>
        </>
      )}
    </div>
  );
}

/** A test-case header: a disclosure button when its sample data can be shown, plain text otherwise. */
function CaseRow({
  expandable,
  expanded,
  onToggle,
  children,
}: {
  expandable: boolean;
  expanded: boolean;
  onToggle: () => void;
  children: ReactNode;
}) {
  const className = 'flex w-full items-center gap-2 px-3 py-2 text-sm';
  if (!expandable) return <div className={className}>{children}</div>;
  return (
    <button
      type="button"
      aria-expanded={expanded}
      onClick={onToggle}
      className={`${className} hover:bg-muted/50 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-ring`}
    >
      {children}
    </button>
  );
}

interface CodeActionsProps {
  sourceCode: string;
  language: string;
  onLoadIntoEditor?: (code: string, language: string) => void;
}

type ActionState = 'idle' | 'success' | 'error';

function CodeActions({ sourceCode, language, onLoadIntoEditor }: CodeActionsProps) {
  const { t } = useTranslation('problem');
  const [copyState, setCopyState] = useState<ActionState>('idle');
  const [loadState, setLoadState] = useState<ActionState>('idle');
  const copyTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const loadTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (copyTimerRef.current) clearTimeout(copyTimerRef.current);
      if (loadTimerRef.current) clearTimeout(loadTimerRef.current);
    };
  }, []);

  const flashCopy = (state: ActionState) => {
    setCopyState(state);
    if (copyTimerRef.current) clearTimeout(copyTimerRef.current);
    copyTimerRef.current = setTimeout(() => setCopyState('idle'), 1500);
  };

  const flashLoad = () => {
    setLoadState('success');
    if (loadTimerRef.current) clearTimeout(loadTimerRef.current);
    loadTimerRef.current = setTimeout(() => setLoadState('idle'), 1500);
  };

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(sourceCode);
      flashCopy('success');
    } catch {
      flashCopy('error');
    }
  };

  const handleLoad = () => {
    onLoadIntoEditor?.(sourceCode, language);
    flashLoad();
  };

  const copyTooltip =
    copyState === 'success'
      ? t('submissions.copied')
      : copyState === 'error'
        ? t('submissions.copyFailed')
        : t('submissions.copyToClipboard');

  const loadTooltip =
    loadState === 'success'
      ? t('submissions.loadedIntoEditor')
      : t('submissions.copyToEditor');

  return (
    <div className="flex items-center gap-1">
      <Tooltip>
        <TooltipTrigger>
          <Button
            variant="ghost"
            size="icon"
            className="h-7 w-7"
            onClick={handleCopy}
            aria-label={copyTooltip}>
            {copyState === 'success' ? (
              <Check className="h-3.5 w-3.5 text-success-600 dark:text-success-400" />
            ) : copyState === 'error' ? (
              <X className="h-3.5 w-3.5 text-destructive" />
            ) : (
              <Copy className="h-3.5 w-3.5" />
            )}
          </Button>
        </TooltipTrigger>
        <TooltipContent>{copyTooltip}</TooltipContent>
      </Tooltip>
      {onLoadIntoEditor && (
        <Tooltip>
          <TooltipTrigger>
            <Button
              variant="ghost"
              size="icon"
              className="h-7 w-7"
              onClick={handleLoad}
              aria-label={loadTooltip}>
              {loadState === 'success' ? (
                <Check className="h-3.5 w-3.5 text-success-600 dark:text-success-400" />
              ) : (
                <FileInput className="h-3.5 w-3.5" />
              )}
            </Button>
          </TooltipTrigger>
          <TooltipContent>{loadTooltip}</TooltipContent>
        </Tooltip>
      )}
    </div>
  );
}

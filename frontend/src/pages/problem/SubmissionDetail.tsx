import { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import Editor from '@monaco-editor/react';
import { Check, Copy, FileInput, Share2, X } from 'lucide-react';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '@/components/ui/Tooltip';
import { getSubmission } from '@/api/submissions';
import { useAuth } from '@/context/AuthContext';
import { useTheme } from '@/context/ThemeContext';
import type { SubmissionResponse, SubmissionStatus } from '@/types/submission';

const LANGUAGE_MAP: Record<string, string> = {
  java: 'java',
  python: 'python',
  javascript: 'javascript',
  cpp: 'cpp',
  c: 'c',
};

const statusColorMap: Record<SubmissionStatus, string> = {
  ACCEPTED: 'text-success-500',
  WRONG_ANSWER: 'text-destructive',
  RUNTIME_ERROR: 'text-destructive',
  TIME_LIMIT_EXCEEDED: 'text-warning-500',
  COMPILATION_ERROR: 'text-warning-500',
  PENDING: 'text-muted-foreground',
  INTERNAL_ERROR: 'text-muted-foreground',
};

const statusKeys: Record<SubmissionStatus, string> = {
  ACCEPTED: 'status.accepted',
  WRONG_ANSWER: 'status.wrongAnswer',
  TIME_LIMIT_EXCEEDED: 'status.timeLimitExceeded',
  RUNTIME_ERROR: 'status.runtimeError',
  COMPILATION_ERROR: 'status.compilationError',
  PENDING: 'status.pending',
  INTERNAL_ERROR: 'status.internalError',
};

function formatDate(dateStr: string) {
  return new Date(dateStr).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
  });
}

function formatMemory(kb: number) {
  return `${(kb / 1024).toFixed(1)} MB`;
}

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
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  const { theme } = useTheme();
  const [submission, setSubmission] = useState<SubmissionResponse | null>(null);
  const [loading, setLoading] = useState(true);
  const [expandedCase, setExpandedCase] = useState<number | null>(null);
  const [editingNote, setEditingNote] = useState(false);
  const [noteDraft, setNoteDraft] = useState('');

  useEffect(() => {
    setLoading(true);
    getSubmission(submissionId)
      .then((res) => setSubmission(res.data))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [submissionId]);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-16">
        <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
      </div>
    );
  }

  if (!submission) {
    return (
      <div className="p-6">
        <button onClick={onBack} className="mb-4 text-sm text-muted-foreground hover:text-foreground transition-colors">
          &larr; {t('submissions.backToSubmissions')}
        </button>
        <p className="text-sm text-muted-foreground">{t('submissions.failedToLoad')}</p>
      </div>
    );
  }

  const passedCount = submission.results.filter((r) => r.status === 'ACCEPTED').length;
  const totalCount = submission.results.length;

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
          <div className={`text-lg font-semibold ${statusColorMap[submission.status]}`}>
            {tc(statusKeys[submission.status])}
          </div>
          <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
            <span>{formatDate(submission.createdAt)}</span>
            <span className="text-border">|</span>
            <Badge variant="secondary" className="text-[10px] px-1.5 py-0 capitalize">
              {submission.language}
            </Badge>
            {totalCount > 0 && (
              <>
                <span className="text-border">|</span>
                <span>
                  {t('submissions.testCasesPassed', { n: `${passedCount}/${totalCount}` })}
                </span>
              </>
            )}
          </div>
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

        {/* Performance metrics */}
        {(submission.runtimeMs != null || submission.memoryKb != null) && (
          <div className="flex gap-4">
            {submission.runtimeMs != null && (
              <div className="flex-1 rounded-lg border border-border bg-muted/30 px-3 py-2">
                <div className="text-[10px] text-muted-foreground uppercase tracking-wider">{tc('label.runtime')}</div>
                <div className="text-sm font-semibold text-foreground">{submission.runtimeMs} ms</div>
              </div>
            )}
            {submission.memoryKb != null && (
              <div className="flex-1 rounded-lg border border-border bg-muted/30 px-3 py-2">
                <div className="text-[10px] text-muted-foreground uppercase tracking-wider">{tc('label.memory')}</div>
                <div className="text-sm font-semibold text-foreground">{formatMemory(submission.memoryKb)}</div>
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
              language={LANGUAGE_MAP[submission.language] || submission.language}
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
                    <button
                      onClick={() => setExpandedCase(isExpanded ? null : i)}
                      className="flex w-full items-center gap-2 px-3 py-2 text-sm hover:bg-muted/50 transition-colors"
                    >
                      {/* Pass/fail icon */}
                      {passed ? (
                        <svg className="h-4 w-4 shrink-0 text-success-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                          <polyline points="20 6 9 17 4 12" />
                        </svg>
                      ) : (
                        <svg className="h-4 w-4 shrink-0 text-destructive" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
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
                        <span className="text-xs text-muted-foreground">{r.runtimeMs} ms</span>
                      )}
                      {hasSampleData && (
                        <svg
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
                    </button>

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
                            <pre className={`rounded px-2 py-1 whitespace-pre-wrap break-all ${passed ? 'bg-success-500/10 text-success-500' : 'bg-destructive/10 text-destructive'}`}>
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
                  className="rounded-md bg-accent px-3 py-1 text-xs font-medium text-white hover:bg-accent/90 transition-colors"
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
              <Check className="h-3.5 w-3.5 text-success-500" />
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
                <Check className="h-3.5 w-3.5 text-success-500" />
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

import { useEffect, useRef, useState, type ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { Button } from '@/components/ui/Button';
import { Badge } from '@/components/ui/Badge';
import { Stack } from '@/components/layout/Stack';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';
import {
  Tooltip,
  TooltipTrigger,
  TooltipContent,
} from '@/components/ui/Tooltip';
import { PanelBottomClose, PanelBottomOpen, Maximize2, Minimize2 } from 'lucide-react';
import { cn } from '@/lib/utils';
import type { TestCase } from '@/types/problem';
import type {
  CodeError,
  CustomTestCaseInput,
  RunTestCaseResult,
  SubmissionStatus,
} from '@/types/submission';
import type { AttemptFailure, JudgeAttempt, JudgeMode } from '@/judge/attempt';
import { CustomTestsEditor } from './CustomTestsEditor';
import { STATUS_KEYS } from './submissionDisplay';
import { MAX_CUSTOM_TESTS, type AddCustomTestOutcome } from './customTests';
import { FailingCasePosition, SubmissionOutcomeDetails } from './SubmissionOutcomeDetails';
import { estimatedJudgeSeconds } from './judgeTimeEstimates';
import { TipCard } from './TipCard';
import type { Tip } from '@/onboarding';

type JudgingAttempt = Extract<JudgeAttempt, { kind: 'judging' }>;
type FailedAttempt = Extract<JudgeAttempt, { kind: 'failed' }>;

function hasTemplateError(errs?: CodeError[] | null): boolean {
  return !!errs?.some((e) => !e.inUserCode);
}

function collectTemplateError(attempt: JudgeAttempt): boolean {
  return attempt.kind === 'settled' && attempt.result.results.some((r) => hasTemplateError(r.errors));
}

// Every failure reason has its message; the Records keep it so when a reason is added.
const REJECTED_KEYS: Record<JudgeMode, string> = {
  run: 'workspace.runFailed',
  submit: 'workspace.submitFailed',
};
const WATCH_FAILURE_KEYS: Record<Exclude<AttemptFailure, 'rejected'>, string> = {
  slow: 'workspace.judgingSlow',
  unreachable: 'workspace.resultFetchFailed',
};

/** The i18n key for a failed Attempt, used when the server gave no message of its own. */
function failureKey(attempt: FailedAttempt): string {
  return attempt.reason === 'rejected' ? REJECTED_KEYS[attempt.mode] : WATCH_FAILURE_KEYS[attempt.reason];
}

/** Passed out of judged cases; a custom case without an expected output isn't judged, so it isn't counted. */
function passCount(results: { status: string; judged?: boolean }[]) {
  const judged = results.filter((r) => r.judged !== false);
  return {
    passed: judged.filter((r) => r.status === 'ACCEPTED').length,
    total: judged.length,
  };
}

/** A case that didn't pass. An unjudged custom case fails only when it crashed or timed out. */
function caseFailed(r: { status: SubmissionStatus; judged?: boolean }) {
  if (r.status === 'ACCEPTED' || r.status === 'PENDING') return false;
  if (r.judged === false) {
    return r.status === 'RUNTIME_ERROR' || r.status === 'TIME_LIMIT_EXCEEDED' || r.status === 'COMPILATION_ERROR';
  }
  return true;
}

const isMac =
  typeof navigator !== 'undefined' && /Mac/.test(navigator.userAgent);

interface TestPanelProps {
  sampleTestCases: TestCase[];
  attempt: JudgeAttempt;
  language: string;
  activeTab: string;
  userSource: string;
  customTests: CustomTestCaseInput[];
  onCustomTestsChange: (next: CustomTestCaseInput[]) => void;
  /** Adds a submission's Failing Case to the custom test cases. */
  onAddCustomTest?: (tc: CustomTestCaseInput) => AddCustomTestOutcome;
  /** The Tip explaining the settled result, if any (`tipFor`); shown above its cases. */
  tip?: Tip | null;
  onDismissTip?: (tip: Tip) => void;
  onTabChange: (tab: string) => void;
  onRun: () => void;
  onSubmit: () => void;
  onFold?: () => void;
  onMaximize?: () => void;
  isMaximized?: boolean;
}

function renderableErrors(errors?: CodeError[] | null): CodeError[] {
  return (errors ?? []).filter((e) => e.inUserCode && e.line != null);
}

/** Label for a case's fatal output, by what actually went wrong. */
function errorLabelKey(status: SubmissionStatus, hasCompileOutput: boolean): string {
  if (status === 'RUNTIME_ERROR') return 'test.runtimeError';
  if (status === 'COMPILATION_ERROR' || hasCompileOutput) return 'test.compilationError';
  return 'test.stderr';
}

/** Red wash for what stopped the code, amber for what didn't; both keep the night-mode 950 wash. */
const TONE_CLASS = {
  error: 'bg-error-100 text-error-700 dark:bg-error-950 dark:text-error-400',
  warning: 'bg-warning-100 text-warning-700 dark:bg-warning-950 dark:text-warning-400',
} as const;

type Tone = keyof typeof TONE_CLASS;

function OutputBlock({ label, tone, children }: { label: string; tone: Tone; children: ReactNode }) {
  return (
    <div className="mt-1">
      <span className="text-xs text-muted-foreground">{label}</span>
      <pre className={cn('mt-1 overflow-auto rounded p-2 text-xs', TONE_CLASS[tone])}>{children}</pre>
    </div>
  );
}

/**
 * Line diagnostics split by severity: errors under the fatal label in red, warnings (the code
 * still compiled and ran) under "Warning" in amber, never under "Compilation Error".
 */
function Diagnostics({
  errors,
  errorLabel,
  userSource,
}: {
  errors: CodeError[];
  errorLabel: string;
  userSource: string;
}) {
  const { t } = useTranslation('problem');
  const fatal = errors.filter((e) => e.severity !== 'WARNING');
  const warnings = errors.filter((e) => e.severity === 'WARNING');
  return (
    <>
      {fatal.length > 0 && (
        <div className="mt-1">
          <span className="text-xs text-muted-foreground">{errorLabel}</span>
          <ErrorDisplay errors={fatal} tone="error" userSource={userSource} />
        </div>
      )}
      {warnings.length > 0 && (
        <div className="mt-1">
          <span className="text-xs text-muted-foreground">{t('test.warning')}</span>
          <ErrorDisplay errors={warnings} tone="warning" userSource={userSource} />
        </div>
      )}
    </>
  );
}

function ErrorDisplay({
  errors,
  tone,
  userSource,
}: {
  errors: CodeError[];
  tone: Tone;
  userSource: string;
}) {
  const { t } = useTranslation('problem');
  const sourceLines = userSource.split('\n');
  return (
    <div className={cn('mt-1 space-y-2 overflow-x-auto rounded p-2 text-xs', TONE_CLASS[tone])}>
      {errors.map((e, i) => {
        const snippet = e.line != null ? sourceLines[e.line - 1] : undefined;
        const caret =
          e.column != null && e.column >= 1
            ? ' '.repeat(e.column - 1) + '^'
            : null;
        const label = t(e.severity === 'WARNING' ? 'test.severity.warning' : 'test.severity.error');
        return (
          <div key={i} className="font-mono">
            <div>
              {t('test.errorLine', { line: e.line, severity: label, message: e.message })}
            </div>
            {snippet !== undefined && (
              <pre className="mt-0.5 whitespace-pre">    {snippet}</pre>
            )}
            {caret && <pre className="whitespace-pre">    {caret}</pre>}
          </div>
        );
      })}
    </div>
  );
}

/**
 * The workspace's one live region for Run and Submit. Rendered by the page, not the test panel,
 * so a run started with the shortcut while the panel is folded is still announced.
 */
export function ResultAnnouncer({ attempt }: Pick<TestPanelProps, 'attempt'>) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  let announcement = '';
  if (attempt.kind === 'judging') {
    announcement = t(attempt.mode === 'run' ? 'test.running' : 'test.judging');
  } else if (attempt.kind === 'failed') {
    announcement = attempt.message ?? t(failureKey(attempt));
  } else if (attempt.kind === 'settled') {
    const count = passCount(attempt.result.results);
    const countText = count.total > 0 ? `, ${t('test.passedCount', count)}` : '';
    announcement =
      attempt.mode === 'run'
        ? `${t('test.runResults')}: ${tc(STATUS_KEYS[attempt.result.overallStatus])}${countText}`
        : `${tc(STATUS_KEYS[attempt.result.status])}${countText}`;
  }
  return (
    <p role="status" aria-live="polite" className="sr-only">
      {announcement}
    </p>
  );
}

export function TestPanel({
  sampleTestCases,
  attempt,
  language,
  activeTab,
  userSource,
  customTests,
  onCustomTestsChange,
  onAddCustomTest,
  tip,
  onDismissTip,
  onTabChange,
  onRun,
  onSubmit,
  onFold,
  onMaximize,
  isMaximized,
}: TestPanelProps) {
  const { t } = useTranslation('problem');
  const scrollRef = useRef<HTMLDivElement>(null);
  const jumpedForRef = useRef<unknown>(null);
  const settled = attempt.kind === 'settled' ? attempt.result : null;
  const running = attempt.kind === 'judging' && attempt.mode === 'run';
  const submitting = attempt.kind === 'judging' && attempt.mode === 'submit';

  // Jump to the first failing case once per result, as soon as the output tab shows it.
  useEffect(() => {
    if (!settled || jumpedForRef.current === settled || activeTab !== 'output') return;
    const frame = requestAnimationFrame(() => {
      const container = scrollRef.current;
      const target = container?.querySelector<HTMLElement>('[data-failed]');
      jumpedForRef.current = settled;
      if (!container || !target) return;
      const top =
        container.scrollTop +
        target.getBoundingClientRect().top -
        container.getBoundingClientRect().top -
        12;
      const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      container.scrollTo({ top, behavior: reduce ? 'auto' : 'smooth' });
    });
    return () => cancelAnimationFrame(frame);
  }, [settled, activeTab]);

  return (
    <div className="flex h-full flex-col">
      <Tabs
        defaultValue="testcases"
        value={activeTab}
        onValueChange={onTabChange}
        className="flex min-h-0 flex-1 flex-col overflow-hidden">
        <div className="group flex items-center justify-between border-b border-border bg-muted">
          <TabsList>
            <TabsTrigger value="testcases">{t('test.testCases')}</TabsTrigger>
            <TabsTrigger value="output">{t('test.output')}</TabsTrigger>
          </TabsList>
          <div className="flex items-center pr-1 opacity-0 transition-opacity group-hover:opacity-100 group-focus-within:opacity-100 [@media(hover:none)]:opacity-100">
            <Tooltip>
              <TooltipTrigger>
                <Button
                  variant="ghost"
                  size="icon"
                  className="h-7 w-7"
                  onClick={onFold}
                  aria-label={t('workspace.foldPanel')}>
                  <PanelBottomClose className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>{t('workspace.foldPanel')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button
                  variant="ghost"
                  size="icon"
                  className="h-7 w-7"
                  onClick={onMaximize}
                  aria-label={t(isMaximized ? 'workspace.restoreEditor' : 'workspace.maximizePanel')}>
                  {isMaximized ? <Minimize2 className="h-3.5 w-3.5" /> : <Maximize2 className="h-3.5 w-3.5" />}
                </Button>
              </TooltipTrigger>
              <TooltipContent>{t(isMaximized ? 'workspace.restoreEditor' : 'workspace.maximizePanel')}</TooltipContent>
            </Tooltip>
          </div>
        </div>

        <div ref={scrollRef} className="flex-1 overflow-auto p-3">
          {collectTemplateError(attempt) && (
            <div className="mb-3 rounded-lg border border-warning-200 bg-warning-100 p-3 text-sm text-warning-700 dark:border-warning-900 dark:bg-warning-950 dark:text-warning-400">
              {t('editor.templateErrorBanner')}
            </div>
          )}
          {/* Test Cases Tab */}
          <TabsContent value="testcases" className="mt-0">
            {sampleTestCases.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                {t('test.noSampleTestCases')}
              </p>
            ) : (
              <div className="space-y-2">
                {sampleTestCases.map((tc, i) => (
                  <div key={tc.id} className="border-t border-border pt-2 text-sm first:border-t-0 first:pt-0">
                    <p className="mb-1 font-medium text-muted-foreground">
                      {t('test.case', { n: i + 1 })}
                    </p>
                    <p>
                      <span className="text-muted-foreground">{t('test.input')}</span>
                      <code className="rounded bg-muted px-1 font-mono text-foreground">
                        {tc.input}
                      </code>
                    </p>
                    <p>
                      <span className="text-muted-foreground">{t('test.expected')}</span>
                      <code className="rounded bg-muted px-1 font-mono text-foreground">
                        {tc.expectedOutput}
                      </code>
                    </p>
                  </div>
                ))}
              </div>
            )}

            <div className="my-3 flex items-center gap-2 text-xs text-muted-foreground">
              <div className="flex-1 border-t border-border" />
              <span>{t('test.customTestsHeading')}</span>
              <div className="flex-1 border-t border-border" />
            </div>

            <CustomTestsEditor
              customTests={customTests}
              onChange={onCustomTestsChange}
              hintInput={sampleTestCases[0]?.input}
              hintExpected={sampleTestCases[0]?.expectedOutput}
              maxCases={MAX_CUSTOM_TESTS}
            />
          </TabsContent>

          {/* Output Tab */}
          <TabsContent value="output" className="mt-0">
            <OutputContent
              attempt={attempt}
              language={language}
              userSource={userSource}
              onAddCustomTest={onAddCustomTest}
              tip={tip}
              onDismissTip={onDismissTip}
            />
          </TabsContent>
        </div>
      </Tabs>

      {/* Bottom bar with Run / Submit */}
      <div className="flex flex-shrink-0 items-center justify-between border-t border-border px-3 py-2">
        <div />
        <Stack direction="horizontal" gap="sm">
          <Tooltip>
            <TooltipTrigger>
              <Button
                variant="secondary"
                size="lg"
                data-tour="run"
                onClick={onRun}
                disabled={running || submitting}>
                {running ? t('test.running') : t('test.run')}
                <kbd className="ml-1.5 font-sans text-sm opacity-80">
                  {isMac ? "⌘+'" : "Ctrl+'"}
                </kbd>
              </Button>
            </TooltipTrigger>
            <TooltipContent side="top">
              {t('workspace.runShortcut', { keys: isMac ? "⌘+'" : "Ctrl+'" })}
            </TooltipContent>
          </Tooltip>
          <Tooltip>
            <TooltipTrigger>
              <Button
                variant="accent"
                size="lg"
                data-tour="submit"
                onClick={onSubmit}
                disabled={submitting || running}>
                {submitting ? t('test.submitting') : t('test.submit')}
                <kbd className="ml-1.5 font-sans text-sm opacity-80">
                  {isMac ? '⌘+↵' : 'Ctrl+↵'}
                </kbd>
              </Button>
            </TooltipTrigger>
            <TooltipContent side="top">
              {t('workspace.submitShortcut', { keys: isMac ? '⌘+↵' : 'Ctrl+Enter' })}
            </TooltipContent>
          </Tooltip>
        </Stack>
      </div>
    </div>
  );
}

/* ── Output tab content ── */

function OutputContent({
  attempt,
  language,
  userSource,
  onAddCustomTest,
  tip,
  onDismissTip,
}: Pick<TestPanelProps, 'attempt' | 'language' | 'userSource' | 'onAddCustomTest' | 'tip' | 'onDismissTip'>) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');

  if (attempt.kind === 'judging') {
    return (
      <div className="flex flex-col items-center gap-2 py-8">
        {/* Under reduced motion the ticking clock alone shows progress. */}
        <div className="motion-reduce:hidden">
          <Spinner announce={false} />
        </div>
        <p className="text-sm text-muted-foreground">
          {t(attempt.mode === 'run' ? 'test.running' : 'test.judging')}
        </p>
        <JudgingClock attempt={attempt} language={language} />
      </div>
    );
  }

  if (attempt.kind === 'failed') {
    return (
      <div className="rounded-lg border border-error-200 bg-error-100 p-3 text-sm text-error-700 dark:border-error-900 dark:bg-error-950 dark:text-error-400">
        {attempt.message ?? t(failureKey(attempt))}
      </div>
    );
  }

  const tipCard = tip && onDismissTip ? <TipCard tip={tip} onDismiss={onDismissTip} /> : null;

  if (attempt.kind === 'settled' && attempt.mode === 'run') {
    const runResult = attempt.result;
    const count = passCount(runResult.results);
    const samples = runResult.results.filter((r) => !r.isCustom);
    const customs = runResult.results.filter((r) => r.isCustom);
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <span className="text-sm font-semibold text-foreground">
            {t('test.runResults')}
          </span>
          <div className="flex items-center gap-2">
            {count.total > 0 && <PassCount {...count} />}
            <StatusBadge status={runResult.overallStatus} />
          </div>
        </div>
        {tipCard}
        {samples.length > 0 && (
          <RunResultsSection
            heading={customs.length > 0 ? t('test.sampleTestsHeading') : null}
            results={samples}
            labelKey="test.sample"
            userSource={userSource}
          />
        )}
        {customs.length > 0 && (
          <RunResultsSection
            heading={t('test.customTestsHeading')}
            results={customs}
            labelKey="test.case"
            userSource={userSource}
          />
        )}
      </div>
    );
  }

  if (attempt.kind === 'settled') {
    const submitResult = attempt.result;
    const count = passCount(submitResult.results);
    return (
      <div className="space-y-3">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <div className="flex items-center gap-2">
            <StatusBadge status={submitResult.status} />
            {submitResult.failingCase && (
              <span className="text-xs">
                <FailingCasePosition failingCase={submitResult.failingCase} />
              </span>
            )}
            {count.total > 0 && <PassCount {...count} />}
          </div>
          <div className="space-x-3 font-mono text-xs tabular-nums text-muted-foreground">
            {submitResult.runtimeMs != null && (
              <span>{tc('label.runtime')}: {submitResult.runtimeMs}ms</span>
            )}
            {submitResult.memoryKb != null && (
              <span>{tc('label.memory')}: {submitResult.memoryKb}KB</span>
            )}
          </div>
        </div>
        {tipCard}
        <SubmissionOutcomeDetails submission={submitResult} onAddCustomTest={onAddCustomTest} />
      </div>
    );
  }

  return (
    <p className="py-8 text-center text-sm text-muted-foreground">
      {t('test.placeholder')}
    </p>
  );
}

function PassCount({ passed, total }: { passed: number; total: number }) {
  const { t } = useTranslation('problem');
  return (
    <span className="font-mono text-xs tabular-nums text-muted-foreground">
      {t('test.passedCount', { passed, total })}
    </span>
  );
}

/**
 * Elapsed judging time against the usual wait for this language, so a slow Java judge reads as
 * expected. Deliberately not a live region: the page's ResultAnnouncer speaks the start and the
 * result, and a screen reader reaches the current count by reading the panel.
 */
function JudgingClock({ attempt, language }: { attempt: JudgingAttempt; language: string }) {
  const { t } = useTranslation('problem');
  const { startedAt, mode } = attempt;
  const [now, setNow] = useState(() => Date.now());

  useEffect(() => {
    const timer = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(timer);
  }, [startedAt]);

  const seconds = Math.max(0, Math.floor((now - startedAt) / 1000));
  const typical = estimatedJudgeSeconds(language, mode);
  return (
    <p className="text-xs text-muted-foreground">
      <span className="font-mono tabular-nums text-foreground">
        {t('workspace.judgingElapsed', { seconds })}
      </span>
      {typical != null && (
        <span> · {t('workspace.judgingTypical', { seconds: typical })}</span>
      )}
    </p>
  );
}

interface RunResultsSectionProps {
  heading: string | null;
  results: RunTestCaseResult[];
  labelKey: string;
  userSource: string;
}

function RunResultsSection({
  heading,
  results,
  labelKey,
  userSource,
}: RunResultsSectionProps) {
  const { t } = useTranslation('problem');
  return (
    <div className="space-y-2">
      {heading && (
        <h3 className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
          {heading}
        </h3>
      )}
      {results.map((r, i) => (
        <div
          key={i}
          data-failed={caseFailed(r) || undefined}
          className="border-t border-border pt-2 text-sm first:border-t-0 first:pt-0">
          <div className="mb-1 flex items-center justify-between">
            <span className="font-medium text-muted-foreground">
              {t(labelKey, { n: i + 1 })}
            </span>
            {r.judged ? (
              <StatusBadge status={r.status} />
            ) : (
              <Badge variant="secondary">{t('test.finished')}</Badge>
            )}
          </div>
          <p>
            <span className="text-muted-foreground">{t('test.input')}</span>
            <code className="rounded bg-muted px-1 font-mono text-foreground">
              {r.input}
            </code>
          </p>
          {r.expectedOutput != null && (
            <p>
              <span className="text-muted-foreground">{t('test.expected')}</span>
              <code className="rounded bg-muted px-1 font-mono text-foreground">
                {r.expectedOutput}
              </code>
            </p>
          )}
          {r.actualOutput && (
            <p>
              <span className="text-muted-foreground">{t('test.outputLabel')}</span>
              <code className="rounded bg-muted px-1 font-mono text-foreground">
                {r.actualOutput}
              </code>
            </p>
          )}
          <CaseOutput
            status={r.status}
            errors={r.errors}
            stderr={r.stderr}
            compileOutput={r.compileOutput}
            userSource={userSource}
          />
        </div>
      ))}
    </div>
  );
}

function isFatalStatus(status: SubmissionStatus) {
  return status === 'RUNTIME_ERROR' || status === 'COMPILATION_ERROR';
}

/**
 * A case's diagnostics and raw output, shared by Run and Submit. Red or amber is decided by the
 * case's status, never by what the parser found: a fatal case with no fatal line parsed (an
 * unparsed error, -Werror) shows its raw output in red; output from code that still ran is an
 * amber Warning. Submit results carry no raw stderr or compiler output.
 */
function CaseOutput({
  status,
  errors,
  stderr,
  compileOutput,
  userSource,
}: {
  status: SubmissionStatus;
  errors?: CodeError[] | null;
  stderr?: string | null;
  compileOutput?: string | null;
  userSource: string;
}) {
  const { t } = useTranslation('problem');
  const visible = renderableErrors(errors);
  const errorLabel = t(errorLabelKey(status, !!compileOutput));
  const hasFatalLine = visible.some((e) => e.severity !== 'WARNING');
  let raw: ReactNode = null;
  if (isFatalStatus(status)) {
    if (!hasFatalLine) {
      const unplaced = (errors ?? [])
        .filter((e) => e.inUserCode && e.line == null && e.severity !== 'WARNING')
        .map((e) => e.message)
        .join('\n');
      raw = (
        <OutputBlock label={errorLabel} tone="error">
          {stderr || compileOutput || unplaced || t('test.noErrorDetails')}
        </OutputBlock>
      );
    }
  } else if (stderr) {
    raw = <OutputBlock label={t('test.warning')} tone="warning">{stderr}</OutputBlock>;
  } else if (compileOutput && visible.length === 0) {
    raw = <OutputBlock label={t('test.warning')} tone="warning">{compileOutput}</OutputBlock>;
  }
  return (
    <>
      <Diagnostics errors={visible} errorLabel={errorLabel} userSource={userSource} />
      {raw}
    </>
  );
}

interface CollapsedTestStripProps {
  onExpand: () => void;
  onMaximize: () => void;
  isMaximized: boolean;
}

export function CollapsedTestStrip({ onExpand, onMaximize, isMaximized }: CollapsedTestStripProps) {
  const { t } = useTranslation('problem');
  return (
    <div className="group/strip flex h-full items-center justify-between px-2">
      {/* Tab buttons */}
      <div className="flex items-center gap-1">
        <button
          type="button"
          onClick={onExpand}
          className="rounded px-2 py-1 text-xs font-medium text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
          {t('test.testCases')}
        </button>
        <button
          type="button"
          onClick={onExpand}
          className="rounded px-2 py-1 text-xs font-medium text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
          {t('test.output')}
        </button>
      </div>

      {/* Right-side buttons — visible on hover */}
      <div className={cn('flex items-center gap-1 opacity-0 transition-opacity group-hover/strip:opacity-100 group-focus-within/strip:opacity-100 [@media(hover:none)]:opacity-100')}>
        <Tooltip>
          <TooltipTrigger>
            <Button
              variant="ghost"
              size="icon"
              className="h-7 w-7"
              onClick={onExpand}
              aria-label={t('workspace.expandPanel')}>
              <PanelBottomOpen className="h-3.5 w-3.5" />
            </Button>
          </TooltipTrigger>
          <TooltipContent>{t('workspace.expandPanel')}</TooltipContent>
        </Tooltip>
        <Tooltip>
          <TooltipTrigger>
            <Button
              variant="ghost"
              size="icon"
              className="h-7 w-7"
              onClick={onMaximize}
              aria-label={t(isMaximized ? 'workspace.restoreEditor' : 'workspace.maximizePanel')}>
              {isMaximized ? <Minimize2 className="h-3.5 w-3.5" /> : <Maximize2 className="h-3.5 w-3.5" />}
            </Button>
          </TooltipTrigger>
          <TooltipContent>{t(isMaximized ? 'workspace.restoreEditor' : 'workspace.maximizePanel')}</TooltipContent>
        </Tooltip>
      </div>
    </div>
  );
}

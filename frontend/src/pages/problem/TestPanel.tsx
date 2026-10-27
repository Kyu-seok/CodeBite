import { useEffect, useState } from 'react';
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
  RunResponse,
  RunTestCaseResult,
  SubmissionResponse,
} from '@/types/submission';
import { CustomTestsEditor } from './CustomTestsEditor';
import { STATUS_KEYS, languageLabel, typicalJudgeSeconds } from './submissionDisplay';

function hasTemplateError(errs?: CodeError[] | null): boolean {
  return !!errs?.some((e) => !e.inUserCode);
}

function collectTemplateError(
  runResult: RunResponse | null,
  submitResult: SubmissionResponse | null,
): boolean {
  if (runResult?.results.some((r) => hasTemplateError(r.errors))) return true;
  if (submitResult?.results.some((r) => hasTemplateError(r.errors))) return true;
  return false;
}

const isMac =
  typeof navigator !== 'undefined' && /Mac/.test(navigator.userAgent);

interface TestPanelProps {
  sampleTestCases: TestCase[];
  runResult: RunResponse | null;
  runError: string | null;
  submitResult: SubmissionResponse | null;
  submitError: string | null;
  running: boolean;
  submitting: boolean;
  submitStartedAt: number | null;
  language: string;
  activeTab: string;
  userSource: string;
  customTests: CustomTestCaseInput[];
  onCustomTestsChange: (next: CustomTestCaseInput[]) => void;
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

/** Warnings alone mean the code compiled, so they must not be headed "Compilation Error". */
function diagnosticsLabelKey(errors: CodeError[], fallback: string): string {
  return errors.length > 0 && errors.every((e) => e.severity === 'WARNING')
    ? 'test.compilerWarnings'
    : fallback;
}

function ErrorDisplay({
  errors,
  userSource,
}: {
  errors: CodeError[];
  userSource: string;
}) {
  const { t } = useTranslation('problem');
  const sourceLines = userSource.split('\n');
  // Warnings alone (e.g. a missing return) take amber; red is kept for real errors.
  const onlyWarnings = errors.every((e) => e.severity === 'WARNING');
  return (
    <div
      className={cn(
        'mt-1 space-y-2 rounded p-2 text-xs',
        onlyWarnings
          ? 'bg-warning-100 text-warning-700 dark:bg-warning-950 dark:text-warning-400'
          : 'bg-error-100 text-error-700 dark:bg-error-950 dark:text-error-400',
      )}>
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

export function TestPanel({
  sampleTestCases,
  runResult,
  runError,
  submitResult,
  submitError,
  running,
  submitting,
  submitStartedAt,
  language,
  activeTab,
  userSource,
  customTests,
  onCustomTestsChange,
  onTabChange,
  onRun,
  onSubmit,
  onFold,
  onMaximize,
  isMaximized,
}: TestPanelProps) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  const announcement = running
    ? t('test.running')
    : submitting
      ? t('test.judging')
      : runError || submitError
        ? (runError || submitError)!
        : runResult
          ? `${t('test.runResults')}: ${tc(STATUS_KEYS[runResult.overallStatus])}`
          : submitResult
            ? tc(STATUS_KEYS[submitResult.status])
            : '';
  return (
    <div className="flex h-full flex-col">
      {/* Always mounted so screen readers hear the verdict when it lands. */}
      <p role="status" aria-live="polite" className="sr-only">
        {announcement}
      </p>
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

        <div className="flex-1 overflow-auto p-3">
          {collectTemplateError(runResult, submitResult) && (
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
              maxCases={5}
            />
          </TabsContent>

          {/* Output Tab */}
          <TabsContent value="output" className="mt-0">
            <OutputContent
              running={running}
              submitting={submitting}
              submitStartedAt={submitStartedAt}
              language={language}
              runResult={runResult}
              runError={runError}
              submitResult={submitResult}
              submitError={submitError}
              userSource={userSource}
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
  running,
  submitting,
  submitStartedAt,
  language,
  runResult,
  runError,
  submitResult,
  submitError,
  userSource,
}: Pick<
  TestPanelProps,
  | 'running'
  | 'submitting'
  | 'submitStartedAt'
  | 'language'
  | 'runResult'
  | 'runError'
  | 'submitResult'
  | 'submitError'
  | 'userSource'
>) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');

  if (running) {
    return (
      <div className="flex flex-col items-center gap-2 py-8">
        <Spinner />
        <p className="text-sm text-muted-foreground">{t('test.running')}</p>
      </div>
    );
  }

  if (submitting) {
    return (
      <div className="flex flex-col items-center gap-2 py-8">
        <Spinner />
        <p className="text-sm text-muted-foreground">{t('test.judging')}</p>
        <JudgingClock startedAt={submitStartedAt} language={language} />
      </div>
    );
  }

  if (runError || submitError) {
    return (
      <div className="rounded-lg border border-error-200 bg-error-100 p-3 text-sm text-error-700 dark:border-error-900 dark:bg-error-950 dark:text-error-400">
        {runError || submitError}
      </div>
    );
  }

  if (runResult) {
    const samples = runResult.results.filter((r) => !r.isCustom);
    const customs = runResult.results.filter((r) => r.isCustom);
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <span className="text-sm font-semibold text-foreground">
            {t('test.runResults')}
          </span>
          <StatusBadge status={runResult.overallStatus} />
        </div>
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

  if (submitResult) {
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <StatusBadge status={submitResult.status} />
          <div className="space-x-3 font-mono text-xs tabular-nums text-muted-foreground">
            {submitResult.runtimeMs != null && (
              <span>{tc('label.runtime')}: {submitResult.runtimeMs}ms</span>
            )}
            {submitResult.memoryKb != null && (
              <span>{tc('label.memory')}: {submitResult.memoryKb}KB</span>
            )}
          </div>
        </div>
        {submitResult.results.length > 0 && (
          <div className="space-y-2">
            <h3 className="text-sm font-semibold text-foreground">
              {t('test.testResults')}
            </h3>
            {submitResult.results.map((r, i) => (
              <div
                key={r.testCaseId}
                className="border-t border-border pt-2 text-sm first:border-t-0 first:pt-0">
                <div className="mb-1 flex items-center justify-between">
                  <span className="font-medium text-muted-foreground">
                    {t('test.test', { n: i + 1 })}
                  </span>
                  <StatusBadge status={r.status} />
                </div>
                {r.input && (
                  <p>
                    <span className="text-muted-foreground">{t('test.input')}</span>
                    <code className="rounded bg-muted px-1 font-mono text-foreground">
                      {r.input}
                    </code>
                  </p>
                )}
                {r.expectedOutput && (
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
                {(() => {
                  const visible = renderableErrors(r.errors);
                  if (visible.length === 0) return null;
                  return (
                    <div className="mt-1">
                      <span className="text-xs text-muted-foreground">
                        {t(diagnosticsLabelKey(visible, 'test.compilationError'))}
                      </span>
                      <ErrorDisplay errors={visible} userSource={userSource} />
                    </div>
                  );
                })()}
              </div>
            ))}
          </div>
        )}
      </div>
    );
  }

  return (
    <p className="py-8 text-center text-sm text-muted-foreground">
      {t('test.placeholder')}
    </p>
  );
}

/** Elapsed judging time against the measured typical wait, so a slow Java judge reads as expected. */
function JudgingClock({ startedAt, language }: { startedAt: number | null; language: string }) {
  const { t } = useTranslation('problem');
  const [now, setNow] = useState(() => Date.now());

  useEffect(() => {
    if (startedAt == null) return;
    const timer = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(timer);
  }, [startedAt]);

  if (startedAt == null) return null;
  const seconds = Math.max(0, Math.floor((now - startedAt) / 1000));
  const typical = typicalJudgeSeconds(language);
  return (
    <p className="text-xs text-muted-foreground">
      <span className="font-mono tabular-nums text-foreground">
        {t('workspace.judgingElapsed', { seconds })}
      </span>
      {typical != null && (
        <span> · {t('workspace.judgingTypical', { seconds: typical, language: languageLabel(language) })}</span>
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
        <div key={i} className="border-t border-border pt-2 text-sm first:border-t-0 first:pt-0">
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
          {(() => {
            const visible = renderableErrors(r.errors);
            const label = t(
              diagnosticsLabelKey(visible, r.compileOutput ? 'test.compilationError' : 'test.stderr'),
            );
            if (visible.length > 0) {
              return (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">{label}</span>
                  <ErrorDisplay errors={visible} userSource={userSource} />
                </div>
              );
            }
            if (r.stderr) {
              return (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">{t('test.stderr')}</span>
                  <pre className="mt-1 overflow-auto rounded bg-error-100 p-2 text-xs text-error-700 dark:bg-error-950 dark:text-error-400">
                    {r.stderr}
                  </pre>
                </div>
              );
            }
            if (r.compileOutput) {
              return (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">
                    {t('test.compilationError')}
                  </span>
                  <pre className="mt-1 overflow-auto rounded bg-warning-100 p-2 text-xs text-warning-700 dark:bg-warning-950 dark:text-warning-400">
                    {r.compileOutput}
                  </pre>
                </div>
              );
            }
            return null;
          })()}
        </div>
      ))}
    </div>
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

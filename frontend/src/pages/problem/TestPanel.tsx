import { useTranslation } from 'react-i18next';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import { Button } from '@/components/ui/Button';
import { Stack } from '@/components/layout/Stack';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';
import {
  Tooltip,
  TooltipTrigger,
  TooltipContent,
} from '@/components/ui/Tooltip';
import type { TestCase } from '@/types/problem';
import type { CodeError, RunResponse, SubmissionResponse } from '@/types/submission';

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
  activeTab: string;
  onTabChange: (tab: string) => void;
  onRun: () => void;
  onSubmit: () => void;
}

export function TestPanel({
  sampleTestCases,
  runResult,
  runError,
  submitResult,
  submitError,
  running,
  submitting,
  activeTab,
  onTabChange,
  onRun,
  onSubmit,
}: TestPanelProps) {
  const { t } = useTranslation('problem');
  return (
    <div className="flex h-full flex-col">
      <Tabs
        defaultValue="testcases"
        value={activeTab}
        onValueChange={onTabChange}
        className="flex min-h-0 flex-1 flex-col">
        <div className="border-b border-border bg-muted">
          <TabsList>
            <TabsTrigger value="testcases">{t('test.testCases')}</TabsTrigger>
            <TabsTrigger value="output">{t('test.output')}</TabsTrigger>
          </TabsList>
        </div>

        <div className="flex-1 overflow-auto p-3">
          {collectTemplateError(runResult, submitResult) && (
            <div className="mb-3 rounded-lg border border-warning-200 bg-warning-100 p-3 text-sm text-warning-700">
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
                  <div key={tc.id} className="rounded-lg bg-muted p-3 text-sm">
                    <p className="mb-1 font-medium text-muted-foreground">
                      {t('test.case', { n: i + 1 })}
                    </p>
                    <p>
                      <span className="text-muted-foreground">{t('test.input')}</span>
                      <code className="rounded bg-secondary px-1 text-foreground">
                        {tc.input}
                      </code>
                    </p>
                    <p>
                      <span className="text-muted-foreground">{t('test.expected')}</span>
                      <code className="rounded bg-secondary px-1 text-foreground">
                        {tc.expectedOutput}
                      </code>
                    </p>
                  </div>
                ))}
              </div>
            )}
          </TabsContent>

          {/* Output Tab */}
          <TabsContent value="output" className="mt-0">
            <OutputContent
              running={running}
              submitting={submitting}
              runResult={runResult}
              runError={runError}
              submitResult={submitResult}
              submitError={submitError}
            />
          </TabsContent>
        </div>
      </Tabs>

      {/* Bottom bar with Run / Submit */}
      <div className="flex items-center justify-between border-t border-border px-3 py-2">
        <div />
        <Stack direction="horizontal" gap="sm">
          <Tooltip>
            <TooltipTrigger>
              <Button
                variant="outline"
                size="lg"
                onClick={onRun}
                disabled={running || submitting}
                className="border-accent-500/40 text-accent-500 hover:bg-accent-500/10 hover:border-accent-500">
                {running ? t('test.running') : t('test.run')}
                <kbd className="ml-1.5 text-lg opacity-60">
                  {isMac ? "⌘+'" : "Ctrl+'"}
                </kbd>
              </Button>
            </TooltipTrigger>
            <TooltipContent side="top">
              {isMac ? "⌘+'" : "Ctrl+'"} to run
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
                <kbd className="ml-1.5 text-lg opacity-60">
                  {isMac ? '⌘+↵' : 'Ctrl+↵'}
                </kbd>
              </Button>
            </TooltipTrigger>
            <TooltipContent side="top">
              {isMac ? '⌘+↵' : 'Ctrl+Enter'} to submit
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
  runResult,
  runError,
  submitResult,
  submitError,
}: Pick<
  TestPanelProps,
  | 'running'
  | 'submitting'
  | 'runResult'
  | 'runError'
  | 'submitResult'
  | 'submitError'
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
      </div>
    );
  }

  if (runError || submitError) {
    return (
      <div className="rounded-lg border border-error-200 bg-error-100 p-3 text-sm text-error-700">
        {runError || submitError}
      </div>
    );
  }

  if (runResult) {
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <span className="text-sm font-semibold text-foreground">
            {t('test.runResults')}
          </span>
          <StatusBadge status={runResult.overallStatus} />
        </div>
        <div className="space-y-2">
          {runResult.results.map((r, i) => (
            <div key={i} className="rounded-lg bg-muted p-3 text-sm">
              <div className="mb-1 flex items-center justify-between">
                <span className="font-medium text-muted-foreground">
                  {t('test.sample', { n: i + 1 })}
                </span>
                <StatusBadge status={r.status} />
              </div>
              <p>
                <span className="text-muted-foreground">{t('test.input')}</span>
                <code className="rounded bg-secondary px-1 text-foreground">
                  {r.input}
                </code>
              </p>
              <p>
                <span className="text-muted-foreground">{t('test.expected')}</span>
                <code className="rounded bg-secondary px-1 text-foreground">
                  {r.expectedOutput}
                </code>
              </p>
              {r.actualOutput && (
                <p>
                  <span className="text-muted-foreground">{t('test.outputLabel')}</span>
                  <code className="rounded bg-secondary px-1 text-foreground">
                    {r.actualOutput}
                  </code>
                </p>
              )}
              {r.stderr && (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">{t('test.stderr')}</span>
                  <pre className="mt-1 overflow-auto rounded bg-error-100 p-2 text-xs text-error-700">
                    {r.stderr}
                  </pre>
                </div>
              )}
              {r.compileOutput && (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">
                    {t('test.compilationError')}
                  </span>
                  <pre className="mt-1 overflow-auto rounded bg-warning-100 p-2 text-xs text-warning-700">
                    {r.compileOutput}
                  </pre>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    );
  }

  if (submitResult) {
    return (
      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <StatusBadge status={submitResult.status} />
          <div className="space-x-3 text-xs text-muted-foreground">
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
                className="rounded-lg bg-muted p-3 text-sm">
                <div className="mb-1 flex items-center justify-between">
                  <span className="font-medium text-muted-foreground">
                    {t('test.test', { n: i + 1 })}
                  </span>
                  <StatusBadge status={r.status} />
                </div>
                {r.input && (
                  <p>
                    <span className="text-muted-foreground">{t('test.input')}</span>
                    <code className="rounded bg-secondary px-1 text-foreground">
                      {r.input}
                    </code>
                  </p>
                )}
                {r.expectedOutput && (
                  <p>
                    <span className="text-muted-foreground">{t('test.expected')}</span>
                    <code className="rounded bg-secondary px-1 text-foreground">
                      {r.expectedOutput}
                    </code>
                  </p>
                )}
                {r.actualOutput && (
                  <p>
                    <span className="text-muted-foreground">{t('test.outputLabel')}</span>
                    <code className="rounded bg-secondary px-1 text-foreground">
                      {r.actualOutput}
                    </code>
                  </p>
                )}
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

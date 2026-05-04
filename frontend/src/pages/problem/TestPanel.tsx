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
import type { TestCase } from '@/types/problem';
import type {
  CodeError,
  CustomTestCaseInput,
  RunResponse,
  RunTestCaseResult,
  SubmissionResponse,
} from '@/types/submission';
import { CustomTestsEditor } from './CustomTestsEditor';

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
  userSource: string;
  customTests: CustomTestCaseInput[];
  onCustomTestsChange: (next: CustomTestCaseInput[]) => void;
  onTabChange: (tab: string) => void;
  onRun: () => void;
  onSubmit: () => void;
}

function renderableErrors(errors?: CodeError[] | null): CodeError[] {
  return (errors ?? []).filter((e) => e.inUserCode && e.line != null);
}

function ErrorDisplay({
  errors,
  userSource,
}: {
  errors: CodeError[];
  userSource: string;
}) {
  const sourceLines = userSource.split('\n');
  return (
    <div className="mt-1 space-y-2 rounded bg-error-100 p-2 text-xs text-error-700">
      {errors.map((e, i) => {
        const snippet = e.line != null ? sourceLines[e.line - 1] : undefined;
        const caret =
          e.column != null && e.column >= 1
            ? ' '.repeat(e.column - 1) + '^'
            : null;
        const label = e.severity === 'WARNING' ? 'warning' : 'error';
        return (
          <div key={i} className="font-mono">
            <div>
              Line {e.line}: {label}: {e.message}
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
  activeTab,
  userSource,
  customTests,
  onCustomTestsChange,
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
  userSource,
}: Pick<
  TestPanelProps,
  | 'running'
  | 'submitting'
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
                {(() => {
                  const visible = renderableErrors(r.errors);
                  if (visible.length === 0) return null;
                  return (
                    <div className="mt-1">
                      <span className="text-xs text-muted-foreground">
                        {t('test.compilationError')}
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
        <div key={i} className="rounded-lg bg-muted p-3 text-sm">
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
            <code className="rounded bg-secondary px-1 text-foreground">
              {r.input}
            </code>
          </p>
          {r.expectedOutput != null && (
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
          {(() => {
            const visible = renderableErrors(r.errors);
            const label = r.compileOutput
              ? t('test.compilationError')
              : t('test.stderr');
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
                  <pre className="mt-1 overflow-auto rounded bg-error-100 p-2 text-xs text-error-700">
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
                  <pre className="mt-1 overflow-auto rounded bg-warning-100 p-2 text-xs text-warning-700">
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

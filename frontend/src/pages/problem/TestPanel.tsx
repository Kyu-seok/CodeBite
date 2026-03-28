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
import type { RunResponse, SubmissionResponse } from '@/types/submission';

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
  return (
    <div className="flex h-full flex-col">
      <Tabs
        defaultValue="testcases"
        value={activeTab}
        onValueChange={onTabChange}
        className="flex min-h-0 flex-1 flex-col">
        <div className="border-b border-border bg-muted">
          <TabsList>
            <TabsTrigger value="testcases">Test Cases</TabsTrigger>
            <TabsTrigger value="output">Output</TabsTrigger>
          </TabsList>
        </div>

        <div className="flex-1 overflow-auto p-3">
          {/* Test Cases Tab */}
          <TabsContent value="testcases" className="mt-0">
            {sampleTestCases.length === 0 ? (
              <p className="text-sm text-muted-foreground">
                No sample test cases available
              </p>
            ) : (
              <div className="space-y-2">
                {sampleTestCases.map((tc, i) => (
                  <div key={tc.id} className="rounded-lg bg-muted p-3 text-sm">
                    <p className="mb-1 font-medium text-muted-foreground">
                      Case {i + 1}
                    </p>
                    <p>
                      <span className="text-muted-foreground">Input: </span>
                      <code className="rounded bg-secondary px-1 text-foreground">
                        {tc.input}
                      </code>
                    </p>
                    <p>
                      <span className="text-muted-foreground">Expected: </span>
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
                {running ? 'Running...' : 'Run'}
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
                {submitting ? 'Submitting...' : 'Submit'}
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
  if (running) {
    return (
      <div className="flex flex-col items-center gap-2 py-8">
        <Spinner />
        <p className="text-sm text-muted-foreground">Running...</p>
      </div>
    );
  }

  if (submitting) {
    return (
      <div className="flex flex-col items-center gap-2 py-8">
        <Spinner />
        <p className="text-sm text-muted-foreground">Judging...</p>
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
            Run Results
          </span>
          <StatusBadge status={runResult.overallStatus} />
        </div>
        <div className="space-y-2">
          {runResult.results.map((r, i) => (
            <div key={i} className="rounded-lg bg-muted p-3 text-sm">
              <div className="mb-1 flex items-center justify-between">
                <span className="font-medium text-muted-foreground">
                  Sample {i + 1}
                </span>
                <StatusBadge status={r.status} />
              </div>
              <p>
                <span className="text-muted-foreground">Input: </span>
                <code className="rounded bg-secondary px-1 text-foreground">
                  {r.input}
                </code>
              </p>
              <p>
                <span className="text-muted-foreground">Expected: </span>
                <code className="rounded bg-secondary px-1 text-foreground">
                  {r.expectedOutput}
                </code>
              </p>
              {r.actualOutput && (
                <p>
                  <span className="text-muted-foreground">Output: </span>
                  <code className="rounded bg-secondary px-1 text-foreground">
                    {r.actualOutput}
                  </code>
                </p>
              )}
              {r.stderr && (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">Stderr:</span>
                  <pre className="mt-1 overflow-auto rounded bg-error-100 p-2 text-xs text-error-700">
                    {r.stderr}
                  </pre>
                </div>
              )}
              {r.compileOutput && (
                <div className="mt-1">
                  <span className="text-xs text-muted-foreground">
                    Compilation Error:
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
              <span>Runtime: {submitResult.runtimeMs}ms</span>
            )}
            {submitResult.memoryKb != null && (
              <span>Memory: {submitResult.memoryKb}KB</span>
            )}
          </div>
        </div>
        {submitResult.results.length > 0 && (
          <div className="space-y-2">
            <h3 className="text-sm font-semibold text-foreground">
              Test Results
            </h3>
            {submitResult.results.map((r, i) => (
              <div
                key={r.testCaseId}
                className="rounded-lg bg-muted p-3 text-sm">
                <div className="mb-1 flex items-center justify-between">
                  <span className="font-medium text-muted-foreground">
                    Test {i + 1}
                  </span>
                  <StatusBadge status={r.status} />
                </div>
                {r.input && (
                  <p>
                    <span className="text-muted-foreground">Input: </span>
                    <code className="rounded bg-secondary px-1 text-foreground">
                      {r.input}
                    </code>
                  </p>
                )}
                {r.expectedOutput && (
                  <p>
                    <span className="text-muted-foreground">Expected: </span>
                    <code className="rounded bg-secondary px-1 text-foreground">
                      {r.expectedOutput}
                    </code>
                  </p>
                )}
                {r.actualOutput && (
                  <p>
                    <span className="text-muted-foreground">Output: </span>
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
      Run or submit your code to see results
    </p>
  );
}

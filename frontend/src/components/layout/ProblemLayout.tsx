import { type ReactNode, type RefObject, useRef } from 'react';
import {
  ResizablePanelGroup,
  ResizablePanel,
  ResizableHandle,
} from '@/components/ui/Resizable';
import { useGroupRef, usePanelRef } from 'react-resizable-panels';
import { PageLayout } from './PageLayout';
import { cn } from '@/lib/utils';

export interface PanelFunctions {
  collapseLeft: () => void;
  expandLeft: () => void;
  collapseRight: () => void;
  expandRight: () => void;
  collapseEditor: () => void;
  expandEditor: () => void;
  collapseTests: () => void;
  expandTests: () => void;
}

interface ProblemLayoutProps {
  /** Left panel: tabbed content (description, submissions, solutions) */
  leftPanel: ReactNode;
  /** Upper-right panel: code editor with language selector */
  editor: ReactNode;
  /** Lower-right panel: test cases, run/submit results */
  testPanel: ReactNode;
  /** Ref to expose a resetLayout() function to the parent */
  resetLayoutRef?: RefObject<(() => void) | null>;
  /** Ref to expose imperative collapse/expand functions to the parent */
  panelFunctionsRef?: RefObject<PanelFunctions | null>;
  onLeftCollapsed?: (v: boolean) => void;
  onRightCollapsed?: (v: boolean) => void;
  onEditorCollapsed?: (v: boolean) => void;
  onTestsCollapsed?: (v: boolean) => void;
  leftCollapsed?: boolean;
  testsCollapsed?: boolean;
  /** Content to render in the thin strip when a panel is collapsed */
  collapsedLeftContent?: ReactNode;
  collapsedTestContent?: ReactNode;
  className?: string;
}

/**
 * LeetCode-style 3-panel resizable workspace layout.
 *
 * ┌──────────────┬────────────────────┐
 * │              │   Code Editor      │
 * │  Problem     ├────────────────────┤
 * │  Description │   Test Cases /     │
 * │              │   Results          │
 * └──────────────┴────────────────────┘
 *
 * - Horizontal split: leftPanel | editor+tests (default 50/50)
 * - Vertical split on right: editor | tests (default 60/40)
 * - All panels resizable with drag handles
 * - Falls back to stacked layout on small screens
 */
export function ProblemLayout({
  leftPanel,
  editor,
  testPanel,
  resetLayoutRef,
  panelFunctionsRef,
  onLeftCollapsed,
  onRightCollapsed,
  onEditorCollapsed,
  onTestsCollapsed,
  leftCollapsed,
  testsCollapsed,
  collapsedLeftContent,
  collapsedTestContent,
  className,
}: ProblemLayoutProps) {
  const hGroupRef = useGroupRef();
  const vGroupRef = useGroupRef();
  const leftRef = usePanelRef();
  const rightRef = usePanelRef();
  const editorRef = usePanelRef();
  const testsRef = usePanelRef();

  const prevLeftPct = useRef(50);
  const prevTestsPct = useRef(40);

  if (resetLayoutRef) {
    resetLayoutRef.current = () => {
      leftRef.current?.expand();
      rightRef.current?.expand();
      editorRef.current?.expand();
      testsRef.current?.expand();
      hGroupRef.current?.setLayout({ left: 50, right: 50 });
      vGroupRef.current?.setLayout({ editor: 60, tests: 40 });
    };
  }

  if (panelFunctionsRef) {
    panelFunctionsRef.current = {
      collapseLeft: () => leftRef.current?.collapse(),
      expandLeft: () => leftRef.current?.expand(),
      collapseRight: () => rightRef.current?.collapse(),
      expandRight: () => rightRef.current?.expand(),
      collapseEditor: () => editorRef.current?.collapse(),
      expandEditor: () => editorRef.current?.expand(),
      collapseTests: () => testsRef.current?.collapse(),
      expandTests: () => testsRef.current?.expand(),
    };
  }

  return (
    <PageLayout variant="workspace" className={cn('px-2 pb-2', className)}>
      {/* Desktop: resizable panels */}
      <div className="hidden md:flex h-full gap-1">
        {leftCollapsed && collapsedLeftContent && (
          <div className="flex-shrink-0 w-9 rounded-lg border border-border bg-card overflow-hidden">
            {collapsedLeftContent}
          </div>
        )}
        <div className="flex-1 min-w-0 h-full">
          <ResizablePanelGroup orientation="horizontal" id="problem-h" groupRef={hGroupRef}>
            {/* Left — Description */}
            <ResizablePanel
              id="left"
              panelRef={leftRef}
              defaultSize={50}
              minSize={15}
              collapsible
              collapsedSize={0}
              onResize={(size) => {
                const pct = size.asPercentage;
                const prev = prevLeftPct.current;
                prevLeftPct.current = pct;
                onLeftCollapsed?.(pct === 0);
                if (pct > 0 && pct <= 15 && prev > 15) {
                  leftRef.current?.collapse();
                }
              }}>
              <div className="h-full overflow-auto rounded-lg border border-border bg-card">
                {leftPanel}
              </div>
            </ResizablePanel>

            <ResizableHandle withHandle />

            {/* Right — Editor + Test panel */}
            <ResizablePanel
              id="right"
              panelRef={rightRef}
              defaultSize={50}
              minSize={20}
              collapsible
              collapsedSize={0}
              onResize={(size) => onRightCollapsed?.(size.asPercentage === 0)}>
              <div className="h-full flex flex-col gap-1">
                <div className="flex-1 min-h-0">
                  <ResizablePanelGroup orientation="vertical" id="problem-v" groupRef={vGroupRef}>
                    {/* Upper-right — Editor */}
                    <ResizablePanel
                      id="editor"
                      panelRef={editorRef}
                      defaultSize={60}
                      minSize={20}
                      collapsible
                      collapsedSize={0}
                      onResize={(size) => onEditorCollapsed?.(size.asPercentage === 0)}>
                      <div className="h-full overflow-hidden rounded-lg border border-border bg-card">
                        {editor}
                      </div>
                    </ResizablePanel>

                    <ResizableHandle withHandle />

                    {/* Lower-right — Test cases / Results */}
                    <ResizablePanel
                      id="tests"
                      panelRef={testsRef}
                      defaultSize={40}
                      minSize={8}
                      collapsible
                      collapsedSize={0}
                      onResize={(size) => {
                        const pct = size.asPercentage;
                        const prev = prevTestsPct.current;
                        prevTestsPct.current = pct;
                        onTestsCollapsed?.(pct === 0);
                        if (pct > 0 && pct <= 8 && prev > 8) {
                          testsRef.current?.collapse();
                        }
                      }}>
                      <div className="h-full overflow-hidden rounded-lg border border-border bg-card">
                        {testPanel}
                      </div>
                    </ResizablePanel>
                  </ResizablePanelGroup>
                </div>
                {testsCollapsed && collapsedTestContent && (
                  <div className="flex-shrink-0 h-9 rounded-lg border border-border bg-card overflow-hidden">
                    {collapsedTestContent}
                  </div>
                )}
              </div>
            </ResizablePanel>
          </ResizablePanelGroup>
        </div>
      </div>

      {/* Mobile: stacked layout */}
      <div className="flex flex-col gap-2 md:hidden h-full overflow-auto">
        <div className="rounded-lg border border-border bg-card">
          {leftPanel}
        </div>
        <div className="min-h-[50vh] rounded-lg border border-border bg-card overflow-hidden">
          {editor}
        </div>
        <div className="rounded-lg border border-border bg-card">
          {testPanel}
        </div>
      </div>
    </PageLayout>
  );
}

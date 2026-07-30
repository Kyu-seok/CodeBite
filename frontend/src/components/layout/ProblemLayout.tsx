import { type ReactNode, type RefObject, useState } from 'react';
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

// Panel snaps to these sizes when collapsed — just enough to render the icon/tab strip
const LEFT_COLLAPSED_SIZE = 4;
const TESTS_COLLAPSED_SIZE = 6;
// Dragging below these thresholds triggers a snap to collapsedSize on release
const LEFT_MIN_SIZE = 15;
const TESTS_MIN_SIZE = 10;

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
  /** Content to render inside the panel when it is collapsed to strip size */
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
 * - Left and test panels snap to a thin strip when dragged below their threshold
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

  const [leftSize, setLeftSize] = useState(50);
  const [testsSize, setTestsSize] = useState(40);

  const leftCollapsed = leftSize <= LEFT_COLLAPSED_SIZE;
  const testsCollapsed = testsSize <= TESTS_COLLAPSED_SIZE;

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
      <div className="hidden md:flex h-full">
        <ResizablePanelGroup orientation="horizontal" id="problem-h" groupRef={hGroupRef}>
          {/* Left — Description */}
          <ResizablePanel
            id="left"
            panelRef={leftRef}
            defaultSize={50}
            minSize={LEFT_MIN_SIZE}
            collapsible
            collapsedSize={LEFT_COLLAPSED_SIZE}
            onResize={(size) => {
              const pct = size.asPercentage;
              setLeftSize(pct);
              onLeftCollapsed?.(pct <= LEFT_COLLAPSED_SIZE);
            }}>
            <div className={cn(
              'h-full rounded-lg border border-border bg-card',
              leftCollapsed ? 'overflow-hidden' : 'overflow-auto',
            )}>
              {leftCollapsed ? collapsedLeftContent : leftPanel}
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
                minSize={TESTS_MIN_SIZE}
                collapsible
                collapsedSize={TESTS_COLLAPSED_SIZE}
                onResize={(size) => {
                  const pct = size.asPercentage;
                  setTestsSize(pct);
                  onTestsCollapsed?.(pct <= TESTS_COLLAPSED_SIZE);
                }}>
                <div className="h-full overflow-hidden rounded-lg border border-border bg-card">
                  {testsCollapsed ? collapsedTestContent : testPanel}
                </div>
              </ResizablePanel>
            </ResizablePanelGroup>
          </ResizablePanel>
        </ResizablePanelGroup>
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

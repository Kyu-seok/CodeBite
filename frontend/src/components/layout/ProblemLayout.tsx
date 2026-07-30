import { type ReactNode, type RefObject, useRef, useState } from 'react';
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

// react-resizable-panels interprets number props as PIXELS, not percentages.
// All size constraints must be passed as "N%" strings.
const LEFT_COLLAPSED_PCT = 4;    // percentage for comparisons
const TESTS_COLLAPSED_PCT = 6;   // percentage for comparisons
const LEFT_COLLAPSED_SIZE = `${LEFT_COLLAPSED_PCT}%`;   // string for panel props
const TESTS_COLLAPSED_SIZE = `${TESTS_COLLAPSED_PCT}%`; // string for panel props

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
  /** Content to render inside the panel when it is at minimum (strip) size */
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
 * - Left and test panels have a hard drag floor at strip size (cannot drag past it)
 * - Right and editor panels are fully collapsible to 0% via buttons only
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

  // Track last expanded sizes so buttons can restore after snapping to strip.
  const prevExpandedLeftSize = useRef(50);
  const prevExpandedTestsSize = useRef(40);

  const leftCollapsed = leftSize <= LEFT_COLLAPSED_PCT;
  const testsCollapsed = testsSize <= TESTS_COLLAPSED_PCT;

  if (resetLayoutRef) {
    resetLayoutRef.current = () => {
      rightRef.current?.expand();
      editorRef.current?.expand();
      hGroupRef.current?.setLayout({ left: 50, right: 50 });
      vGroupRef.current?.setLayout({ editor: 60, tests: 40 });
    };
  }

  if (panelFunctionsRef) {
    panelFunctionsRef.current = {
      // Left/tests use resize() with % strings — they have a hard minSize floor.
      collapseLeft: () => leftRef.current?.resize(LEFT_COLLAPSED_SIZE),
      expandLeft: () => leftRef.current?.resize(`${prevExpandedLeftSize.current}%`),
      // Right/editor are collapsible to 0%.
      collapseRight: () => rightRef.current?.collapse(),
      expandRight: () => rightRef.current?.expand(),
      collapseEditor: () => editorRef.current?.collapse(),
      expandEditor: () => editorRef.current?.expand(),
      collapseTests: () => testsRef.current?.resize(TESTS_COLLAPSED_SIZE),
      expandTests: () => testsRef.current?.resize(`${prevExpandedTestsSize.current}%`),
    };
  }

  return (
    <PageLayout variant="workspace" className={cn('px-2 pb-2', className)}>
      {/* Desktop: resizable panels */}
      <div className="hidden md:flex h-full">
        <ResizablePanelGroup orientation="horizontal" id="problem-h" groupRef={hGroupRef}>
          {/* Left — Description. Hard stop at LEFT_COLLAPSED_SIZE (no collapsible). */}
          <ResizablePanel
            id="left"
            panelRef={leftRef}
            defaultSize={50}
            minSize={LEFT_COLLAPSED_SIZE}
            onResize={(size) => {
              const pct = size.asPercentage;
              if (pct > LEFT_COLLAPSED_PCT) prevExpandedLeftSize.current = pct;
              setLeftSize(pct);
              onLeftCollapsed?.(pct <= LEFT_COLLAPSED_PCT);
            }}>
            <div className={cn(
              'h-full rounded-lg border border-border bg-card',
              leftCollapsed ? 'overflow-hidden' : 'overflow-auto',
            )}>
              {leftCollapsed ? collapsedLeftContent : leftPanel}
            </div>
          </ResizablePanel>

          <ResizableHandle withHandle />

          {/* Right — Editor + Test panel. Fully collapsible to 0% via button. */}
          <ResizablePanel
            id="right"
            panelRef={rightRef}
            defaultSize={50}
            minSize="20%"
            collapsible
            collapsedSize="0%"
            onResize={(size) => onRightCollapsed?.(size.asPercentage === 0)}>
            <ResizablePanelGroup orientation="vertical" id="problem-v" groupRef={vGroupRef}>
              {/* Upper-right — Editor. Fully collapsible to 0% via button. */}
              <ResizablePanel
                id="editor"
                panelRef={editorRef}
                defaultSize={60}
                minSize="20%"
                collapsible
                collapsedSize="0%"
                onResize={(size) => onEditorCollapsed?.(size.asPercentage === 0)}>
                <div className="h-full overflow-hidden rounded-lg border border-border bg-card">
                  {editor}
                </div>
              </ResizablePanel>

              <ResizableHandle withHandle />

              {/* Lower-right — Tests. Hard stop at TESTS_COLLAPSED_SIZE (no collapsible). */}
              <ResizablePanel
                id="tests"
                panelRef={testsRef}
                defaultSize={40}
                minSize={TESTS_COLLAPSED_SIZE}
                onResize={(size) => {
                  const pct = size.asPercentage;
                  if (pct > TESTS_COLLAPSED_PCT) prevExpandedTestsSize.current = pct;
                  setTestsSize(pct);
                  onTestsCollapsed?.(pct <= TESTS_COLLAPSED_PCT);
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

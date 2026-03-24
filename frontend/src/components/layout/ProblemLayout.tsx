import { type ReactNode } from "react"
import {
  ResizablePanelGroup,
  ResizablePanel,
  ResizableHandle,
} from "@/components/ui/Resizable"
import { PageLayout } from "./PageLayout"
import { cn } from "@/lib/utils"

interface ProblemLayoutProps {
  /** Left panel: problem description, examples, constraints */
  description: ReactNode
  /** Upper-right panel: code editor with language selector */
  editor: ReactNode
  /** Lower-right panel: test cases, run/submit results */
  testPanel: ReactNode
  className?: string
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
 * - Horizontal split: description | editor+tests (default 50/50)
 * - Vertical split on right: editor | tests (default 60/40)
 * - All panels resizable with drag handles
 * - Falls back to stacked layout on small screens
 */
export function ProblemLayout({
  description,
  editor,
  testPanel,
  className,
}: ProblemLayoutProps) {
  return (
    <PageLayout variant="workspace" className={cn("p-2", className)}>
      {/* Desktop: resizable panels */}
      <div className="hidden md:flex h-full">
        <ResizablePanelGroup orientation="horizontal" id="problem-h">
          {/* Left — Description */}
          <ResizablePanel defaultSize={50} minSize={25}>
            <div className="h-full overflow-auto rounded-lg border border-border bg-card">
              {description}
            </div>
          </ResizablePanel>

          <ResizableHandle withHandle />

          {/* Right — Editor + Test panel */}
          <ResizablePanel defaultSize={50} minSize={20}>
            <ResizablePanelGroup orientation="vertical" id="problem-v">
              {/* Upper-right — Editor */}
              <ResizablePanel defaultSize={60} minSize={20}>
                <div className="h-full overflow-hidden rounded-lg border border-border bg-card">
                  {editor}
                </div>
              </ResizablePanel>

              <ResizableHandle withHandle />

              {/* Lower-right — Test cases / Results */}
              <ResizablePanel defaultSize={40} minSize={15}>
                <div className="h-full overflow-auto rounded-lg border border-border bg-card">
                  {testPanel}
                </div>
              </ResizablePanel>
            </ResizablePanelGroup>
          </ResizablePanel>
        </ResizablePanelGroup>
      </div>

      {/* Mobile: stacked layout */}
      <div className="flex flex-col gap-2 md:hidden h-full overflow-auto">
        <div className="rounded-lg border border-border bg-card">
          {description}
        </div>
        <div className="min-h-[50vh] rounded-lg border border-border bg-card overflow-hidden">
          {editor}
        </div>
        <div className="rounded-lg border border-border bg-card">
          {testPanel}
        </div>
      </div>
    </PageLayout>
  )
}

import { forwardRef, type ComponentProps } from "react"
import {
  Panel,
  Group,
  Separator,
} from "react-resizable-panels"
import { cn } from "@/lib/utils"

/* ── ResizablePanelGroup ── */

type ResizablePanelGroupProps = ComponentProps<typeof Group>

function ResizablePanelGroup({
  className,
  ...props
}: ResizablePanelGroupProps) {
  return (
    <Group
      className={cn("flex h-full w-full", className)}
      {...props}
    />
  )
}

/* ── ResizablePanel ── */

type ResizablePanelProps = ComponentProps<typeof Panel>

const ResizablePanel = Panel

/* ── ResizableHandle ── */

interface ResizableHandleProps
  extends Omit<ComponentProps<typeof Separator>, "children"> {
  withHandle?: boolean
}

const ResizableHandle = forwardRef<HTMLDivElement, ResizableHandleProps>(
  ({ className, withHandle = false, ...props }, _ref) => (
    <Separator
      className={cn(
        "relative flex w-px items-center justify-center bg-border after:absolute after:inset-y-0 after:left-1/2 after:w-1 after:-translate-x-1/2 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 aria-[orientation=horizontal]:h-px aria-[orientation=horizontal]:w-full aria-[orientation=horizontal]:after:left-0 aria-[orientation=horizontal]:after:h-1 aria-[orientation=horizontal]:after:w-full aria-[orientation=horizontal]:after:-translate-y-1/2 aria-[orientation=horizontal]:after:translate-x-0 [&[aria-orientation=horizontal]>div]:rotate-90",
        className
      )}
      {...props}
    >
      {withHandle && (
        <div className="z-10 flex h-4 w-3 items-center justify-center rounded-sm border border-border bg-border">
          <svg
            width="6"
            height="10"
            viewBox="0 0 6 10"
            fill="none"
            className="text-muted-foreground"
          >
            <circle cx="1" cy="2" r="0.75" fill="currentColor" />
            <circle cx="1" cy="5" r="0.75" fill="currentColor" />
            <circle cx="1" cy="8" r="0.75" fill="currentColor" />
            <circle cx="5" cy="2" r="0.75" fill="currentColor" />
            <circle cx="5" cy="5" r="0.75" fill="currentColor" />
            <circle cx="5" cy="8" r="0.75" fill="currentColor" />
          </svg>
        </div>
      )}
    </Separator>
  )
)
ResizableHandle.displayName = "ResizableHandle"

export {
  ResizablePanelGroup,
  ResizablePanel,
  ResizableHandle,
}
export type {
  ResizablePanelGroupProps,
  ResizablePanelProps,
  ResizableHandleProps,
}

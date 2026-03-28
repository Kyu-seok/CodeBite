import { forwardRef, type ComponentProps } from 'react';
import { Panel, Group, Separator } from 'react-resizable-panels';
import { cn } from '@/lib/utils';

/* ── ResizablePanelGroup ── */

type ResizablePanelGroupProps = ComponentProps<typeof Group>;

function ResizablePanelGroup({
  className,
  ...props
}: ResizablePanelGroupProps) {
  return <Group className={cn('flex h-full w-full', className)} {...props} />;
}

/* ── ResizablePanel ── */

type ResizablePanelProps = ComponentProps<typeof Panel>;

const ResizablePanel = Panel;

/* ── ResizableHandle ── */

interface ResizableHandleProps extends Omit<
  ComponentProps<typeof Separator>,
  'children'
> {
  withHandle?: boolean;
}

const ResizableHandle = forwardRef<HTMLDivElement, ResizableHandleProps>(
  ({ className, withHandle = false, ...props }, _ref) => (
    <Separator
      className={cn(
        'relative flex w-1 items-center justify-center bg-transparent hover:bg-accent-500 transition-colors after:absolute after:inset-y-0 after:left-1/2 after:w-2 after:-translate-x-1/2 focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring focus-visible:ring-offset-1 aria-[orientation=horizontal]:h-1 aria-[orientation=horizontal]:w-full aria-[orientation=horizontal]:after:left-0 aria-[orientation=horizontal]:after:h-2 aria-[orientation=horizontal]:after:w-full aria-[orientation=horizontal]:after:-translate-y-1/2 aria-[orientation=horizontal]:after:translate-x-0 [&[aria-orientation=horizontal]>div]:rotate-90',
        className,
      )}
      {...props}>
      {withHandle && (
        <div className="z-10 flex h-8 w-0.5 items-center justify-center rounded-full border border-border bg-border">
          {/* <div className="h-2.5 w-px bg-muted-foreground rounded-full" /> */}
        </div>
        // <div className="z-10 flex h-4 w-3 items-center justify-center rounded-full border border-border bg-border">
        //   {/* <div className="h-2.5 w-px bg-muted-foreground rounded-full" /> */}
        // </div>
      )}
    </Separator>
  ),
);
ResizableHandle.displayName = 'ResizableHandle';

export { ResizablePanelGroup, ResizablePanel, ResizableHandle };
export type {
  ResizablePanelGroupProps,
  ResizablePanelProps,
  ResizableHandleProps,
};

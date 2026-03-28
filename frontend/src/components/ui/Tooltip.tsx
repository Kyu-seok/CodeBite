import {
  createContext,
  forwardRef,
  useContext,
  useState,
  useRef,
  useCallback,
  useEffect,
  type ReactNode,
  type HTMLAttributes,
} from 'react';
import { createPortal } from 'react-dom';
import { cn } from '@/lib/utils';

/* ── Context ── */

interface TooltipContextValue {
  open: boolean;
  setOpen: (open: boolean) => void;
  triggerRect: DOMRect | null;
  setTriggerRect: (rect: DOMRect | null) => void;
}

const TooltipContext = createContext<TooltipContextValue | null>(null);

function useTooltipContext() {
  const ctx = useContext(TooltipContext);
  if (!ctx) throw new Error('Tooltip components must be used within <Tooltip>');
  return ctx;
}

/* ── TooltipProvider (no-op, for API compat) ── */

function TooltipProvider({ children }: { children: ReactNode }) {
  return <>{children}</>;
}

/* ── Tooltip ── */

function Tooltip({ children }: { children: ReactNode }) {
  const [open, setOpen] = useState(false);
  const [triggerRect, setTriggerRect] = useState<DOMRect | null>(null);

  return (
    <TooltipContext.Provider value={{ open, setOpen, triggerRect, setTriggerRect }}>
      {children}
    </TooltipContext.Provider>
  );
}

/* ── TooltipTrigger ── */

interface TooltipTriggerProps extends HTMLAttributes<HTMLDivElement> {
  asChild?: boolean;
}

const TooltipTrigger = forwardRef<HTMLDivElement, TooltipTriggerProps>(
  ({ children, asChild: _, className, ...props }, ref) => {
    const { setOpen, setTriggerRect } = useTooltipContext();
    const timeoutRef = useRef<ReturnType<typeof setTimeout>>(undefined);
    const innerRef = useRef<HTMLDivElement>(null);

    const handleEnter = useCallback(() => {
      timeoutRef.current = setTimeout(() => {
        const el = innerRef.current;
        if (el) setTriggerRect(el.getBoundingClientRect());
        setOpen(true);
      }, 300);
    }, [setOpen, setTriggerRect]);

    const handleLeave = useCallback(() => {
      clearTimeout(timeoutRef.current);
      setOpen(false);
    }, [setOpen]);

    return (
      <div
        ref={(node) => {
          (innerRef as React.MutableRefObject<HTMLDivElement | null>).current = node;
          if (typeof ref === 'function') ref(node);
          else if (ref) (ref as React.MutableRefObject<HTMLDivElement | null>).current = node;
        }}
        className={cn('inline-flex', className)}
        onMouseEnter={handleEnter}
        onMouseLeave={handleLeave}
        onFocus={handleEnter}
        onBlur={handleLeave}
        {...props}
      >
        {children}
      </div>
    );
  },
);
TooltipTrigger.displayName = 'TooltipTrigger';

/* ── TooltipContent ── */

type Side = 'top' | 'bottom' | 'left' | 'right';

interface TooltipContentProps extends HTMLAttributes<HTMLDivElement> {
  side?: Side;
  sideOffset?: number;
}

function getPosition(rect: DOMRect, side: Side, offset: number) {
  switch (side) {
    case 'top':
      return { top: rect.top - offset, left: rect.left + rect.width / 2, transform: 'translate(-50%, -100%)' };
    case 'bottom':
      return { top: rect.bottom + offset, left: rect.left + rect.width / 2, transform: 'translate(-50%, 0)' };
    case 'left':
      return { top: rect.top + rect.height / 2, left: rect.left - offset, transform: 'translate(-100%, -50%)' };
    case 'right':
      return { top: rect.top + rect.height / 2, left: rect.right + offset, transform: 'translate(0, -50%)' };
  }
}

const TooltipContent = forwardRef<HTMLDivElement, TooltipContentProps>(
  ({ className, side = 'bottom', sideOffset = 6, children, ...props }, ref) => {
    const { open, triggerRect } = useTooltipContext();
    const [visible, setVisible] = useState(false);

    useEffect(() => {
      if (open) {
        const frame = requestAnimationFrame(() => setVisible(true));
        return () => cancelAnimationFrame(frame);
      } else {
        setVisible(false);
      }
    }, [open]);

    if (!open || !triggerRect) return null;

    const pos = getPosition(triggerRect, side, sideOffset);

    return createPortal(
      <div
        ref={ref}
        role="tooltip"
        style={{
          position: 'fixed',
          top: pos.top,
          left: pos.left,
          transform: pos.transform,
          pointerEvents: 'none',
        }}
        className={cn(
          'z-[9999] whitespace-nowrap rounded-md bg-foreground px-2.5 py-1 text-xs text-background shadow-md transition-opacity duration-150',
          visible ? 'opacity-100' : 'opacity-0',
          className,
        )}
        {...props}
      >
        {children}
      </div>,
      document.body,
    );
  },
);
TooltipContent.displayName = 'TooltipContent';

export { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider };

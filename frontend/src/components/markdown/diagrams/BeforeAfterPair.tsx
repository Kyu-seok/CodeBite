import type { ReactNode } from "react";

interface BeforeAfterPairProps {
  before: ReactNode;
  after: ReactNode;
  /**
   * Stack the two diagrams, the arrow pointing down, until the container is
   * wide enough (42rem) for both side by side. For diagrams that scale with
   * their box and turn unreadable at half a description pane's width.
   */
  stackWhenNarrow?: boolean;
}

/**
 * Renders two diagrams side-by-side with a hollow right-pointing arrow
 * between them — the LeetCode "before / after" convention used for
 * transformation problems (invert tree, rotate matrix, MST, etc.).
 *
 * On narrow viewports the pair wraps to a stacked layout and the arrow
 * keeps pointing right (acceptable on mobile; vertical re-orientation is
 * a future polish if it actually bothers anyone).
 */
export function BeforeAfterPair({ before, after, stackWhenNarrow = false }: BeforeAfterPairProps) {
  if (stackWhenNarrow) {
    return (
      <div className="@container my-4">
        <div className="flex flex-col items-center gap-3 @2xl:flex-row">
          <div className="w-full min-w-0 @2xl:flex-1">{before}</div>
          <TransformArrow className="rotate-90 @2xl:rotate-0" />
          <div className="w-full min-w-0 @2xl:flex-1">{after}</div>
        </div>
      </div>
    );
  }
  return (
    <div className="my-4 flex flex-wrap items-center justify-center gap-3">
      <div className="flex-1 min-w-0">{before}</div>
      <TransformArrow />
      <div className="flex-1 min-w-0">{after}</div>
    </div>
  );
}

function TransformArrow({ className = "" }: { className?: string }) {
  return (
    <svg
      viewBox="0 0 40 40"
      width={32}
      height={32}
      className={`shrink-0 text-foreground/70 ${className}`}
      aria-hidden
    >
      <path
        d="M3 16 L22 16 L22 8 L37 20 L22 32 L22 24 L3 24 Z"
        fill="none"
        stroke="currentColor"
        strokeWidth={1.8}
        strokeLinejoin="round"
      />
    </svg>
  );
}

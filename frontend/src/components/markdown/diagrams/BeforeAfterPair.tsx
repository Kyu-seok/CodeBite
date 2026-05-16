import type { ReactNode } from "react";

interface BeforeAfterPairProps {
  before: ReactNode;
  after: ReactNode;
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
export function BeforeAfterPair({ before, after }: BeforeAfterPairProps) {
  return (
    <div className="my-4 flex flex-wrap items-center justify-center gap-3">
      <div className="flex-1 min-w-0">{before}</div>
      <TransformArrow />
      <div className="flex-1 min-w-0">{after}</div>
    </div>
  );
}

function TransformArrow() {
  return (
    <svg
      viewBox="0 0 40 40"
      width={32}
      height={32}
      className="shrink-0 text-foreground/70"
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

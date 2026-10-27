import { useTranslation } from "react-i18next";
import { cn } from "@/lib/utils";

const SIZES = {
  /** Beside a line of 12px text. */
  xs: "h-3.5 w-3.5 border-2",
  /** Inside a panel or list. */
  sm: "h-5 w-5 border-2",
  /** A whole page or pane loading. */
  md: "h-8 w-8 border-4",
} as const;

interface SpinnerProps {
  /** Set false when a nearby live region already announces the wait, so screen readers hear it once. */
  announce?: boolean;
  size?: keyof typeof SIZES;
  /** Overrides the wrapper's centring and padding, e.g. `p-0` for an inline spinner. */
  className?: string;
}

/**
 * The one loading spinner. Under reduced motion it turns slowly instead of stopping, so a
 * standalone wait still reads as in progress; where a ticking clock or text already shows
 * progress, hide it (`motion-reduce:hidden`) or pass `announce={false}`.
 */
export default function Spinner({ announce = true, size = "md", className }: SpinnerProps) {
  const { t } = useTranslation("common");
  return (
    <div
      {...(announce ? { role: "status", "aria-label": t("label.loading") } : { "aria-hidden": true })}
      className={cn("flex items-center justify-center p-8", className)}>
      <div
        aria-hidden
        className={cn(
          "shrink-0 animate-spin rounded-full border-muted-foreground/30 border-t-accent-500 motion-reduce:[animation-duration:2.5s]",
          SIZES[size],
        )}
      />
    </div>
  );
}

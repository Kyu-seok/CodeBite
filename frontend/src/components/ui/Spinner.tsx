import { useTranslation } from "react-i18next";

interface SpinnerProps {
  /** Set false when a nearby live region already announces the wait, so screen readers hear it once. */
  announce?: boolean;
}

export default function Spinner({ announce = true }: SpinnerProps) {
  const { t } = useTranslation("common");
  return (
    <div
      {...(announce ? { role: "status", "aria-label": t("label.loading") } : { "aria-hidden": true })}
      className="flex justify-center items-center p-8">
      <div aria-hidden className="h-8 w-8 border-4 border-muted-foreground/30 border-t-accent-500 rounded-full animate-spin" />
    </div>
  );
}

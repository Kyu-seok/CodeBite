import { useTranslation } from "react-i18next";
import { Button } from "@/components/ui/Button";

/**
 * What a card or page shows when its request failed, in place of an empty state that
 * would claim there is nothing there (PRODUCT.md principle 2).
 */
export default function LoadError({ message, onRetry }: { message?: string; onRetry?: () => void }) {
  const { t } = useTranslation("common");
  return (
    <div role="alert" className="flex flex-col items-center justify-center gap-3 py-6 text-center">
      <p className="text-sm text-muted-foreground">{message ?? t("loadError.message")}</p>
      {onRetry && (
        <Button size="sm" variant="outline" onClick={onRetry}>
          {t("loadError.retry")}
        </Button>
      )}
    </div>
  );
}

/**
 * The one-line form of LoadError: a bordered notice with Try again, for a part of a page
 * (a filter row, a progress bar) whose request failed while the rest still shows.
 */
export function InlineLoadError({ message, onRetry }: { message: string; onRetry: () => void }) {
  const { t } = useTranslation("common");
  return (
    <div role="alert" className="mb-4 flex flex-wrap items-center gap-3 rounded-lg border border-border bg-card p-4 text-sm">
      <span className="text-error-700 dark:text-error-400">{message}</span>
      <Button variant="outline" size="sm" onClick={onRetry}>
        {t("loadError.retry")}
      </Button>
    </div>
  );
}

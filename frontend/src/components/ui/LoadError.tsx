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

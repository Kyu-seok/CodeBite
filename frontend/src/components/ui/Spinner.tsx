import { useTranslation } from "react-i18next";

export default function Spinner() {
  const { t } = useTranslation("common");
  return (
    <div role="status" aria-label={t("label.loading")} className="flex justify-center items-center p-8">
      <div aria-hidden className="h-8 w-8 border-4 border-muted-foreground/30 border-t-accent-500 rounded-full animate-spin" />
    </div>
  );
}

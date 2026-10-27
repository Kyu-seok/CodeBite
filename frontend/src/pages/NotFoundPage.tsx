import { useEffect } from "react";
import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { buttonVariants } from "@/components/ui/Button";

export default function NotFoundPage() {
  const { t } = useTranslation("auth");

  useEffect(() => {
    document.title = t("notFound.title");
  }, [t]);

  return (
    <div className="flex min-h-[60vh] flex-col items-center justify-center px-4 text-center">
      <p aria-hidden className="mb-2 font-mono text-6xl font-bold tabular-nums text-muted-foreground">
        {t("notFound.code")}
      </p>
      <h1 className="mb-6 text-lg font-semibold text-foreground">{t("notFound.message")}</h1>
      <Link to="/problems" className={buttonVariants({ variant: "secondary" })}>
        {t("notFound.goToProblems")}
      </Link>
    </div>
  );
}

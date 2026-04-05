import { Link } from "react-router-dom";
import { useTranslation } from "react-i18next";

export default function NotFoundPage() {
  const { t } = useTranslation("auth");
  return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center">
      <h1 className="text-6xl font-bold text-gray-300 mb-4">{t("notFound.code")}</h1>
      <p className="text-gray-600 mb-6">{t("notFound.message")}</p>
      <Link to="/problems" className="text-blue-600 hover:underline">
        {t("notFound.goToProblems")}
      </Link>
    </div>
  );
}

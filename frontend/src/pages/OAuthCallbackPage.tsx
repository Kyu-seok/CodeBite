import { useEffect, useRef, useState } from "react";
import { Link, useNavigate, useParams, useSearchParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { useAuth } from "../context/AuthContext";
import Spinner from "@/components/ui/Spinner";
import { buttonVariants } from "@/components/ui/Button";

export default function OAuthCallbackPage() {
  const { t } = useTranslation("auth");
  const { provider } = useParams<{ provider: string }>();
  const [searchParams] = useSearchParams();
  const { loginWithOAuth } = useAuth();
  const navigate = useNavigate();
  const [error, setError] = useState("");
  const calledRef = useRef(false);

  const code = searchParams.get("code");
  const state = searchParams.get("state");
  // A link without these can't finish signing in; say so instead of promising a redirect.
  const missingParams = !code || !state || !provider;

  useEffect(() => {
    document.title = t("callback.title");
  }, [t]);

  useEffect(() => {
    if (calledRef.current || !code || !state || !provider) return;
    calledRef.current = true;

    loginWithOAuth(provider, code, state)
      .then(() => {
        const returnUrl = sessionStorage.getItem("returnUrl")
        sessionStorage.removeItem("returnUrl")
        navigate(returnUrl || "/problems", { replace: true })
      })
      .catch(() => setError(t("callback.failed")));
  }, [provider, code, state, loginWithOAuth, navigate, t]);

  const message = missingParams ? t("callback.missingParams") : error;

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      {message ? (
        <div className="w-full max-w-sm rounded-xl border border-border bg-card p-6 text-center">
          <h1 className="mb-2 text-base font-semibold text-foreground">{t("callback.errorTitle")}</h1>
          <p role="alert" className="mb-5 text-sm text-error-700 dark:text-error-400">
            {message}
          </p>
          <Link to="/login" replace className={buttonVariants({ size: "sm" })}>
            {t("callback.backToLogin")}
          </Link>
        </div>
      ) : (
        <div className="flex flex-col items-center gap-4 text-center">
          <Spinner announce={false} className="p-0" />
          <p role="status" className="text-sm text-muted-foreground">
            {t("callback.completing")}
          </p>
        </div>
      )}
    </div>
  );
}

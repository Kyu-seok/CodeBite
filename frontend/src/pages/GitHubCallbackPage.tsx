import { useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { isAxiosError } from "axios";
import { completeGitHubLink, rememberedRepositoryName, startGitHubInstall } from "@/api/github";
import { Button } from "@/components/ui/Button";
import Spinner from "@/components/ui/Spinner";

function errorKey(e: unknown) {
  const status = isAxiosError(e) ? e.response?.status : undefined;
  switch (status) {
    case 400:
      return "githubLink.callback.notGranted";
    case 401:
      return "githubLink.callback.expired";
    case 403:
      return "githubLink.callback.notAuthorised";
    default:
      return "githubLink.callback.failed";
  }
}

/**
 * Where GitHub returns after the user installs the CodeBite GitHub App
 * (`?code=&installation_id=&setup_action=&state=`). Completes the GitHub Link with
 * the Solution Repository the user named, and goes back to the profile.
 */
export default function GitHubCallbackPage() {
  const { t } = useTranslation("profile");
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [requestError, setRequestError] = useState<string | null>(null);
  const [retrying, setRetrying] = useState(false);
  const [retryError, setRetryError] = useState<string | null>(null);
  const calledRef = useRef(false);
  const repositoryName = rememberedRepositoryName();

  const code = searchParams.get("code");
  const installationId = Number(searchParams.get("installation_id"));
  const state = searchParams.get("state");
  const missingParams = !code || !installationId || !state;
  const error = missingParams ? t("githubLink.callback.missingParams") : requestError;

  useEffect(() => {
    document.title = t("githubLink.callback.title");
  }, [t]);

  useEffect(() => {
    if (calledRef.current || !code || !installationId || !state) return;
    calledRef.current = true;

    completeGitHubLink(code, installationId, state)
      .then(() => navigate("/profile", { replace: true }))
      .catch((e) => setRequestError(t(errorKey(e), { repository: repositoryName })));
  }, [code, installationId, state, navigate, t, repositoryName]);

  // On success the browser leaves for GitHub; on failure (a 503 when the App isn't configured, or
  // the network) say so here instead of a button that silently does nothing.
  const retry = () => {
    setRetrying(true);
    setRetryError(null);
    startGitHubInstall(repositoryName).catch(() => {
      setRetryError(t("githubLink.startFailed"));
      setRetrying(false);
    });
  };

  if (!error) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-20">
        <Spinner announce={false} />
        <p role="status" className="text-sm text-muted-foreground">
          {t("githubLink.callback.completing")}
        </p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-lg px-4 py-16 sm:px-6">
      <div className="rounded-xl border border-border bg-card p-6">
        <h1 className="mb-3 text-base font-medium text-foreground">{t("githubLink.title")}</h1>
        <p role="alert" className="text-sm text-error-700 dark:text-error-400">
          {error}
        </p>
        {retryError && (
          <p role="alert" className="mt-2 text-sm text-error-700 dark:text-error-400">
            {retryError}
          </p>
        )}
        <div className="mt-5 flex flex-wrap gap-2">
          <Button size="sm" onClick={retry} disabled={retrying}>
            {retrying ? t("githubLink.redirecting") : t("githubLink.callback.tryAgain")}
          </Button>
          <Button size="sm" variant="outline" onClick={() => navigate("/profile")}>
            {t("githubLink.callback.backToProfile")}
          </Button>
        </div>
      </div>
    </div>
  );
}

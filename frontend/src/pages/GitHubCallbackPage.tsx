import { useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { isAxiosError } from "axios";
import { Lock } from "lucide-react";
import { completeGitHubLink, startGitHubInstall } from "@/api/github";
import type { GitHubRepositoryOption } from "@/types/github";
import { Button } from "@/components/ui/Button";
import Spinner from "@/components/ui/Spinner";

/**
 * Where GitHub returns after the user installs the CodeBite GitHub App
 * (`?code=&installation_id=&setup_action=&state=`). Completes the GitHub Link
 * and goes back to the profile.
 */
export default function GitHubCallbackPage() {
  const { t } = useTranslation("profile");
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [requestError, setRequestError] = useState<string | null>(null);
  const [repositories, setRepositories] = useState<GitHubRepositoryOption[] | null>(null);
  const calledRef = useRef(false);

  const code = searchParams.get("code");
  const installationId = Number(searchParams.get("installation_id"));
  const state = searchParams.get("state");
  const missingParams = !code || !installationId || !state;
  const error = missingParams ? t("githubLink.callback.missingParams") : requestError;

  useEffect(() => {
    if (calledRef.current || !code || !installationId || !state) return;
    calledRef.current = true;

    completeGitHubLink(code, installationId, state)
      .then((res) => {
        if (res.data.link) {
          navigate("/profile", { replace: true });
        } else {
          setRepositories(res.data.repositories);
        }
      })
      .catch((e) => {
        const status = isAxiosError(e) ? e.response?.status : undefined;
        setRequestError(
          t(
            status === 403
              ? "githubLink.callback.notAuthorised"
              : status === 401
                ? "githubLink.callback.expired"
                : "githubLink.callback.failed",
          ),
        );
      });
  }, [code, installationId, state, navigate, t]);

  if (!error && !repositories) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-20">
        <Spinner />
        <p className="text-sm text-muted-foreground">{t("githubLink.callback.completing")}</p>
      </div>
    );
  }

  return (
    <div className="mx-auto max-w-lg px-4 py-16 sm:px-6">
      <div className="rounded-xl border border-border bg-card p-6">
        <h1 className="mb-3 text-base font-medium text-foreground">{t("githubLink.title")}</h1>

        {error && <p className="text-sm text-error-500">{error}</p>}

        {repositories && (
          <>
            <p className="text-sm text-muted-foreground">
              {repositories.length === 0
                ? t("githubLink.callback.noRepository")
                : t("githubLink.callback.severalRepositories")}
            </p>
            {repositories.length > 0 && (
              <ul className="mt-3 flex flex-col gap-1 text-sm">
                {repositories.map((repo) => (
                  <li key={repo.id} className="flex items-center gap-1.5 text-foreground">
                    {repo.fullName}
                    {repo.repositoryPrivate && <Lock className="h-3 w-3 text-muted-foreground" />}
                  </li>
                ))}
              </ul>
            )}
          </>
        )}

        <div className="mt-5 flex flex-wrap gap-2">
          <Button size="sm" onClick={() => startGitHubInstall().catch(() => {})}>
            {t("githubLink.callback.tryAgain")}
          </Button>
          <Button size="sm" variant="outline" onClick={() => navigate("/profile")}>
            {t("githubLink.callback.backToProfile")}
          </Button>
        </div>
      </div>
    </div>
  );
}

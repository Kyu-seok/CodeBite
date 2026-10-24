import { useEffect, useRef, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { isAxiosError } from "axios";
import { Lock } from "lucide-react";
import { chooseGitHubRepository, completeGitHubLink, startGitHubInstall } from "@/api/github";
import type { GitHubRepositoryOption } from "@/types/github";
import { Button } from "@/components/ui/Button";
import Spinner from "@/components/ui/Spinner";

interface Choice {
  repositories: GitHubRepositoryOption[];
  selectionToken: string | null;
}

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
 * (`?code=&installation_id=&setup_action=&state=`). Completes the GitHub Link
 * and goes back to the profile. When the install granted several repositories,
 * asks which one is the Solution Repository first.
 */
export default function GitHubCallbackPage() {
  const { t } = useTranslation("profile");
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();
  const [requestError, setRequestError] = useState<string | null>(null);
  const [choice, setChoice] = useState<Choice | null>(null);
  const [selectedId, setSelectedId] = useState<number | null>(null);
  const [submitting, setSubmitting] = useState(false);
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
          setChoice({
            repositories: res.data.repositories,
            selectionToken: res.data.selectionToken,
          });
        }
      })
      .catch((e) => setRequestError(t(errorKey(e))));
  }, [code, installationId, state, navigate, t]);

  const confirmChoice = () => {
    if (!choice?.selectionToken || selectedId === null) return;
    setSubmitting(true);
    setRequestError(null);
    chooseGitHubRepository(choice.selectionToken, selectedId)
      .then(() => navigate("/profile", { replace: true }))
      .catch((e) => {
        setRequestError(t(errorKey(e)));
        setSubmitting(false);
      });
  };

  if (!error && !choice) {
    return (
      <div className="flex flex-col items-center justify-center gap-4 py-20">
        <Spinner />
        <p className="text-sm text-muted-foreground">{t("githubLink.callback.completing")}</p>
      </div>
    );
  }

  const canChoose = !!choice && choice.repositories.length > 0 && !!choice.selectionToken;

  return (
    <div className="mx-auto max-w-lg px-4 py-16 sm:px-6">
      <div className="rounded-xl border border-border bg-card p-6">
        <h1 className="mb-3 text-base font-medium text-foreground">{t("githubLink.title")}</h1>

        {choice && (
          <p className="text-sm text-muted-foreground">
            {canChoose ? t("githubLink.callback.chooseRepository") : t("githubLink.callback.noRepository")}
          </p>
        )}

        {canChoose && (
          <fieldset className="mt-3 flex flex-col gap-1" disabled={submitting}>
            <legend className="sr-only">{t("githubLink.callback.chooseRepositoryLegend")}</legend>
            {choice.repositories.map((repo) => (
              <label
                key={repo.id}
                className="flex cursor-pointer items-center gap-2 rounded-md px-2 py-1.5 text-sm text-foreground hover:bg-muted"
              >
                <input
                  type="radio"
                  name="solution-repository"
                  value={repo.id}
                  checked={selectedId === repo.id}
                  onChange={() => setSelectedId(repo.id)}
                  className="accent-primary"
                />
                <span className="truncate">{repo.fullName}</span>
                {repo.repositoryPrivate && (
                  <Lock
                    className="h-3 w-3 shrink-0 text-muted-foreground"
                    aria-label={t("githubLink.private")}
                  />
                )}
              </label>
            ))}
          </fieldset>
        )}

        {error && <p className="mt-3 text-sm text-error-500">{error}</p>}

        <div className="mt-5 flex flex-wrap gap-2">
          {canChoose ? (
            <Button size="sm" onClick={confirmChoice} disabled={selectedId === null || submitting}>
              {t("githubLink.callback.useRepository")}
            </Button>
          ) : (
            <Button size="sm" onClick={() => startGitHubInstall().catch(() => {})}>
              {t("githubLink.callback.tryAgain")}
            </Button>
          )}
          <Button size="sm" variant="outline" onClick={() => navigate("/profile")}>
            {t("githubLink.callback.backToProfile")}
          </Button>
        </div>
      </div>
    </div>
  );
}

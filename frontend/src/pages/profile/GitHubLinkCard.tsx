import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { isAxiosError } from 'axios';
import { AlertTriangle, CheckCircle2, ExternalLink, Github, History, Loader2, Lock } from 'lucide-react';
import {
  DEFAULT_REPOSITORY_NAME,
  getGitHubLinkPages,
  getGitHubLink,
  startGitHubImport,
  startGitHubInstall,
  unlinkGitHub,
} from '@/api/github';
import type { GitHubLink, GitHubRepositoryVisibility } from '@/types/github';
import { Button, buttonVariants } from '@/components/ui/Button';
import { Input } from '@/components/ui/Input';
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from '@/components/ui/Dialog';

const IMPORT_POLL_MS = 3000;
/** What GitHub accepts as a repository name, apart from "." and "..". */
const REPOSITORY_NAME = /^[A-Za-z0-9._-]{1,100}$/;

function isValidRepositoryName(name: string) {
  return REPOSITORY_NAME.test(name) && name !== '.' && name !== '..';
}

/**
 * Linking, or relinking a BROKEN link: the user names the Solution Repository and picks its
 * visibility, creates it on GitHub's prefilled new-repository page (or skips that when it already
 * exists), then installs the CodeBite GitHub App on it.
 */
function LinkSetup({ initialName = DEFAULT_REPOSITORY_NAME }: { initialName?: string }) {
  const { t } = useTranslation('profile');
  const [name, setName] = useState(initialName);
  const [visibility, setVisibility] = useState<GitHubRepositoryVisibility>('public');
  const [createUrl, setCreateUrl] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const trimmed = name.trim();

  const proceed = async () => {
    setBusy(true);
    setError(null);
    try {
      const res = await getGitHubLinkPages(trimmed, visibility);
      setCreateUrl(res.data.createRepositoryUrl);
    } catch {
      setError(t('githubLink.startFailed'));
    } finally {
      setBusy(false);
    }
  };

  const connect = async () => {
    setBusy(true);
    setError(null);
    try {
      await startGitHubInstall(trimmed);
    } catch {
      setError(t('githubLink.startFailed'));
      setBusy(false);
    }
  };

  return (
    <div className="flex flex-col gap-3">
      <p className="text-sm text-muted-foreground">{t('githubLink.description')}</p>

      {createUrl === null ? (
        <div className="flex flex-col gap-3">
          <label className="flex flex-col gap-1 text-sm">
            <span className="text-muted-foreground">{t('githubLink.setup.name')}</span>
            <Input
              value={name}
              onChange={(e) => setName(e.target.value)}
              maxLength={100}
              aria-invalid={!isValidRepositoryName(trimmed)}
            />
          </label>
          {!isValidRepositoryName(trimmed) && (
            <p className="text-xs text-error-500">{t('githubLink.setup.nameInvalid')}</p>
          )}
          <fieldset className="flex flex-wrap gap-4 text-sm">
            <legend className="sr-only">{t('githubLink.setup.visibility')}</legend>
            {(['public', 'private'] as const).map((option) => (
              <label key={option} className="flex cursor-pointer items-center gap-2 text-foreground">
                <input
                  type="radio"
                  name="solution-repository-visibility"
                  value={option}
                  checked={visibility === option}
                  onChange={() => setVisibility(option)}
                  className="accent-primary"
                />
                {t(`githubLink.setup.${option}`)}
              </label>
            ))}
          </fieldset>
          {visibility === 'private' && (
            <p className="rounded-lg bg-muted/40 px-3 py-2 text-xs text-muted-foreground">
              {t('githubLink.privateReminder')}
            </p>
          )}
          <div className="flex justify-end">
            <Button size="sm" onClick={proceed} disabled={busy || !isValidRepositoryName(trimmed)}>
              {t('githubLink.link')}
            </Button>
          </div>
        </div>
      ) : (
        <ol className="flex flex-col gap-3 text-sm">
          <li className="flex flex-col gap-2 rounded-lg border border-border px-3 py-2">
            <p className="text-foreground">{t('githubLink.setup.createStep', { repository: trimmed })}</p>
            <p className="text-xs text-muted-foreground">
              {t('githubLink.setup.createHint', { repository: trimmed })}
            </p>
            <a
              href={createUrl}
              target="_blank"
              rel="noreferrer"
              className={buttonVariants({ size: 'sm', variant: 'outline', className: 'self-start' })}
            >
              {t('githubLink.setup.create')}
              <ExternalLink className="h-3 w-3" />
            </a>
          </li>
          <li className="flex flex-col gap-2 rounded-lg border border-border px-3 py-2">
            <p className="text-foreground">{t('githubLink.setup.connectStep')}</p>
            <p className="text-xs text-muted-foreground">
              {t('githubLink.setup.connectHint', { repository: trimmed })}
            </p>
            <div className="flex flex-wrap gap-2">
              <Button size="sm" onClick={connect} disabled={busy}>
                {busy ? t('githubLink.redirecting') : t('githubLink.setup.connect')}
              </Button>
              <Button size="sm" variant="ghost" onClick={() => setCreateUrl(null)} disabled={busy}>
                {t('githubLink.setup.back')}
              </Button>
            </div>
          </li>
        </ol>
      )}

      {error && <p className="text-sm text-error-500">{error}</p>}
    </div>
  );
}

/**
 * The one-time Import of earlier Accepted submissions into this Solution Repository, each dated at
 * its original Accepted time (ADR 0002). Offered while AVAILABLE, retryable after FAILED; polls the
 * link while RUNNING.
 */
function ImportOffer({
  link,
  onChange,
}: {
  link: GitHubLink;
  onChange: (link: GitHubLink | null) => void;
}) {
  const { t } = useTranslation('profile');
  const [starting, setStarting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const state = link.importState;

  useEffect(() => {
    if (state !== 'RUNNING') return;
    const timer = window.setInterval(() => {
      getGitHubLink()
        .then((latest) => {
          if (!latest || latest.importState !== 'RUNNING') onChange(latest);
        })
        .catch(() => {});
    }, IMPORT_POLL_MS);
    return () => window.clearInterval(timer);
  }, [state, onChange]);

  const start = async () => {
    setStarting(true);
    setError(null);
    try {
      const res = await startGitHubImport();
      onChange(res.data);
    } catch (e) {
      if (isAxiosError(e) && e.response?.status === 409) {
        // Already running or done elsewhere (another tab): show the real state.
        onChange(await getGitHubLink().catch(() => link));
      } else {
        setError(t('githubLink.import.startFailed'));
      }
    } finally {
      setStarting(false);
    }
  };

  if (state === 'DONE') {
    return (
      <p className="flex items-center gap-2 text-sm text-muted-foreground">
        <CheckCircle2 className="h-4 w-4 shrink-0 text-success-500" />
        {t('githubLink.import.done')}
      </p>
    );
  }

  if (state === 'RUNNING') {
    return (
      <p className="flex items-center gap-2 text-sm text-muted-foreground">
        <Loader2 className="h-4 w-4 shrink-0 animate-spin" />
        {t('githubLink.import.running')}
      </p>
    );
  }

  const failed = state === 'FAILED';
  return (
    <div className="flex flex-col gap-2 rounded-lg border border-border bg-muted/30 px-3 py-2">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <p className="flex items-start gap-2 text-sm text-foreground">
          {failed ? (
            <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0 text-error-500" />
          ) : (
            <History className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground" />
          )}
          {failed ? t('githubLink.import.failed') : t('githubLink.import.offer')}
        </p>
        <Button size="sm" variant="outline" onClick={start} disabled={starting}>
          {starting
            ? t('githubLink.import.starting')
            : failed
              ? t('githubLink.import.retry')
              : t('githubLink.import.start')}
        </Button>
      </div>
      {error && <p className="text-sm text-error-500">{error}</p>}
    </div>
  );
}

/**
 * The user's GitHub Link: where their Accepted submissions are committed.
 * Linking is its own step even for users who signed in with GitHub (ADR 0003).
 */
export function GitHubLinkCard() {
  const { t } = useTranslation('profile');
  const { t: tc } = useTranslation('common');
  const [link, setLink] = useState<GitHubLink | null | undefined>(undefined);
  const [relinking, setRelinking] = useState(false);
  const [confirmingUnlink, setConfirmingUnlink] = useState(false);
  const [unlinking, setUnlinking] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getGitHubLink()
      .then(setLink)
      .catch(() => setLink(null));
  }, []);

  if (link === undefined) return null;

  const unlink = async () => {
    setUnlinking(true);
    setError(null);
    try {
      await unlinkGitHub();
      setConfirmingUnlink(false);
      setLink(null);
    } catch {
      setError(t('githubLink.unlinkFailed'));
      setConfirmingUnlink(false);
    } finally {
      setUnlinking(false);
    }
  };

  const broken = link?.status === 'BROKEN';

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-3 flex items-center gap-2">
        <Github className="h-4 w-4 text-muted-foreground" />
        <h3 className="text-sm font-medium text-foreground">{t('githubLink.title')}</h3>
      </div>

      {!link ? (
        <LinkSetup />
      ) : (
        <div className="flex flex-col gap-3">
          <dl className="grid grid-cols-[auto_1fr] gap-x-4 gap-y-1 text-sm">
            <dt className="text-muted-foreground">{t('githubLink.account')}</dt>
            <dd className="font-medium text-foreground">@{link.githubLogin}</dd>
            <dt className="text-muted-foreground">{t('githubLink.repository')}</dt>
            <dd className="flex min-w-0 items-center gap-1.5">
              <a
                href={link.repositoryUrl}
                target="_blank"
                rel="noreferrer"
                className="inline-flex min-w-0 items-center gap-1 font-medium text-foreground hover:underline"
              >
                <span className="truncate">{link.repositoryFullName}</span>
                <ExternalLink className="h-3 w-3 shrink-0" />
              </a>
              {link.repositoryPrivate && (
                <span className="inline-flex items-center gap-1 rounded border border-border px-1.5 text-xs text-muted-foreground">
                  <Lock className="h-3 w-3" />
                  {t('githubLink.private')}
                </span>
              )}
            </dd>
          </dl>

          {link.repositoryPrivate && !broken && (
            <p className="rounded-lg bg-muted/40 px-3 py-2 text-xs text-muted-foreground">
              {t('githubLink.privateReminder')}
            </p>
          )}

          {broken && (
            <div className="flex flex-wrap items-center justify-between gap-3 rounded-lg border border-warning-500/40 bg-warning-500/10 px-3 py-2">
              <p className="flex items-center gap-2 text-sm text-foreground">
                <AlertTriangle className="h-4 w-4 shrink-0 text-warning-500" />
                {t('githubLink.broken')}
              </p>
              {!relinking && (
                <Button size="sm" variant="outline" onClick={() => setRelinking(true)}>
                  {t('githubLink.relink')}
                </Button>
              )}
            </div>
          )}

          {broken && relinking && (
            // The same name by default; the repository may have been deleted, so it can be created again.
            <LinkSetup initialName={link.repositoryFullName.slice(link.repositoryFullName.indexOf('/') + 1)} />
          )}

          {!broken && <ImportOffer link={link} onChange={setLink} />}

          <div className="flex justify-end">
            <Dialog open={confirmingUnlink} onOpenChange={setConfirmingUnlink}>
              <DialogTrigger asChild>
                <Button size="sm" variant="ghost" className="text-muted-foreground">
                  {t('githubLink.unlink')}
                </Button>
              </DialogTrigger>
              <DialogContent className="max-w-md">
                <DialogHeader>
                  <DialogTitle>{t('githubLink.unlinkTitle')}</DialogTitle>
                  <DialogDescription>
                    {t('githubLink.unlinkDescription', { repository: link.repositoryFullName })}
                  </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                  <DialogClose asChild>
                    <Button variant="outline" disabled={unlinking}>
                      {tc('button.cancel')}
                    </Button>
                  </DialogClose>
                  <Button variant="destructive" onClick={unlink} disabled={unlinking}>
                    {unlinking ? t('githubLink.unlinking') : t('githubLink.unlinkConfirm')}
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
          </div>
        </div>
      )}

      {error && <p className="mt-3 text-sm text-error-500">{error}</p>}
    </div>
  );
}

import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { AlertTriangle, ExternalLink, Github, Lock } from 'lucide-react';
import { getGitHubLink, startGitHubInstall, unlinkGitHub } from '@/api/github';
import type { GitHubLink } from '@/types/github';
import { Button } from '@/components/ui/Button';
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

/**
 * The user's GitHub Link: where their Accepted submissions are committed.
 * Linking is its own step even for users who signed in with GitHub (ADR 0003).
 */
export function GitHubLinkCard() {
  const { t } = useTranslation('profile');
  const { t: tc } = useTranslation('common');
  const [link, setLink] = useState<GitHubLink | null | undefined>(undefined);
  const [starting, setStarting] = useState(false);
  const [confirmingUnlink, setConfirmingUnlink] = useState(false);
  const [unlinking, setUnlinking] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getGitHubLink()
      .then(setLink)
      .catch(() => setLink(null));
  }, []);

  if (link === undefined) return null;

  const install = async () => {
    setStarting(true);
    setError(null);
    try {
      await startGitHubInstall();
    } catch {
      setError(t('githubLink.startFailed'));
      setStarting(false);
    }
  };

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
        <div className="flex flex-wrap items-center justify-between gap-3">
          <p className="text-sm text-muted-foreground">{t('githubLink.description')}</p>
          <Button size="sm" onClick={install} disabled={starting}>
            {starting ? t('githubLink.redirecting') : t('githubLink.link')}
          </Button>
        </div>
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
              <Button size="sm" variant="outline" onClick={install} disabled={starting}>
                {starting ? t('githubLink.redirecting') : t('githubLink.relink')}
              </Button>
            </div>
          )}

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

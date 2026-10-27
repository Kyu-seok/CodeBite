import { useState, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';
import { getRecentSubmissions } from '@/api/profile';
import type { RecentSubmission } from '@/types/profile';
import type { Difficulty } from '@/types/problem';
import type { SubmissionStatus } from '@/types/submission';
import { CardError } from './CardError';

/** The largest whole unit that fits, e.g. "3 hours ago" / "3시간 전". */
function timeAgo(format: Intl.RelativeTimeFormat, iso: string, now: number): string {
  const mins = Math.floor((now - new Date(iso).getTime()) / 60000);
  if (mins < 60) return format.format(-mins, 'minute');
  const hours = Math.floor(mins / 60);
  if (hours < 24) return format.format(-hours, 'hour');
  const days = Math.floor(hours / 24);
  if (days < 30) return format.format(-days, 'day');
  return format.format(-Math.floor(days / 30), 'month');
}

export function RecentSubmissionsCard() {
  const { t, i18n } = useTranslation('profile');
  const [submissions, setSubmissions] = useState<RecentSubmission[]>([]);
  const [status, setStatus] = useState<'loading' | 'ready' | 'failed'>('loading');
  const [now] = useState(() => Date.now());

  const fetchSubmissions = useCallback(() => {
    getRecentSubmissions(0, 10)
      .then((res) => {
        setSubmissions(res.data.content);
        setStatus('ready');
      })
      .catch(() => setStatus('failed'));
  }, []);

  useEffect(fetchSubmissions, [fetchSubmissions]);

  const retry = () => {
    setStatus('loading');
    fetchSubmissions();
  };

  const relative = new Intl.RelativeTimeFormat(i18n.language, { numeric: 'auto', style: 'short' });

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <h2 className="mb-4 text-sm font-medium text-foreground">{t('recent.title')}</h2>

      {status === 'loading' ? (
        <Spinner size="sm" className="h-20 p-0" />
      ) : status === 'failed' ? (
        <CardError onRetry={retry} />
      ) : submissions.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">{t('recent.empty')}</p>
        </div>
      ) : (
        <ul className="space-y-0 divide-y divide-border/50">
          {submissions.map((s) => (
            <li
              key={s.id}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={s.difficulty as Difficulty} />
                <Link
                  to={`/problems/${s.problemSlug}`}
                  className="truncate rounded-sm text-sm text-foreground transition-colors hover:text-accent-700 dark:hover:text-accent-400"
                >
                  {s.problemTitle}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span className="hidden text-xs capitalize text-muted-foreground sm:block">
                  {s.language}
                </span>
                {s.runtimeMs != null && (
                  <span className="hidden font-mono text-xs tabular-nums text-muted-foreground md:block">
                    {s.runtimeMs} ms
                  </span>
                )}
                <StatusBadge status={s.status as SubmissionStatus} />
                <span className="min-w-14 text-right text-xs tabular-nums text-muted-foreground">
                  {timeAgo(relative, s.createdAt, now)}
                </span>
              </div>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}

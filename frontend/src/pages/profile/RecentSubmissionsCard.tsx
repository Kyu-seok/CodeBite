import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import StatusBadge from '@/components/ui/StatusBadge';
import { getRecentSubmissions } from '@/api/profile';
import type { RecentSubmission } from '@/types/profile';
import type { Difficulty } from '@/types/problem';
import type { SubmissionStatus } from '@/types/submission';

export function RecentSubmissionsCard() {
  const [submissions, setSubmissions] = useState<RecentSubmission[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    getRecentSubmissions(0, 10)
      .then((res) => setSubmissions(res.data.content))
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  const timeAgo = (iso: string) => {
    const diff = Date.now() - new Date(iso).getTime();
    const mins = Math.floor(diff / 60000);
    if (mins < 60) return `${mins}m ago`;
    const hours = Math.floor(mins / 60);
    if (hours < 24) return `${hours}h ago`;
    const days = Math.floor(hours / 24);
    if (days < 30) return `${days}d ago`;
    const months = Math.floor(days / 30);
    return `${months}mo ago`;
  };

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <h3 className="mb-4 text-sm font-medium text-foreground">Recent Submissions</h3>

      {loading ? (
        <div className="flex h-20 items-center justify-center">
          <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted border-t-accent" />
        </div>
      ) : submissions.length === 0 ? (
        <div className="flex h-20 items-center justify-center">
          <p className="text-sm text-muted-foreground">No submissions yet.</p>
        </div>
      ) : (
        <div className="space-y-0 divide-y divide-border/50">
          {submissions.map((s) => (
            <div
              key={s.id}
              className="flex items-center justify-between gap-4 py-2.5 first:pt-0 last:pb-0"
            >
              <div className="flex min-w-0 flex-1 items-center gap-3">
                <DifficultyBadge difficulty={s.difficulty as Difficulty} />
                <Link
                  to={`/problems/${s.problemSlug}`}
                  className="truncate text-sm text-foreground hover:text-accent transition-colors"
                >
                  {s.problemTitle}
                </Link>
              </div>

              <div className="flex shrink-0 items-center gap-3">
                <span className="hidden text-xs capitalize text-muted-foreground sm:block">
                  {s.language}
                </span>
                {s.runtimeMs != null && (
                  <span className="hidden text-xs tabular-nums text-muted-foreground md:block">
                    {s.runtimeMs} ms
                  </span>
                )}
                <StatusBadge status={s.status as SubmissionStatus} />
                <span className="w-14 text-right text-xs tabular-nums text-muted-foreground">
                  {timeAgo(s.createdAt)}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

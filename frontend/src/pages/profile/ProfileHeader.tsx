import { useTranslation } from 'react-i18next';
import type { User } from '@/types/auth';
import type { ProfileStats } from '@/types/profile';

interface ProfileHeaderProps {
  user: User;
  stats: ProfileStats;
}

export function ProfileHeader({ user, stats }: ProfileHeaderProps) {
  const { t } = useTranslation('profile');
  const d = new Date(stats.memberSince);
  const memberSince = t('header.memberSince', {
    month: d.getMonth() + 1,
    year: d.getFullYear(),
  });

  const solvedPct =
    stats.totalProblems > 0
      ? Math.round((stats.totalSolved / stats.totalProblems) * 100)
      : 0;

  return (
    <div className="rounded-xl border border-border bg-card overflow-hidden">
      {/* Accent bar */}
      <div className="h-1.5 bg-gradient-to-r from-accent to-orange-400" />

      <div className="p-6">
        <div className="flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
          {/* Left: avatar + info */}
          <div className="flex items-center gap-4">
            {user.avatarUrl ? (
              <img
                src={user.avatarUrl}
                alt={user.username}
                className="h-16 w-16 rounded-full ring-2 ring-border ring-offset-2 ring-offset-card"
              />
            ) : (
              <div className="flex h-16 w-16 items-center justify-center rounded-full bg-accent text-2xl font-bold text-white ring-2 ring-border ring-offset-2 ring-offset-card">
                {user.username.charAt(0).toUpperCase()}
              </div>
            )}
            <div>
              <h1 className="text-xl font-bold text-foreground">{user.username}</h1>
              <p className="text-xs text-muted-foreground">{memberSince}</p>
              <div className="mt-1.5 flex items-center gap-1.5">
                <span className="text-sm font-semibold text-accent">
                  {stats.totalSolved}
                </span>
                <span className="text-sm text-muted-foreground">
                  {t('header.solved', { total: stats.totalProblems })}
                </span>
                <span className="ml-1 rounded-full bg-accent/10 px-2 py-0.5 text-xs font-medium text-accent">
                  {solvedPct}%
                </span>
              </div>
            </div>
          </div>

          {/* Right: stat counters */}
          <div className="flex gap-6 sm:gap-8">
            <StatCounter
              value={stats.currentStreak}
              label={t('header.currentStreak')}
              icon={
                <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" />
                </svg>
              }
            />
            <StatCounter
              value={stats.longestStreak}
              label={t('header.bestStreak')}
              icon={
                <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" />
                </svg>
              }
            />
            <StatCounter
              value={stats.totalActiveDays}
              label={t('header.activeDays')}
              icon={
                <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="4" width="18" height="18" rx="2" ry="2" />
                  <line x1="16" y1="2" x2="16" y2="6" />
                  <line x1="8" y1="2" x2="8" y2="6" />
                  <line x1="3" y1="10" x2="21" y2="10" />
                </svg>
              }
            />
          </div>
        </div>
      </div>
    </div>
  );
}

function StatCounter({
  value,
  label,
  icon,
}: {
  value: number;
  label: string;
  icon: React.ReactNode;
}) {
  return (
    <div className="flex flex-col items-center gap-0.5 text-center">
      <div className="flex items-center gap-1.5 text-muted-foreground">
        {icon}
      </div>
      <span className="text-2xl font-bold tabular-nums text-foreground">{value}</span>
      <span className="text-[11px] text-muted-foreground whitespace-nowrap">{label}</span>
    </div>
  );
}

import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { ChevronDown, ChevronUp } from 'lucide-react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { getOverviewStats, getDailySubmissions, getProblemAnalytics, getRecentSubmissions } from '@/api/admin';
import type { OverviewStats, DailySubmission, ProblemAnalytics, AdminRecentSubmission } from '@/types/admin';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import type { Difficulty } from '@/types/problem';
import type { SubmissionStatus } from '@/types/submission';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';
import LoadError from '@/components/ui/LoadError';
import { timeAgo } from './adminFormat';

type SortField = 'totalSubmissions' | 'acceptanceRate';

interface DashboardData {
  stats: OverviewStats;
  daily: DailySubmission[];
  problems: ProblemAnalytics[];
  recent: AdminRecentSubmission[];
}

export default function DashboardPage() {
  const { t, i18n } = useTranslation('admin');
  const [data, setData] = useState<DashboardData | null>(null);
  const [status, setStatus] = useState<'loading' | 'ready' | 'failed'>('loading');
  const [sortField, setSortField] = useState<SortField>('totalSubmissions');
  const [sortAsc, setSortAsc] = useState(false);

  const STAT_CARDS = [
    { key: 'totalUsers' as const, label: t('dashboard.totalUsers'), icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" />
        <path d="M22 21v-2a4 4 0 0 0-3-3.87" /><path d="M16 3.13a4 4 0 0 1 0 7.75" />
      </svg>
    )},
    { key: 'totalProblems' as const, label: t('dashboard.totalProblems'), icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
        <path d="M14 2v4a2 2 0 0 0 2 2h4" />
      </svg>
    )},
    { key: 'totalSubmissions' as const, label: t('dashboard.totalSubmissions'), icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
      </svg>
    )},
    { key: 'submissionsToday' as const, label: t('dashboard.today'), icon: (
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="12" cy="12" r="10" /><polyline points="12 6 12 12 16 14" />
      </svg>
    )},
  ];

  // A failed request is shown as a failure: zeros and "No problems yet" would claim the
  // platform is empty (PRODUCT.md principle 2).
  const fetchDashboard = useCallback(() => {
    Promise.all([
      getOverviewStats(),
      getDailySubmissions(30),
      getProblemAnalytics(),
      getRecentSubmissions(10),
    ])
      .then(([s, d, p, r]) => {
        setData({ stats: s.data, daily: d.data, problems: p.data, recent: r.data });
        setStatus('ready');
      })
      .catch(() => setStatus('failed'));
  }, []);

  useEffect(fetchDashboard, [fetchDashboard]);

  const retry = () => {
    setStatus('loading');
    fetchDashboard();
  };

  if (status === 'loading') {
    return (
      <div className="flex h-full items-center justify-center">
        <Spinner />
      </div>
    );
  }

  if (status === 'failed' || !data) {
    return (
      <div className="space-y-6 p-6">
        <h1 className="text-2xl font-bold text-foreground">{t('dashboard.title')}</h1>
        <div className="rounded-xl border border-border bg-card p-4">
          <LoadError onRetry={retry} />
        </div>
      </div>
    );
  }

  const { stats, daily, problems, recent } = data;
  const sortedProblems = [...problems].sort((a, b) =>
    sortAsc ? a[sortField] - b[sortField] : b[sortField] - a[sortField],
  );

  const handleSort = (field: SortField) => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(false);
    }
  };

  // Sortable headers follow the problem list (#36): a button in the cell, aria-sort on the cell.
  const sortHeader = (field: SortField, label: string, className: string) => {
    const active = sortField === field;
    return (
      <th scope="col" aria-sort={active ? (sortAsc ? 'ascending' : 'descending') : undefined} className={className}>
        <button
          type="button"
          onClick={() => handleSort(field)}
          className={`-mx-1 inline-flex items-center gap-1 rounded-sm px-1 transition-colors hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring ${
            active ? 'font-medium text-foreground' : ''
          }`}
        >
          {label}
          {active &&
            (sortAsc ? <ChevronUp aria-hidden className="h-3.5 w-3.5" /> : <ChevronDown aria-hidden className="h-3.5 w-3.5" />)}
        </button>
      </th>
    );
  };

  return (
    <div className="space-y-6 p-6">
      <h1 className="text-2xl font-bold text-foreground">{t('dashboard.title')}</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        {STAT_CARDS.map((card) => (
          <div key={card.key} className="rounded-xl border border-border bg-card p-4">
            <div className="flex items-center gap-3">
              <div aria-hidden className="flex h-10 w-10 items-center justify-center rounded-lg bg-accent/10 text-accent">
                {card.icon}
              </div>
              <div>
                <p className="text-2xl font-bold tabular-nums text-foreground">
                  {/* A missing figure reads as unknown, not as a confident 0. */}
                  {stats[card.key] == null ? '—' : stats[card.key].toLocaleString(i18n.language)}
                </p>
                <p className="text-xs text-muted-foreground">{card.label}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Submission Trend Chart */}
      <div className="rounded-xl border border-border bg-card p-4">
        <h2 className="mb-4 text-sm font-semibold text-foreground">{t('dashboard.submissionsChart')}</h2>
        <ResponsiveContainer width="100%" height={240}>
          <AreaChart data={daily}>
            <defs>
              <linearGradient id="colorCount" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor="var(--color-accent)" stopOpacity={0.3} />
                <stop offset="95%" stopColor="var(--color-accent)" stopOpacity={0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" stroke="var(--color-border)" />
            <XAxis
              dataKey="date"
              tick={{ fontSize: 12, fill: 'var(--color-muted-foreground)' }}
              tickFormatter={(d: string) =>
                new Date(d + 'T00:00:00').toLocaleDateString(i18n.language, { month: 'numeric', day: 'numeric' })
              }
            />
            <YAxis
              tick={{ fontSize: 12, fill: 'var(--color-muted-foreground)' }}
              allowDecimals={false}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: 'var(--color-card)',
                border: '1px solid var(--color-border)',
                borderRadius: '8px',
                fontSize: '12px',
              }}
              labelFormatter={(d) => new Date(String(d) + 'T00:00:00').toLocaleDateString(i18n.language)}
            />
            <Area
              type="monotone"
              dataKey="count"
              stroke="var(--color-accent)"
              fill="url(#colorCount)"
              strokeWidth={2}
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>

      {/* Two-column: Problem Analytics + Recent Submissions */}
      <div className="grid gap-6 lg:grid-cols-5">
        {/* Problem Analytics */}
        <div className="rounded-xl border border-border bg-card p-4 lg:col-span-3">
          <h2 className="mb-3 text-sm font-semibold text-foreground">{t('dashboard.problemAnalytics')}</h2>
          <div className="overflow-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-left text-xs text-muted-foreground">
                  <th scope="col" className="pb-2 pr-3 font-normal">{t('dashboard.problem')}</th>
                  <th scope="col" className="pb-2 pr-3 font-normal">{t('dashboard.difficulty')}</th>
                  {sortHeader('totalSubmissions', t('dashboard.submissions'), 'pb-2 pr-3 font-normal')}
                  {sortHeader('acceptanceRate', t('dashboard.acceptance'), 'pb-2 font-normal')}
                </tr>
              </thead>
              <tbody>
                {sortedProblems.map((p) => (
                  <tr key={p.id} className="border-b border-border/50 last:border-0">
                    <td className="py-2 pr-3 font-medium text-foreground">{p.title}</td>
                    <td className="py-2 pr-3">
                      <DifficultyBadge difficulty={p.difficulty as Difficulty} />
                    </td>
                    <td className="py-2 pr-3 tabular-nums text-muted-foreground">{p.totalSubmissions}</td>
                    <td className="py-2">
                      <div className="flex items-center gap-2">
                        <div aria-hidden className="h-1.5 w-16 overflow-hidden rounded-full bg-muted">
                          <div
                            className="h-full rounded-full bg-accent"
                            style={{ width: `${Math.min(p.acceptanceRate, 100)}%` }}
                          />
                        </div>
                        <span className="text-xs tabular-nums text-muted-foreground">{p.acceptanceRate}%</span>
                      </div>
                    </td>
                  </tr>
                ))}
                {sortedProblems.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      {t('dashboard.noProblems')}
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Recent Submissions */}
        <div className="rounded-xl border border-border bg-card p-4 lg:col-span-2">
          <h2 className="mb-3 text-sm font-semibold text-foreground">{t('dashboard.recentSubmissions')}</h2>
          <ul className="space-y-3">
            {recent.map((s) => (
              <li key={s.id} className="flex items-start justify-between gap-2">
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium text-foreground">{s.problemTitle}</p>
                  <p className="text-xs text-muted-foreground">
                    {s.username} &middot; {s.language}
                  </p>
                </div>
                <div className="flex shrink-0 flex-col items-end gap-1">
                  <StatusBadge status={s.status as SubmissionStatus} />
                  <span className="text-xs text-muted-foreground">
                    {timeAgo(s.createdAt, i18n.language, t('time.justNow'))}
                  </span>
                </div>
              </li>
            ))}
          </ul>
          {recent.length === 0 && (
            <p className="py-8 text-center text-sm text-muted-foreground">{t('dashboard.noSubmissions')}</p>
          )}
        </div>
      </div>
    </div>
  );
}

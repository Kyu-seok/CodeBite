import { useEffect, useState } from 'react';
import { AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { getOverviewStats, getDailySubmissions, getProblemAnalytics, getRecentSubmissions } from '@/api/admin';
import type { OverviewStats, DailySubmission, ProblemAnalytics, AdminRecentSubmission } from '@/types/admin';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import type { Difficulty } from '@/types/problem';
import type { SubmissionStatus } from '@/types/submission';
import StatusBadge from '@/components/ui/StatusBadge';
import Spinner from '@/components/ui/Spinner';

function timeAgo(dateStr: string) {
  const diff = Date.now() - new Date(dateStr).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return 'just now';
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  const days = Math.floor(hrs / 24);
  return `${days}d ago`;
}

const STAT_CARDS = [
  { key: 'totalUsers' as const, label: 'Total Users', icon: (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87" /><path d="M16 3.13a4 4 0 0 1 0 7.75" />
    </svg>
  )},
  { key: 'totalProblems' as const, label: 'Total Problems', icon: (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
      <path d="M14 2v4a2 2 0 0 0 2 2h4" />
    </svg>
  )},
  { key: 'totalSubmissions' as const, label: 'Total Submissions', icon: (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />
    </svg>
  )},
  { key: 'submissionsToday' as const, label: 'Today', icon: (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10" /><polyline points="12 6 12 12 16 14" />
    </svg>
  )},
];

export default function DashboardPage() {
  const [stats, setStats] = useState<OverviewStats | null>(null);
  const [daily, setDaily] = useState<DailySubmission[]>([]);
  const [problems, setProblems] = useState<ProblemAnalytics[]>([]);
  const [recent, setRecent] = useState<AdminRecentSubmission[]>([]);
  const [loading, setLoading] = useState(true);
  const [sortField, setSortField] = useState<'totalSubmissions' | 'acceptanceRate'>('totalSubmissions');
  const [sortAsc, setSortAsc] = useState(false);

  useEffect(() => {
    Promise.all([
      getOverviewStats(),
      getDailySubmissions(30),
      getProblemAnalytics(),
      getRecentSubmissions(10),
    ]).then(([s, d, p, r]) => {
      setStats(s.data);
      setDaily(d.data);
      setProblems(p.data);
      setRecent(r.data);
    }).finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="flex h-full items-center justify-center">
        <Spinner />
      </div>
    );
  }

  const sortedProblems = [...problems].sort((a, b) => {
    const diff = sortAsc ? a[sortField] - b[sortField] : b[sortField] - a[sortField];
    return diff;
  });

  const handleSort = (field: 'totalSubmissions' | 'acceptanceRate') => {
    if (sortField === field) {
      setSortAsc(!sortAsc);
    } else {
      setSortField(field);
      setSortAsc(false);
    }
  };

  const sortIndicator = (field: string) =>
    sortField === field ? (sortAsc ? ' \u2191' : ' \u2193') : '';

  return (
    <div className="space-y-6 p-6">
      <h1 className="text-2xl font-bold text-foreground">Dashboard</h1>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 gap-4 lg:grid-cols-4">
        {STAT_CARDS.map((card) => (
          <div key={card.key} className="rounded-xl border border-border bg-card p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-accent/10 text-accent">
                {card.icon}
              </div>
              <div>
                <p className="text-2xl font-bold text-foreground">
                  {stats?.[card.key]?.toLocaleString() ?? 0}
                </p>
                <p className="text-xs text-muted-foreground">{card.label}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Submission Trend Chart */}
      <div className="rounded-xl border border-border bg-card p-4">
        <h2 className="mb-4 text-sm font-semibold text-foreground">Submissions (Last 30 Days)</h2>
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
              tick={{ fontSize: 11, fill: 'var(--color-muted-foreground)' }}
              tickFormatter={(d: string) => {
                const date = new Date(d + 'T00:00:00');
                return `${date.getMonth() + 1}/${date.getDate()}`;
              }}
            />
            <YAxis
              tick={{ fontSize: 11, fill: 'var(--color-muted-foreground)' }}
              allowDecimals={false}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: 'var(--color-card)',
                border: '1px solid var(--color-border)',
                borderRadius: '8px',
                fontSize: '12px',
              }}
              labelFormatter={(d) => new Date(String(d) + 'T00:00:00').toLocaleDateString()}
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
          <h2 className="mb-3 text-sm font-semibold text-foreground">Problem Analytics</h2>
          <div className="overflow-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-border text-left text-xs text-muted-foreground">
                  <th className="pb-2 pr-3">Problem</th>
                  <th className="pb-2 pr-3">Difficulty</th>
                  <th
                    className="cursor-pointer pb-2 pr-3 hover:text-foreground"
                    onClick={() => handleSort('totalSubmissions')}
                  >
                    Submissions{sortIndicator('totalSubmissions')}
                  </th>
                  <th
                    className="cursor-pointer pb-2 hover:text-foreground"
                    onClick={() => handleSort('acceptanceRate')}
                  >
                    Acceptance{sortIndicator('acceptanceRate')}
                  </th>
                </tr>
              </thead>
              <tbody>
                {sortedProblems.map((p) => (
                  <tr key={p.id} className="border-b border-border/50 last:border-0">
                    <td className="py-2 pr-3 font-medium text-foreground">{p.title}</td>
                    <td className="py-2 pr-3">
                      <DifficultyBadge difficulty={p.difficulty as Difficulty} />
                    </td>
                    <td className="py-2 pr-3 text-muted-foreground">{p.totalSubmissions}</td>
                    <td className="py-2">
                      <div className="flex items-center gap-2">
                        <div className="h-1.5 w-16 overflow-hidden rounded-full bg-muted">
                          <div
                            className="h-full rounded-full bg-accent"
                            style={{ width: `${Math.min(p.acceptanceRate, 100)}%` }}
                          />
                        </div>
                        <span className="text-xs text-muted-foreground">{p.acceptanceRate}%</span>
                      </div>
                    </td>
                  </tr>
                ))}
                {sortedProblems.length === 0 && (
                  <tr>
                    <td colSpan={4} className="py-8 text-center text-muted-foreground">
                      No problems yet
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Recent Submissions */}
        <div className="rounded-xl border border-border bg-card p-4 lg:col-span-2">
          <h2 className="mb-3 text-sm font-semibold text-foreground">Recent Submissions</h2>
          <div className="space-y-3">
            {recent.map((s) => (
              <div key={s.id} className="flex items-start justify-between gap-2">
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium text-foreground">{s.problemTitle}</p>
                  <p className="text-xs text-muted-foreground">
                    {s.username} &middot; {s.language}
                  </p>
                </div>
                <div className="flex shrink-0 flex-col items-end gap-1">
                  <StatusBadge status={s.status as SubmissionStatus} />
                  <span className="text-[10px] text-muted-foreground">{timeAgo(s.createdAt)}</span>
                </div>
              </div>
            ))}
            {recent.length === 0 && (
              <p className="py-8 text-center text-sm text-muted-foreground">No submissions yet</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

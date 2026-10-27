import { useTranslation } from 'react-i18next';
import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';
import DifficultyBadge from '@/components/ui/DifficultyBadge';
import type { ProfileStats } from '@/types/profile';

interface SolveProgressCardProps {
  stats: ProfileStats;
}

// Bar and donut fills are non-text marks, so the 500 steps hold; the labels use DifficultyBadge.
const DIFFICULTIES = [
  { key: 'EASY' as const, color: '#22c55e' },
  { key: 'MEDIUM' as const, color: '#f59e0b' },
  { key: 'HARD' as const, color: '#ef4444' },
];

export function SolveProgressCard({ stats }: SolveProgressCardProps) {
  const { t } = useTranslation('profile');
  const counts = {
    EASY: { solved: stats.solvedEasy, total: stats.totalEasy },
    MEDIUM: { solved: stats.solvedMedium, total: stats.totalMedium },
    HARD: { solved: stats.solvedHard, total: stats.totalHard },
  };

  const pieData = [
    { name: 'EASY', value: stats.solvedEasy },
    { name: 'MEDIUM', value: stats.solvedMedium },
    { name: 'HARD', value: stats.solvedHard },
    { name: 'UNSOLVED', value: stats.totalProblems - stats.totalSolved },
  ];

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <h2 className="mb-4 text-sm font-medium text-foreground">{t('progress.title')}</h2>

      <div className="flex items-center gap-8">
        {/* Donut: the breakdown beside it states the same counts. */}
        <div className="relative h-36 w-36 shrink-0">
          <div aria-hidden className="h-full w-full">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={pieData}
                  cx="50%"
                  cy="50%"
                  innerRadius={42}
                  outerRadius={62}
                  dataKey="value"
                  strokeWidth={0}
                >
                  {pieData.map((entry) => (
                    <Cell
                      key={entry.name}
                      fill={
                        DIFFICULTIES.find((d) => d.key === entry.name)?.color || 'var(--border)'
                      }
                    />
                  ))}
                </Pie>
              </PieChart>
            </ResponsiveContainer>
          </div>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-2xl font-bold tabular-nums text-foreground">
              {stats.totalSolved}
            </span>
            <span className="text-xs text-muted-foreground">{t('progress.solved')}</span>
          </div>
        </div>

        {/* Breakdown */}
        <div className="flex flex-1 flex-col gap-3">
          {DIFFICULTIES.map(({ key, color }) => {
            const { solved, total } = counts[key];
            const pct = total > 0 ? (solved / total) * 100 : 0;
            return (
              <div key={key}>
                <div className="mb-1 flex items-center justify-between">
                  <DifficultyBadge difficulty={key} />
                  <span className="text-xs tabular-nums text-muted-foreground">
                    {solved} / {total}
                  </span>
                </div>
                <div aria-hidden className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                  <div
                    className="h-full rounded-full transition-all duration-500 motion-reduce:transition-none"
                    style={{ width: `${pct}%`, backgroundColor: color }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}

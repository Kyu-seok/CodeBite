import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';
import type { ProfileStats } from '@/types/profile';

interface SolveProgressCardProps {
  stats: ProfileStats;
}

const DIFFICULTIES = [
  { key: 'Easy' as const, color: '#22c55e', bg: 'bg-green-500/10', text: 'text-green-500' },
  { key: 'Medium' as const, color: '#f59e0b', bg: 'bg-amber-500/10', text: 'text-amber-500' },
  { key: 'Hard' as const, color: '#ef4444', bg: 'bg-red-500/10', text: 'text-red-500' },
];

export function SolveProgressCard({ stats }: SolveProgressCardProps) {
  const counts = {
    Easy: { solved: stats.solvedEasy, total: stats.totalEasy },
    Medium: { solved: stats.solvedMedium, total: stats.totalMedium },
    Hard: { solved: stats.solvedHard, total: stats.totalHard },
  };

  const pieData = [
    { name: 'Easy', value: stats.solvedEasy },
    { name: 'Medium', value: stats.solvedMedium },
    { name: 'Hard', value: stats.solvedHard },
    { name: 'Unsolved', value: stats.totalProblems - stats.totalSolved },
  ];

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <h3 className="mb-4 text-sm font-medium text-foreground">Solve Progress</h3>

      <div className="flex items-center gap-8">
        {/* Donut */}
        <div className="relative h-36 w-36 shrink-0">
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
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-2xl font-bold tabular-nums text-foreground">
              {stats.totalSolved}
            </span>
            <span className="text-[11px] text-muted-foreground">Solved</span>
          </div>
        </div>

        {/* Breakdown */}
        <div className="flex flex-1 flex-col gap-3">
          {DIFFICULTIES.map(({ key, color, bg, text }) => {
            const { solved, total } = counts[key];
            const pct = total > 0 ? (solved / total) * 100 : 0;
            return (
              <div key={key}>
                <div className="mb-1 flex items-center justify-between">
                  <span className="flex items-center gap-2">
                    <span className={`inline-flex rounded px-1.5 py-0.5 text-xs font-medium ${bg} ${text}`}>
                      {key}
                    </span>
                  </span>
                  <span className="text-xs tabular-nums text-muted-foreground">
                    {solved}<span className="text-border"> / </span>{total}
                  </span>
                </div>
                <div className="h-1.5 w-full overflow-hidden rounded-full bg-muted">
                  <div
                    className="h-full rounded-full transition-all duration-500"
                    style={{ width: `${pct}%`, backgroundColor: color }}
                  />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

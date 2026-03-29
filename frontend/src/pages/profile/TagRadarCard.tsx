import {
  RadarChart,
  Radar,
  PolarGrid,
  PolarAngleAxis,
  ResponsiveContainer,
} from 'recharts';
import type { TagProficiency } from '@/types/profile';

interface TagRadarCardProps {
  tagProficiency: TagProficiency[];
}

export function TagRadarCard({ tagProficiency }: TagRadarCardProps) {
  const data = tagProficiency.map((t) => ({
    tag: t.tagName,
    proficiency: t.total > 0 ? Math.round((t.solved / t.total) * 100) : 0,
    solved: t.solved,
    total: t.total,
  }));

  if (data.length === 0) {
    return (
      <div className="rounded-xl border border-border bg-card p-5">
        <h3 className="mb-4 text-sm font-medium text-foreground">Tag Proficiency</h3>
        <div className="flex h-64 items-center justify-center">
          <p className="text-sm text-muted-foreground">
            Solve problems to see your tag proficiency.
          </p>
        </div>
      </div>
    );
  }

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <h3 className="mb-2 text-sm font-medium text-foreground">Tag Proficiency</h3>

      <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <RadarChart data={data} cx="50%" cy="50%" outerRadius="65%">
            <PolarGrid stroke="var(--border)" strokeOpacity={0.6} />
            <PolarAngleAxis
              dataKey="tag"
              tick={{ fill: 'var(--muted-foreground)', fontSize: 11 }}
            />
            <Radar
              dataKey="proficiency"
              stroke="var(--accent)"
              fill="var(--accent)"
              fillOpacity={0.2}
              strokeWidth={1.5}
            />
          </RadarChart>
        </ResponsiveContainer>
      </div>

      <div className="mt-2 flex flex-wrap gap-2">
        {data.map((d) => (
          <span
            key={d.tag}
            className="inline-flex items-center gap-1 rounded-md bg-muted px-2 py-0.5 text-xs text-muted-foreground"
          >
            {d.tag}
            <span className="font-medium tabular-nums text-foreground">
              {d.solved}/{d.total}
            </span>
          </span>
        ))}
      </div>
    </div>
  );
}

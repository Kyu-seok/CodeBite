import { useTranslation } from 'react-i18next';
import {
  RadarChart,
  Radar,
  PolarGrid,
  PolarAngleAxis,
  ResponsiveContainer,
} from 'recharts';
import type { TagProficiency } from '@/types/profile';
import { CardError } from './CardError';

interface TagRadarCardProps {
  tagProficiency: TagProficiency[];
  /** The tag request failed: say so instead of claiming there is nothing solved. */
  failed?: boolean;
  onRetry?: () => void;
}

export function TagRadarCard({ tagProficiency, failed, onRetry }: TagRadarCardProps) {
  const { t } = useTranslation('profile');
  const data = tagProficiency.map((tag) => ({
    tag: tag.tagName,
    proficiency: tag.total > 0 ? Math.round((tag.solved / tag.total) * 100) : 0,
    solved: tag.solved,
    total: tag.total,
  }));

  if (failed || data.length === 0) {
    return (
      <section className="rounded-xl border border-border bg-card p-5">
        <h2 className="mb-4 text-sm font-medium text-foreground">{t('tags.title')}</h2>
        {failed ? (
          <CardError onRetry={onRetry} />
        ) : (
          <div className="flex h-64 items-center justify-center">
            <p className="text-sm text-muted-foreground">{t('tags.empty')}</p>
          </div>
        )}
      </section>
    );
  }

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <h2 className="mb-2 text-sm font-medium text-foreground">{t('tags.title')}</h2>

      {/* The list below carries the same numbers as text. */}
      <div aria-hidden className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <RadarChart data={data} cx="50%" cy="50%" outerRadius="65%">
            <PolarGrid stroke="var(--border)" strokeOpacity={0.6} />
            <PolarAngleAxis
              dataKey="tag"
              tick={{ fill: 'var(--muted-foreground)', fontSize: 12 }}
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

      <ul className="mt-2 flex flex-wrap gap-2">
        {data.map((d) => (
          <li
            key={d.tag}
            className="inline-flex items-center gap-1 rounded-md bg-muted px-2 py-0.5 text-xs text-secondary-foreground"
          >
            {d.tag}
            <span className="font-medium tabular-nums text-foreground">
              {t('tags.count', { solved: d.solved, total: d.total })}
            </span>
          </li>
        ))}
      </ul>
    </section>
  );
}

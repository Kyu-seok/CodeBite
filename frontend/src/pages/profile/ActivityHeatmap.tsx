import { useEffect, useRef } from 'react';
import { useTranslation } from 'react-i18next';
import { ActivityCalendar } from 'react-activity-calendar';
import type { ActivityDay } from '@/types/profile';
import { useTheme } from '@/context/ThemeContext';

interface ActivityHeatmapProps {
  activity: ActivityDay[];
  /** Card heading. Defaults to the profile-page submissions heatmap title. */
  title?: string;
  /** Renders the right-hand count label. Receives the total count for the visible window. */
  countLabel?: (total: number) => string;
}

// Effort is the one thing Ember marks (DESIGN.md), so activity climbs the ember ramp. Level 0
// sits one tonal step off the card (Mist / Night Raised) so empty days keep the grid's shape.
const RAMP = {
  light: ['#f1f3f6', '#fed7aa', '#fdba74', '#fb923c', '#ea6502'],
  dark: ['#272e39', '#431a05', '#7c340f', '#c25005', '#fb923c'],
};

/** Month and weekday names in the UI language, Sunday first as the calendar draws them. */
function calendarNames(locale: string) {
  const months = Array.from({ length: 12 }, (_, m) =>
    new Date(Date.UTC(2024, m, 1)).toLocaleDateString(locale, { month: 'short', timeZone: 'UTC' }),
  );
  // 2024-01-07 is a Sunday.
  const weekdays = Array.from({ length: 7 }, (_, d) =>
    new Date(Date.UTC(2024, 0, 7 + d)).toLocaleDateString(locale, { weekday: 'short', timeZone: 'UTC' }),
  );
  return { months, weekdays };
}

export function ActivityHeatmap({
  activity,
  title,
  countLabel,
}: ActivityHeatmapProps) {
  const { t, i18n } = useTranslation('profile');
  const { theme } = useTheme();
  const calendarRef = useRef<HTMLElement>(null);

  // The year runs left to right, so a narrow card would open on last year's empty months.
  // Start scrolled to the newest week instead.
  useEffect(() => {
    const root = calendarRef.current;
    if (!root) return;
    const scroller = [root, ...root.querySelectorAll<HTMLElement>('*')].find(
      (el) => el.scrollWidth > el.clientWidth && getComputedStyle(el).overflowX !== 'visible',
    );
    if (scroller) scroller.scrollLeft = scroller.scrollWidth;
  }, [activity]);

  const maxCount = Math.max(1, ...activity.map((d) => d.count));
  const dataMap = new Map(activity.map((d) => [d.date, d.count]));

  const today = new Date();
  const oneYearAgo = new Date(today);
  oneYearAgo.setFullYear(today.getFullYear() - 1);
  oneYearAgo.setDate(oneYearAgo.getDate() + 1);

  const data: { date: string; count: number; level: 0 | 1 | 2 | 3 | 4 }[] = [];
  const cursor = new Date(oneYearAgo);
  while (cursor <= today) {
    const dateStr = cursor.toISOString().slice(0, 10);
    const count = dataMap.get(dateStr) || 0;
    const level =
      count === 0
        ? 0
        : count <= maxCount * 0.25
          ? 1
          : count <= maxCount * 0.5
            ? 2
            : count <= maxCount * 0.75
              ? 3
              : 4;
    data.push({ date: dateStr, count, level });
    cursor.setDate(cursor.getDate() + 1);
  }

  const totalSubmissions = data.reduce((sum, d) => sum + d.count, 0);
  const heading = title ?? t('heatmap.title');
  const countText = countLabel
    ? countLabel(totalSubmissions)
    : t('heatmap.submissions', { count: totalSubmissions });
  const formatDay = (date: string) =>
    new Date(`${date}T00:00:00Z`).toLocaleDateString(i18n.language, {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      timeZone: 'UTC',
    });

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex items-center justify-between gap-3">
        <h2 className="text-sm font-medium text-foreground">{heading}</h2>
        <span className="text-xs tabular-nums text-muted-foreground">{countText}</span>
      </div>
      {/* The count above is the text alternative. Per-day counts are pointer-only tooltips: a focus stop per day would be a year of Tab presses. */}
      <div aria-hidden>
        <ActivityCalendar
          ref={calendarRef}
          data={data}
          blockSize={12}
          blockMargin={3}
          fontSize={12}
          theme={RAMP}
          colorScheme={theme === 'dark' ? 'dark' : 'light'}
          // The library's total reads "N activities in <first year>", wrong for a rolling year
          // and English-only; the heading row already shows the count.
          showTotalCount={false}
          labels={{
            ...calendarNames(i18n.language),
            legend: { less: t('heatmap.less'), more: t('heatmap.more') },
          }}
          tooltips={{
            activity: {
              text: (a) => t('heatmap.day', { count: a.count, date: formatDay(a.date) }),
            },
          }}
        />
      </div>
    </section>
  );
}

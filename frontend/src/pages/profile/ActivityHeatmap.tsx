import { ActivityCalendar } from 'react-activity-calendar';
import type { ActivityDay } from '@/types/profile';
import { useTheme } from '@/context/ThemeContext';

interface ActivityHeatmapProps {
  activity: ActivityDay[];
}

export function ActivityHeatmap({ activity }: ActivityHeatmapProps) {
  const { theme } = useTheme();

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

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex items-center justify-between">
        <h3 className="text-sm font-medium text-foreground">Submission Activity</h3>
        <span className="text-xs text-muted-foreground">
          {totalSubmissions} submissions in the last year
        </span>
      </div>
      <ActivityCalendar
        data={data}
        blockSize={12}
        blockMargin={3}
        fontSize={12}
        theme={{
          light: ['#ebedf0', '#9be9a8', '#40c463', '#30a14e', '#216e39'],
          dark: ['#1a1f27', '#0e4429', '#006d32', '#26a641', '#39d353'],
        }}
        colorScheme={theme === 'dark' ? 'dark' : 'light'}
      />
    </div>
  );
}

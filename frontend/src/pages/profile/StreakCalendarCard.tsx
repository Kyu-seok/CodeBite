import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { isAxiosError } from 'axios';
import { ChevronLeft, ChevronRight, Check } from 'lucide-react';
import {
  getStreak,
  getStreakCalendar,
  notifyStreakChanged,
  repairStreakDay,
} from '@/api/streak';
import type { StreakCalendar, StreakSummary } from '@/types/streak';
import { Button } from '@/components/ui/Button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/Dialog';
import { cn } from '@/lib/utils';

/** Months and dates are UTC strings (`YYYY-MM`, `YYYY-MM-DD`), matching Streak Days. */
function shiftMonth(month: string, delta: number): string {
  const [y, m] = month.split('-').map(Number);
  const d = new Date(Date.UTC(y, m - 1 + delta, 1));
  return d.toISOString().slice(0, 7);
}

/** The month's dates, padded with nulls so the first lands on its weekday (Sunday first). */
function monthGrid(month: string): (string | null)[] {
  const [y, m] = month.split('-').map(Number);
  const first = new Date(Date.UTC(y, m - 1, 1));
  const daysInMonth = new Date(Date.UTC(y, m, 0)).getUTCDate();
  const cells: (string | null)[] = Array(first.getUTCDay()).fill(null);
  for (let day = 1; day <= daysInMonth; day++) {
    cells.push(`${month}-${String(day).padStart(2, '0')}`);
  }
  return cells;
}

const WEEKDAYS = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'] as const;

/**
 * The owner's Streak calendar. Streak Days get a check; Repaired Days get the
 * same check on a softer background, deliberately not much louder than that.
 * Clicking a Missed Day offers to spend a Repair on it.
 */
export function StreakCalendarCard() {
  const { t, i18n } = useTranslation('profile');
  const [summary, setSummary] = useState<StreakSummary | null>(null);
  const [month, setMonth] = useState<string | null>(null);
  const [calendar, setCalendar] = useState<StreakCalendar | null>(null);
  const [pending, setPending] = useState<string | null>(null);
  const [repairing, setRepairing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    getStreak().then((res) => setSummary(res.data)).catch(() => {});
    // Start on the current UTC month; the server's `today` keeps us honest after.
    setMonth(new Date().toISOString().slice(0, 7));
  }, []);

  useEffect(() => {
    if (!month) return;
    getStreakCalendar(month).then((res) => setCalendar(res.data)).catch(() => {});
  }, [month]);

  if (!summary || !month || !calendar) return null;

  const counted = new Map(calendar.days.map((d) => [d.date, d.repaired]));
  const { today, firstStreakDate } = calendar;
  const isMissed = (date: string) =>
    !counted.has(date) && firstStreakDate !== null && date > firstStreakDate && date < today;

  const firstMonth = (firstStreakDate ?? today).slice(0, 7);
  const currentMonth = today.slice(0, 7);
  const monthLabel = new Date(`${month}-01T00:00:00Z`).toLocaleDateString(i18n.language, {
    year: 'numeric',
    month: 'long',
    timeZone: 'UTC',
  });

  const confirmRepair = async () => {
    if (!pending) return;
    setRepairing(true);
    setError(null);
    try {
      const res = await repairStreakDay(pending);
      setSummary(res.data);
      setCalendar({ ...calendar, days: [...calendar.days, { date: pending, repaired: true }] });
      setPending(null);
      notifyStreakChanged();
    } catch (e) {
      const alreadyCounted = isAxiosError(e) && e.response?.status === 409;
      // The server's message is English-only; show our own translated copy instead.
      setError(t(alreadyCounted ? 'streakCalendar.alreadyCounted' : 'streakCalendar.repairFailed'));
      // The day was solved since this month loaded, so the calendar and Streak counts are stale.
      if (alreadyCounted) {
        getStreakCalendar(month).then((res) => setCalendar(res.data)).catch(() => {});
        notifyStreakChanged();
      }
    } finally {
      setRepairing(false);
    }
  };

  return (
    <div className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
        <h3 className="text-sm font-medium text-foreground">{t('streakCalendar.title')}</h3>
        <span className="text-xs text-muted-foreground tabular-nums">
          {t('streakCalendar.repairs', { count: summary.repairs })}
          {' · '}
          {t('streakCalendar.progress', { progress: summary.repairProgress, total: 5 })}
        </span>
      </div>

      <div className="mx-auto mb-3 flex max-w-sm items-center justify-between">
        <Button
          variant="ghost"
          size="icon"
          className="h-7 w-7"
          disabled={month <= firstMonth}
          onClick={() => setMonth(shiftMonth(month, -1))}
          aria-label={t('streakCalendar.previousMonth')}
        >
          <ChevronLeft className="h-4 w-4" />
        </Button>
        <span className="text-sm font-medium text-foreground">{monthLabel}</span>
        <Button
          variant="ghost"
          size="icon"
          className="h-7 w-7"
          disabled={month >= currentMonth}
          onClick={() => setMonth(shiftMonth(month, 1))}
          aria-label={t('streakCalendar.nextMonth')}
        >
          <ChevronRight className="h-4 w-4" />
        </Button>
      </div>

      {/* Capped so square cells stay day-sized instead of filling the profile's width. */}
      <div className="mx-auto grid max-w-sm grid-cols-7 gap-1 text-center">
        {WEEKDAYS.map((d) => (
          <span key={d} className="pb-1 text-[11px] text-muted-foreground">
            {t(`streakCalendar.weekdays.${d}`)}
          </span>
        ))}
        {monthGrid(month).map((date, i) => {
          if (!date) return <span key={`pad-${i}`} />;
          const day = Number(date.slice(8));
          const repaired = counted.get(date);
          const missed = isMissed(date);
          const canRepair = missed && summary.repairs > 0;

          return (
            <button
              key={date}
              type="button"
              disabled={!canRepair}
              onClick={() => {
                setError(null);
                setPending(date);
              }}
              title={missed && !canRepair ? t('streakCalendar.noRepairs') : undefined}
              className={cn(
                'relative flex aspect-square items-center justify-center rounded-md text-xs tabular-nums transition-colors',
                repaired === false && 'bg-success-500/20 font-medium text-success-600 dark:text-success-400',
                repaired === true && 'bg-success-500/10 font-medium text-success-600/80 dark:text-success-400/80',
                missed && 'text-muted-foreground',
                canRepair && 'cursor-pointer border border-dashed border-foreground/30 text-foreground hover:border-foreground/60 hover:bg-secondary',
                repaired === undefined && !missed && 'text-muted-foreground/50',
                date === today && 'ring-1 ring-foreground/30',
              )}
            >
              {repaired !== undefined ? <Check className="h-3.5 w-3.5" strokeWidth={3} /> : day}
            </button>
          );
        })}
      </div>

      <Dialog open={pending !== null} onOpenChange={(open) => !open && setPending(null)}>
        <DialogContent className="max-w-sm">
          <DialogHeader>
            <DialogTitle>{t('streakCalendar.confirmTitle')}</DialogTitle>
            <DialogDescription>
              {pending &&
                t('streakCalendar.confirmBody', {
                  date: new Date(`${pending}T00:00:00Z`).toLocaleDateString(i18n.language, {
                    month: 'long',
                    day: 'numeric',
                    weekday: 'short',
                    timeZone: 'UTC',
                  }),
                  count: summary.repairs,
                })}
            </DialogDescription>
          </DialogHeader>
          {error && <p className="text-sm text-error-500">{error}</p>}
          <DialogFooter>
            <Button variant="outline" size="sm" onClick={() => setPending(null)} disabled={repairing}>
              {t('streakCalendar.cancel')}
            </Button>
            <Button size="sm" onClick={confirmRepair} disabled={repairing}>
              {t('streakCalendar.useRepair')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

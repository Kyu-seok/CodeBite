import { useCallback, useEffect, useState } from 'react';
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
import LoadError from '@/components/ui/LoadError';

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
  const [failed, setFailed] = useState(false);

  const fetchSummary = useCallback(() => {
    getStreak()
      .then((res) => setSummary(res.data))
      .catch(() => setFailed(true));
  }, []);

  const fetchCalendar = useCallback(() => {
    if (!month) return;
    getStreakCalendar(month)
      .then((res) => setCalendar(res.data))
      .catch(() => setFailed(true));
  }, [month]);

  useEffect(() => {
    fetchSummary();
    // Start on the current UTC month; the server's `today` keeps us honest after.
    setMonth(new Date().toISOString().slice(0, 7));
  }, [fetchSummary]);

  useEffect(fetchCalendar, [fetchCalendar]);

  const retry = () => {
    setFailed(false);
    // The refused Repair's dialog would otherwise reopen over the refreshed calendar.
    setPending(null);
    setError(null);
    if (!summary) fetchSummary();
    fetchCalendar();
  };

  if (failed) {
    return (
      <section className="rounded-xl border border-border bg-card p-5">
        <h2 className="text-sm font-medium text-foreground">{t('streakCalendar.title')}</h2>
        {/* A refused Repair's reason (already counted) stays in view when the refresh after it fails. */}
        {error && (
          <p role="alert" className="mt-3 text-sm text-error-700 dark:text-error-400">
            {error}
          </p>
        )}
        <LoadError onRetry={retry} />
      </section>
    );
  }

  if (!summary || !month || !calendar) return null;

  const counted = new Map(calendar.days.map((d) => [d.date, d.repaired]));
  const { today, firstStreakDate } = calendar;
  const isMissed = (date: string) =>
    !counted.has(date) && firstStreakDate !== null && date > firstStreakDate && date < today;

  const hasMissed = monthGrid(month).some((date) => date !== null && isMissed(date));
  const formatDay = (date: string) =>
    new Date(`${date}T00:00:00Z`).toLocaleDateString(i18n.language, {
      month: 'long',
      day: 'numeric',
      weekday: 'long',
      timeZone: 'UTC',
    });

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
        fetchCalendar();
        notifyStreakChanged();
      }
    } finally {
      setRepairing(false);
    }
  };

  return (
    <section className="rounded-xl border border-border bg-card p-5">
      <div className="mb-4 flex flex-wrap items-center justify-between gap-2">
        <h2 className="text-sm font-medium text-foreground">{t('streakCalendar.title')}</h2>
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
        <span aria-live="polite" className="text-sm font-medium text-foreground">{monthLabel}</span>
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
          <span key={d} aria-hidden className="pb-1 text-xs text-muted-foreground">
            {t(`streakCalendar.weekdays.${d}`)}
          </span>
        ))}
        {monthGrid(month).map((date, i) => {
          if (!date) return <span key={`pad-${i}`} />;
          const day = Number(date.slice(8));
          const repaired = counted.get(date);
          const missed = isMissed(date);
          const canRepair = missed && summary.repairs > 0;
          // Each day names its date and kind, so the grid doesn't rely on colour, a check or a
          // dashed border alone.
          const label = t(
            repaired === false
              ? 'streakCalendar.day.streak'
              : repaired === true
                ? 'streakCalendar.day.repaired'
                : canRepair
                  ? 'streakCalendar.day.missedRepairable'
                  : missed
                    ? 'streakCalendar.day.missed'
                    : 'streakCalendar.day.plain',
            { date: formatDay(date) },
          );
          const className = cn(
            'relative flex aspect-square items-center justify-center rounded-md text-xs tabular-nums transition-colors',
            repaired === false && 'bg-success-500/20 font-medium text-success-700 dark:text-success-400',
            repaired === true && 'bg-success-500/10 font-medium text-success-700 dark:text-success-400',
            missed && 'border border-dashed border-foreground/30 text-muted-foreground',
            canRepair && 'cursor-pointer text-foreground hover:border-foreground/60 hover:bg-secondary',
            repaired === undefined && !missed && 'text-muted-foreground/60',
            date === today && 'ring-1 ring-foreground/30',
          );
          const content =
            repaired !== undefined ? <Check aria-hidden className="h-3.5 w-3.5" strokeWidth={3} /> : day;

          // Only a Missed Day with a Repair to spend is a control; every other day is a labelled cell.
          return canRepair ? (
            <button
              key={date}
              type="button"
              aria-label={label}
              aria-current={date === today ? 'date' : undefined}
              onClick={() => {
                setError(null);
                setPending(date);
              }}
              className={className}
            >
              {content}
            </button>
          ) : (
            <span key={date} className={className} aria-current={date === today ? 'date' : undefined}>
              <span aria-hidden className="contents">
                {content}
              </span>
              <span className="sr-only">{label}</span>
            </span>
          );
        })}
      </div>

      <ul className="mx-auto mt-3 flex max-w-sm flex-wrap gap-x-4 gap-y-1 text-xs text-muted-foreground">
        <li className="flex items-center gap-1.5">
          <span aria-hidden className="flex h-3.5 w-3.5 items-center justify-center rounded-sm bg-success-500/20 text-success-700 dark:text-success-400">
            <Check className="h-2.5 w-2.5" strokeWidth={3} />
          </span>
          {t('streakCalendar.legend.streak')}
        </li>
        <li className="flex items-center gap-1.5">
          <span aria-hidden className="flex h-3.5 w-3.5 items-center justify-center rounded-sm bg-success-500/10 text-success-700 dark:text-success-400">
            <Check className="h-2.5 w-2.5" strokeWidth={3} />
          </span>
          {t('streakCalendar.legend.repaired')}
        </li>
        <li className="flex items-center gap-1.5">
          <span aria-hidden className="h-3.5 w-3.5 rounded-sm border border-dashed border-foreground/30" />
          {t('streakCalendar.legend.missed')}
        </li>
      </ul>
      {hasMissed && summary.repairs === 0 && (
        <p className="mx-auto mt-2 max-w-sm text-xs text-muted-foreground">{t('streakCalendar.noRepairs')}</p>
      )}

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
          {error && (
            <p role="alert" className="text-sm text-error-700 dark:text-error-400">
              {error}
            </p>
          )}
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
    </section>
  );
}

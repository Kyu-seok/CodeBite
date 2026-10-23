import { useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { getStreak, STREAK_CHANGED_EVENT } from '@/api/streak';
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import { cn } from '@/lib/utils';

/**
 * Nav-bar Streak counter. The flame stays grey until today is a Streak Day, the
 * one daily nudge the feature allows itself.
 */
export function StreakFlame() {
  const { t } = useTranslation('nav');
  const location = useLocation();
  const [streak, setStreak] = useState<number | null>(null);
  const [solvedToday, setSolvedToday] = useState(false);

  useEffect(() => {
    let cancelled = false;
    const load = () => {
      getStreak()
        .then((res) => {
          if (cancelled) return;
          setStreak(res.data.currentStreak);
          setSolvedToday(res.data.solvedToday);
        })
        .catch(() => {});
    };
    load();

    // The Streak Day is recorded by a Kafka consumer that runs alongside the one
    // pushing the result to the browser, so it can land a moment after the
    // Accepted verdict. Refetch once more shortly after to pick it up.
    let retry: ReturnType<typeof setTimeout> | undefined;
    const onChanged = () => {
      load();
      clearTimeout(retry);
      retry = setTimeout(load, 2000);
    };
    window.addEventListener(STREAK_CHANGED_EVENT, onChanged);
    return () => {
      cancelled = true;
      clearTimeout(retry);
      window.removeEventListener(STREAK_CHANGED_EVENT, onChanged);
    };
  }, [location.pathname]);

  if (streak === null) return null;

  return (
    <Tooltip>
      <TooltipTrigger>
        <Link
          to="/profile"
          className={cn(
            'flex h-7 items-center gap-1 rounded-md px-1.5 text-xs font-semibold tabular-nums transition-colors hover:bg-secondary',
            solvedToday ? 'text-warning-500' : 'text-muted-foreground',
          )}
        >
          <span aria-hidden className={cn(!solvedToday && 'opacity-40 grayscale')}>🔥</span>
          <span>{streak}</span>
        </Link>
      </TooltipTrigger>
      <TooltipContent>{solvedToday ? t('streak.done') : t('streak.pending')}</TooltipContent>
    </Tooltip>
  );
}

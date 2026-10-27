import { useEffect, useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { getStreak, STREAK_CHANGED_EVENT } from '@/api/streak';
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import { cn } from '@/lib/utils';

/**
 * Nav-bar Streak counter. The flame stays grey until today is a Streak Day;
 * there is deliberately no reminder text beyond that.
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
        // eslint-disable-next-line no-restricted-syntax -- Ambient nav counter: on failure it just stays hidden; the profile's Streak calendar shows the error with a retry.
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
          aria-label={t('streak.days', { count: streak })}
          className={cn(
            'flex h-7 items-center gap-1 rounded-md px-1.5 font-mono text-xs font-semibold tabular-nums transition-colors hover:bg-secondary',
            'outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background',
            // Readable Ember: the count is text, so it takes the 700 step on paper, 400 on night.
            solvedToday ? 'text-accent-700 dark:text-accent-400' : 'text-muted-foreground',
          )}
        >
          <span aria-hidden className={cn(!solvedToday && 'opacity-40 grayscale')}>🔥</span>
          <span>{streak}</span>
        </Link>
      </TooltipTrigger>
      <TooltipContent>{t('streak.days', { count: streak })}</TooltipContent>
    </Tooltip>
  );
}

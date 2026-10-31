import { useState, useEffect, useMemo, useRef } from 'react';
import { Link, NavLink, Outlet, useNavigate, useLocation, useMatch } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import { CircleHelp, X } from 'lucide-react';
import i18n from '@/lib/i18n';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../context/ThemeContext';
import { updateThemePreference, updateLocale } from '../../api/user';
import { NavbarLogo } from '@/components/ui/NavbarLogo';
import { StreakFlame } from './StreakFlame';
import { useStartTutorial } from '@/hooks/useTutorial';
import { cn } from '@/lib/utils';
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
} from '@/components/ui/DropdownMenu';

function SunIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2" /><path d="M12 20v2" />
      <path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" />
      <path d="M2 12h2" /><path d="M20 12h2" />
      <path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" />
    </svg>
  );
}

function MoonIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
    </svg>
  );
}

function MenuIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <path d="M4 6h16" /><path d="M4 12h16" /><path d="M4 18h16" />
    </svg>
  );
}

function LanguageIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <path d="m5 8 6 6" /><path d="m4 14 6-6 2-3" /><path d="M2 5h12" /><path d="M7 2h1" />
      <path d="m22 22-5-10-5 10" /><path d="M14 18h6" />
    </svg>
  );
}

// DESIGN.md focus: a 2px Ember ring, offset so it clears the control.
const focusRing = 'outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background';
const iconButton = cn(
  'flex h-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground',
  focusRing,
);

function PlayIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="currentColor" stroke="none" aria-hidden>
      <polygon points="6,3 20,12 6,21" />
    </svg>
  );
}

function PauseIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="currentColor" stroke="none" aria-hidden>
      <rect x="5" y="3" width="5" height="18" rx="1" />
      <rect x="14" y="3" width="5" height="18" rx="1" />
    </svg>
  );
}

function ResetIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
      <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8" />
      <path d="M3 3v5h5" />
    </svg>
  );
}

function formatTime(seconds: number) {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
}

export function formatElapsed(seconds: number) {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  if (m > 0) return `${m}m ${s}s`;
  return `${s}s`;
}

export interface WorkspaceOutletContext {
  /**
   * Seconds on the solve timer, or null when it never ran (no time, rather than 0:00).
   * Read at submit time.
   */
  getTimerSnapshot: () => number | null;
  stopTimer: (freezeAt: number) => void;
  /** The learner edited the code; may nudge them to start an idle timer. */
  notifyEditing: () => void;
}

// The timer stays manual. Once dismissed, the start-timer nudge never comes back.
const TIMER_NUDGE_KEY = 'timer-nudge-dismissed';

function readNudgeDismissed() {
  try {
    return localStorage.getItem(TIMER_NUDGE_KEY) === '1';
  } catch {
    return false;
  }
}

export default function Layout() {
  const { t } = useTranslation('nav');
  const { user, isAuthenticated, logout } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const location = useLocation();
  const isWorkspace = useMatch('problems/:slug');
  // Any page of a problem (workspace or its solutions) keeps that problem's timer.
  const problemSlug = useMatch('problems/:slug/*')?.params.slug ?? null;

  const [timerActive, setTimerActive] = useState(false);
  const [elapsed, setElapsed] = useState(0);
  // Set when an Accepted submission has already recorded the shown time. A frozen time is
  // not offered again, so resubmitting the same problem can't count it twice.
  const [timerFrozen, setTimerFrozen] = useState(false);
  // The solve timer belongs to one problem: opening a different problem starts it fresh
  // instead of carrying the previous problem's elapsed time over.
  const [timerSlug, setTimerSlug] = useState(problemSlug);
  // Shown at most once per problem, on the first edit while the timer has never run.
  const [timerNudge, setTimerNudge] = useState(false);
  if (problemSlug !== null && problemSlug !== timerSlug) {
    setTimerSlug(problemSlug);
    setTimerActive(false);
    setElapsed(0);
    setTimerFrozen(false);
    setTimerNudge(false);
  }
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    if (timerActive) {
      intervalRef.current = setInterval(() => setElapsed((e) => e + 1), 1000);
    } else if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
    return () => { if (intervalRef.current) clearInterval(intervalRef.current); };
  }, [timerActive]);

  const handleTimerToggle = () => {
    setTimerActive((prev) => !prev);
    setTimerFrozen(false);
    setTimerNudge(false);
  };

  const handleNudgeStart = () => {
    setTimerActive(true);
    setTimerFrozen(false);
    setTimerNudge(false);
  };

  const handleNudgeDismiss = () => {
    setTimerNudge(false);
    try {
      localStorage.setItem(TIMER_NUDGE_KEY, '1');
    } catch {
      // Without storage the nudge just shows again on the next problem.
    }
  };

  const handleTimerReset = () => {
    setTimerActive(false);
    setElapsed(0);
    setTimerFrozen(false);
  };

  // The workspace reads the timer only when it submits, so the context stays stable and
  // the page does not re-render on every tick.
  const timerRef = useRef({ active: timerActive, elapsed, frozen: timerFrozen });
  useEffect(() => {
    timerRef.current = { active: timerActive, elapsed, frozen: timerFrozen };
  }, [timerActive, elapsed, timerFrozen]);

  // Solve time only reaches the backend for a signed-in learner, so only they get the nudge.
  const nudgeRef = useRef({ slug: problemSlug, nudgedSlug: null as string | null, enabled: isAuthenticated });
  useEffect(() => {
    nudgeRef.current.slug = problemSlug;
    nudgeRef.current.enabled = isAuthenticated;
  }, [problemSlug, isAuthenticated]);

  const outletContext = useMemo<WorkspaceOutletContext>(() => ({
    // A paused timer still counts; one that never ran is "no time", not 0:00, and one
    // frozen by an earlier Accepted submission has already been recorded.
    getTimerSnapshot: () => {
      const { elapsed: seconds, frozen } = timerRef.current;
      return !frozen && seconds > 0 ? seconds : null;
    },
    stopTimer: (freezeAt: number) => {
      setTimerActive(false);
      setElapsed(freezeAt);
      setTimerFrozen(true);
    },
    notifyEditing: () => {
      const nudge = nudgeRef.current;
      const timer = timerRef.current;
      if (!nudge.enabled || nudge.slug === null || nudge.nudgedSlug === nudge.slug) return;
      if (timer.active || timer.elapsed > 0 || readNudgeDismissed()) return;
      nudge.nudgedSlug = nudge.slug;
      setTimerNudge(true);
    },
  }), []);

  const handleToggleTheme = () => {
    const newTheme = theme === "light" ? "dark" : "light";
    toggleTheme();
    if (isAuthenticated) {
      // eslint-disable-next-line no-restricted-syntax -- Theme already applied here and kept in localStorage; a failed save only means the next sign-in opens in the old theme.
      updateThemePreference(newTheme).catch(() => {});
    }
  };

  const userInitial = user?.username?.charAt(0).toUpperCase() ?? '?';
  const isKorean = i18n.language === 'ko';
  const themeLabel = theme === 'light' ? t('switchToDark') : t('switchToLight');

  const handleToggleLanguage = () => {
    const newLang = isKorean ? 'en' : 'ko';
    i18n.changeLanguage(newLang);
    if (isAuthenticated) {
      // eslint-disable-next-line no-restricted-syntax -- Language already switched here; a failed save only means the next sign-in opens in the old language.
      updateLocale(newLang).catch(() => {});
    }
  };

  // "How CodeBite works": replays the Tutorial from step 1, on the Tutorial Problem.
  const startTutorial = useStartTutorial();

  const navLinks = [
    { to: '/problems', label: t('problems') },
    { to: '/roadmap', label: t('roadmap') },
    ...(isAuthenticated ? [{ to: '/reviews', label: t('reviews') }] : []),
  ];

  return (
    <div className="min-h-screen bg-background">
      <a
        href="#main"
        className="sr-only rounded-md bg-background px-3 py-2 text-sm font-medium text-foreground shadow-md focus:not-sr-only focus:fixed focus:left-4 focus:top-2 focus:z-[60] focus:outline-none focus:ring-2 focus:ring-ring"
      >
        {t('skipToContent')}
      </a>
      <header className="sticky top-0 z-50 border-b border-border bg-background/80 backdrop-blur-md">
        <div className="mx-auto flex h-14 max-w-6xl items-center justify-between gap-2 px-4 sm:px-6">
          <div className="flex min-w-0 items-center gap-2 md:gap-6">
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <button
                  type="button"
                  aria-label={t('menu')}
                  className={cn(iconButton, 'h-9 w-9 md:hidden')}
                >
                  <MenuIcon />
                </button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="start" className="w-52 md:hidden">
                {navLinks.map((link) => (
                  <DropdownMenuItem key={link.to} asChild>
                    <NavLink
                      to={link.to}
                      className="text-muted-foreground aria-[current=page]:font-medium aria-[current=page]:text-foreground"
                    >
                      {link.label}
                    </NavLink>
                  </DropdownMenuItem>
                ))}
                <DropdownMenuItem onSelect={startTutorial}>
                  <CircleHelp className="h-4 w-4" aria-hidden />
                  {t('howItWorks')}
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem onSelect={handleToggleLanguage}>
                  <LanguageIcon />
                  <span lang={isKorean ? 'en' : 'ko'}>{t('language')}</span>
                </DropdownMenuItem>
                <DropdownMenuItem onSelect={handleToggleTheme}>
                  {theme === 'light' ? <MoonIcon /> : <SunIcon />}
                  {themeLabel}
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
            <Link
              to="/"
              aria-label={t('home')}
              className={cn('flex shrink-0 items-center rounded-sm text-foreground', focusRing)}
            >
              <NavbarLogo className="h-6" />
            </Link>
            <nav aria-label={t('mainNav')} className="hidden md:block">
              <ul className="flex items-center gap-6">
                {navLinks.map((link) => (
                  <li key={link.to}>
                    <NavLink
                      to={link.to}
                      className={cn(
                        'whitespace-nowrap rounded-sm text-sm text-muted-foreground transition-colors hover:text-foreground',
                        'aria-[current=page]:font-medium aria-[current=page]:text-foreground',
                        focusRing,
                      )}
                    >
                      {link.label}
                    </NavLink>
                  </li>
                ))}
              </ul>
            </nav>
          </div>
          <div className="flex shrink-0 items-center gap-2 text-sm sm:gap-4">
            {isWorkspace && (
              <div className="relative flex items-center rounded-md border border-border">
                <button
                  type="button"
                  onClick={handleTimerToggle}
                  aria-label={timerActive ? t('timer.pause') : t('timer.start')}
                  className={cn(
                    'flex h-7 items-center gap-1.5 rounded-l-md px-2 text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground',
                    focusRing,
                  )}
                >
                  {timerActive ? <PauseIcon /> : <PlayIcon />}
                  <span className="text-xs font-mono tabular-nums">{formatTime(elapsed)}</span>
                </button>
                <Tooltip>
                  <TooltipTrigger>
                    <button
                      type="button"
                      onClick={handleTimerReset}
                      aria-label={t('timer.reset')}
                      className={cn(
                        'flex h-7 items-center justify-center rounded-r-md border-l border-border px-1.5 text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground',
                        focusRing,
                      )}
                    >
                      <ResetIcon />
                    </button>
                  </TooltipTrigger>
                  <TooltipContent>{t('timer.reset')}</TooltipContent>
                </Tooltip>
                {/* Polite and unfocused: the learner is typing in the editor when this appears. */}
                <div role="status" className="absolute right-0 top-full z-10 mt-2">
                  {timerNudge && (
                    <div className="flex w-64 max-w-[calc(100vw-2rem)] items-start gap-2 rounded-md border border-border bg-popover p-3 text-popover-foreground shadow-md">
                      <div className="min-w-0 flex-1">
                        <p className="text-xs leading-snug text-foreground">{t('timer.nudge')}</p>
                        <button
                          type="button"
                          onClick={handleNudgeStart}
                          className={cn(
                            'mt-2 inline-flex h-7 items-center gap-1.5 rounded-md bg-secondary px-2.5 text-xs font-medium text-secondary-foreground transition-colors hover:bg-neutral-200 dark:hover:bg-neutral-700',
                            focusRing,
                          )}
                        >
                          <PlayIcon />
                          {t('timer.start')}
                        </button>
                      </div>
                      <button
                        type="button"
                        onClick={handleNudgeDismiss}
                        aria-label={t('timer.nudgeDismiss')}
                        title={t('timer.nudgeDismiss')}
                        className={cn(iconButton, 'h-6 w-6 shrink-0')}
                      >
                        <X className="h-3.5 w-3.5" aria-hidden />
                      </button>
                    </div>
                  )}
                </div>
              </div>
            )}
            {isAuthenticated && <StreakFlame />}
            <Tooltip>
              <TooltipTrigger className="hidden md:inline-flex">
                <button
                  type="button"
                  onClick={startTutorial}
                  aria-label={t('howItWorks')}
                  className={cn(iconButton, 'w-7')}
                >
                  <CircleHelp className="h-4 w-4" aria-hidden />
                </button>
              </TooltipTrigger>
              <TooltipContent>{t('howItWorks')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger className="hidden md:inline-flex">
                <button
                  type="button"
                  onClick={handleToggleLanguage}
                  aria-label={t('switchLanguage')}
                  className={cn(iconButton, 'px-1.5 text-xs font-medium')}
                >
                  <span lang={isKorean ? 'en' : 'ko'}>{isKorean ? 'EN' : '한'}</span>
                </button>
              </TooltipTrigger>
              <TooltipContent lang={isKorean ? 'en' : 'ko'}>{t('language')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger className="hidden md:inline-flex">
                <button
                  type="button"
                  onClick={handleToggleTheme}
                  aria-label={themeLabel}
                  className={cn(iconButton, 'w-7')}
                >
                  {theme === 'light' ? <MoonIcon /> : <SunIcon />}
                </button>
              </TooltipTrigger>
              <TooltipContent>{themeLabel}</TooltipContent>
            </Tooltip>
            {isAuthenticated ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button
                    type="button"
                    aria-label={t('accountMenu')}
                    className={cn('shrink-0 rounded-full', focusRing)}
                  >
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt=""
                        className="h-7 w-7 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span aria-hidden className="flex h-7 w-7 items-center justify-center rounded-full bg-accent-700 text-xs font-semibold text-white">
                        {userInitial}
                      </span>
                    )}
                  </button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end" className="w-56">
                  <div className="flex items-center gap-3 px-2 py-3">
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt=""
                        className="h-10 w-10 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span aria-hidden className="flex h-10 w-10 items-center justify-center rounded-full bg-accent-700 text-sm font-semibold text-white">
                        {userInitial}
                      </span>
                    )}
                    <div className="flex min-w-0 flex-col">
                      <span className="truncate text-sm font-semibold">{user?.username}</span>
                      <span className="truncate text-xs text-muted-foreground">{user?.email}</span>
                    </div>
                  </div>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onSelect={() => navigate('/profile')}>
                    {t('profile')}
                  </DropdownMenuItem>
                  {user?.role === 'ADMIN' && (
                    <DropdownMenuItem onSelect={() => navigate('/admin/problems')}>
                      {t('admin')}
                    </DropdownMenuItem>
                  )}
                  <DropdownMenuItem onSelect={() => { logout(); navigate('/'); }}>
                    {t('logout')}
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <button
                type="button"
                onClick={() => {
                  sessionStorage.setItem("returnUrl", location.pathname);
                  navigate("/login");
                }}
                className={cn('whitespace-nowrap rounded-sm text-muted-foreground transition-colors hover:text-foreground', focusRing)}
              >
                {t('login')}
              </button>
            )}
          </div>
        </div>
      </header>
      <main id="main" tabIndex={-1} className="outline-none">
        <Outlet context={outletContext} />
      </main>
    </div>
  );
}

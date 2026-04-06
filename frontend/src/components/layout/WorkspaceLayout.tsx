import { useState, useEffect, useRef } from 'react';
import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../context/ThemeContext';
import { updateThemePreference } from '../../api/user';
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
} from '@/components/ui/DropdownMenu';

function ChevronLeft() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="m15 18-6-6 6-6" />
    </svg>
  );
}

function ChevronRight() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="18"
      height="18"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <path d="m9 18 6-6-6-6" />
    </svg>
  );
}

function TimerIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <line x1="10" x2="14" y1="2" y2="2" />
      <line x1="12" x2="12" y1="2" y2="6" />
      <circle cx="12" cy="14" r="8" />
      <path d="M12 10v4l2 2" />
    </svg>
  );
}

function SunIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
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
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
    </svg>
  );
}

function ListIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="16"
      height="16"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <line x1="3" x2="21" y1="6" y2="6" />
      <line x1="3" x2="21" y1="12" y2="12" />
      <line x1="3" x2="21" y1="18" y2="18" />
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
  timerActive: boolean;
  elapsed: number;
}

export default function WorkspaceLayout() {
  const { user, isAuthenticated, logout } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const location = useLocation();

  const handleToggleTheme = () => {
    const newTheme = theme === "light" ? "dark" : "light";
    toggleTheme();
    if (isAuthenticated) {
      updateThemePreference(newTheme).catch(() => {});
    }
  };

  const [timerActive, setTimerActive] = useState(false);
  const [elapsed, setElapsed] = useState(0);
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

  const handleTimerClick = () => {
    if (timerActive) {
      setTimerActive(false);
      setElapsed(0);
    } else {
      setTimerActive(true);
    }
  };

  const userInitial = user?.username?.charAt(0).toUpperCase() ?? '?';

  return (
    <div className="min-h-screen bg-background">
      <nav className="bg-background text-foreground border-border">
        <div className="px-3 h-12 flex items-center justify-between">
          {/* Left section */}
          <div className="flex items-center gap-1">
            <Link
              to="/"
              className="flex items-center justify-center w-8 h-8 rounded-md hover:bg-secondary transition-colors text-foreground"
              title="CodeBite Home">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" className="w-5 h-5">
                <path fill="currentColor" transform="matrix(0.887348 0 0 0.958802 -190.78 -207.101)" d="M421.997 310.206C451.556 307.468 462.425 323.648 481.506 343.026L512.583 374.435C521.79 383.786 533.985 395.204 541.669 404.847C552.406 420.714 543.223 443.327 528.269 452.163C501.933 467.726 487.535 454.329 468.958 435.285L445.694 411.42C440.178 405.802 435.19 399.643 427.351 398.117L426.638 397.984C424.506 398.857 422.686 399.668 420.96 401.266C409.684 411.709 398.993 423.091 388.148 434.061C376.518 446.124 363.837 457.476 353.142 470.388C350.35 473.919 347.012 480.411 348.127 484.959C350.373 494.127 362.348 504.607 368.879 511.178L392.868 535.169C402.299 544.576 412.145 555.15 422.407 563.556C431.182 570.744 442.005 555.983 447.387 550.803C463.621 535.182 479.272 510.901 502.116 505.379C511.939 503.004 521.771 506.631 529.845 512.042C537.995 519.217 542.901 526.837 545.302 537.579C549.386 555.848 531.899 569.858 520.258 581.91C509.415 593.179 498.476 604.357 487.442 615.441C480.733 622.234 462.773 641.341 456.202 646.237C450.915 650.195 444.762 652.836 438.251 653.942C409.43 658.971 395.263 640.402 377.411 622.334L340.125 584.948L297.099 541.944C281.621 526.545 264.53 513.566 260.521 491.005C255.266 461.431 279.05 442.897 297.577 424.145C312.838 408.476 328.225 392.93 343.735 377.508L380.951 339.886C392.845 327.903 404.573 312.909 421.997 310.206Z"/>
                <path fill="#FB641F" transform="matrix(0.887348 0 0 0.958802 -190.78 -207.101)" d="M567.961 310.653C594.257 306.825 609.157 325.031 625.777 341.665L659.109 375.223L706.718 422.569C716.616 432.463 730.757 445.505 738.038 456.919C748.649 473.552 747.98 499.404 734.96 514.631C725.693 525.469 715.929 535.15 705.978 545.233L660.71 590.99L633.155 618.799C611.561 640.818 597.782 660.993 563.895 652.506C544.703 646.776 532.59 629.963 518.32 616.525C534.162 600.122 550.475 584.178 567.237 568.715C572.762 570.533 577.329 572.985 582.15 568.311C588.674 561.984 594.7 555.174 601.08 548.683C616.746 532.626 632.521 516.677 648.405 500.835C653.238 495.955 657.811 491.131 657.637 483.977C657.471 479.095 655.789 474.386 652.825 470.503C647.866 463.901 637.895 454.615 631.818 448.789C624.497 441.745 617.24 434.636 610.046 427.463C581.509 399.261 552.726 369.879 523.657 342.385C536.93 326.512 546.566 314.025 567.961 310.653Z"/>
              </svg>
            </Link>

            <div className="w-px h-5 bg-border mx-1" />

            <Link
              to="/problems"
              className="flex items-center gap-1.5 px-2 py-1.5 rounded-md text-sm text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors">
              <ListIcon />
              <span>Problem List</span>
            </Link>

            <div className="flex items-center">
              <button
                onClick={() => navigate(-1)}
                className="flex items-center justify-center w-7 h-7 rounded-md text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
                title="Go back">
                <ChevronLeft />
              </button>
              <button
                onClick={() => navigate(1)}
                className="flex items-center justify-center w-7 h-7 rounded-md text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
                title="Go forward">
                <ChevronRight />
              </button>
            </div>
          </div>

          {/* Right section */}
          <div className="flex items-center gap-2">
            <button
              onClick={handleTimerClick}
              className="flex items-center gap-1.5 px-2 py-1.5 rounded-md text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors"
              title={timerActive ? 'Reset timer' : 'Start timer'}>
              <TimerIcon />
              {timerActive && (
                <span className="text-xs font-mono tabular-nums">{formatTime(elapsed)}</span>
              )}
            </button>
            <Tooltip>
              <TooltipTrigger>
                <button
                  onClick={handleToggleTheme}
                  className="flex items-center justify-center w-7 h-7 rounded-md text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors">
                  {theme === 'light' ? <MoonIcon /> : <SunIcon />}
                </button>
              </TooltipTrigger>
              <TooltipContent>{theme === 'light' ? 'Dark mode' : 'Light mode'}</TooltipContent>
            </Tooltip>
            {isAuthenticated ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button className="rounded-full outline-none focus-visible:ring-2 focus-visible:ring-ring">
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt={user?.username}
                        className="w-7 h-7 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span className="flex items-center justify-center w-7 h-7 rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-xs font-semibold text-white">
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
                        alt={user?.username}
                        className="w-10 h-10 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span className="flex items-center justify-center w-10 h-10 rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-sm font-semibold text-white">
                        {userInitial}
                      </span>
                    )}
                    <div className="flex flex-col min-w-0">
                      <span className="text-sm font-semibold truncate">
                        {user?.username}
                      </span>
                      <span className="text-xs text-muted-foreground truncate">
                        {user?.email}
                      </span>
                    </div>
                  </div>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onSelect={() => navigate('/profile')}>
                    Profile
                  </DropdownMenuItem>
                  <DropdownMenuItem onSelect={() => { logout(); navigate('/'); }}>Log out</DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <button
                onClick={() => {
                  sessionStorage.setItem("returnUrl", location.pathname);
                  navigate("/login");
                }}
                className="px-3 py-1 rounded-md text-sm text-muted-foreground hover:text-foreground hover:bg-secondary transition-colors">
                Login
              </button>
            )}
          </div>
        </div>
      </nav>
      <main>
        <Outlet context={{ timerActive, elapsed }} />
      </main>
    </div>
  );
}

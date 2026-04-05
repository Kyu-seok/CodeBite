import { Link, Outlet, useNavigate, useLocation } from 'react-router-dom';
import { useTranslation } from 'react-i18next';
import i18n from '@/lib/i18n';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../context/ThemeContext';
import { updateThemePreference, updateLocale } from '../../api/user';
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

export default function Layout() {
  const { t } = useTranslation('nav');
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

  const userInitial = user?.username?.charAt(0).toUpperCase() ?? '?';

  return (
    <div className="min-h-screen bg-background">
      <nav className="sticky top-0 z-50 border-b border-border bg-background/80 backdrop-blur-md">
        <div className="mx-auto flex h-14 max-w-6xl items-center justify-between px-4 sm:px-6">
          <div className="flex items-center gap-6">
            <Link to="/" className="text-lg font-bold text-foreground">
              {t('brand')}
            </Link>
            <Link
              to="/problems"
              className="text-sm text-muted-foreground transition-colors hover:text-foreground"
            >
              {t('problems')}
            </Link>
            <Link
              to="/roadmap"
              className="text-sm text-muted-foreground transition-colors hover:text-foreground"
            >
              {t('roadmap')}
            </Link>
          </div>
          <div className="flex items-center gap-4 text-sm">
            <Tooltip>
              <TooltipTrigger>
                <button
                  onClick={() => {
                    const newLang = i18n.language === 'ko' ? 'en' : 'ko';
                    i18n.changeLanguage(newLang);
                    if (isAuthenticated) {
                      updateLocale(newLang).catch(() => {});
                    }
                  }}
                  className="flex h-7 items-center justify-center rounded-md px-1.5 text-xs font-medium text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
                >
                  {i18n.language === 'ko' ? 'EN' : '한'}
                </button>
              </TooltipTrigger>
              <TooltipContent>{t('language')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <button
                  onClick={handleToggleTheme}
                  className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
                >
                  {theme === 'light' ? <MoonIcon /> : <SunIcon />}
                </button>
              </TooltipTrigger>
              <TooltipContent>{theme === 'light' ? t('darkMode') : t('lightMode')}</TooltipContent>
            </Tooltip>
            {isAuthenticated ? (
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button className="rounded-full outline-none focus-visible:ring-2 focus-visible:ring-ring">
                    {user?.avatarUrl ? (
                      <img
                        src={user.avatarUrl}
                        alt={user?.username}
                        className="h-7 w-7 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span className="flex h-7 w-7 items-center justify-center rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-xs font-semibold text-white">
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
                        className="h-10 w-10 rounded-full object-cover"
                        referrerPolicy="no-referrer"
                      />
                    ) : (
                      <span className="flex h-10 w-10 items-center justify-center rounded-full bg-gradient-to-br from-orange-400 to-amber-600 text-sm font-semibold text-white">
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
                onClick={() => {
                  sessionStorage.setItem("returnUrl", location.pathname);
                  navigate("/login");
                }}
                className="text-muted-foreground transition-colors hover:text-foreground"
              >
                {t('login')}
              </button>
            )}
          </div>
        </div>
      </nav>
      <main>
        <Outlet />
      </main>
    </div>
  );
}

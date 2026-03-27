import { useEffect, useState } from "react"
import { Link, useNavigate } from "react-router-dom"
import { useAuth } from "@/context/AuthContext"
import { useTheme } from "@/context/ThemeContext"
import { updateThemePreference } from "@/api/user"
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
} from "@/components/ui/DropdownMenu"
import { HeroSection } from "./HeroSection"
import { ScienceSection } from "./ScienceSection"
import { MethodSection } from "./MethodSection"
import { CtaSection } from "./CtaSection"
import { FooterSection } from "./FooterSection"

function SunIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2" /><path d="M12 20v2" />
      <path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" />
      <path d="M2 12h2" /><path d="M20 12h2" />
      <path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" />
    </svg>
  )
}

function MoonIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
    </svg>
  )
}

export default function LandingPage() {
  const { user, isAuthenticated, logout } = useAuth()
  const { theme, toggleTheme } = useTheme()
  const navigate = useNavigate()
  const [scrolled, setScrolled] = useState(false)

  useEffect(() => {
    document.title = "CodeBite — Master Coding Through Deliberate Practice"
  }, [])

  useEffect(() => {
    const handleScroll = () => setScrolled(window.scrollY > 20)
    window.addEventListener("scroll", handleScroll, { passive: true })
    return () => window.removeEventListener("scroll", handleScroll)
  }, [])

  const handleToggleTheme = () => {
    const newTheme = theme === "light" ? "dark" : "light"
    toggleTheme()
    if (isAuthenticated) {
      updateThemePreference(newTheme).catch(() => {})
    }
  }

  const userInitial = user?.username?.charAt(0).toUpperCase() ?? "?"

  return (
    <div className="min-h-screen bg-background">
      {/* Navbar */}
      <nav
        className={`sticky top-0 z-50 transition-all duration-300 ${
          scrolled
            ? "border-b border-border bg-background/80 backdrop-blur-md"
            : "bg-transparent"
        }`}
      >
        <div className="mx-auto flex h-14 max-w-6xl items-center justify-between px-4 sm:px-6">
          <div className="flex items-center gap-6">
            <Link to="/" className="text-lg font-bold text-foreground">
              CodeBite
            </Link>
            <div className="hidden items-center gap-4 text-sm sm:flex">
              <Link
                to="/problems"
                className="text-muted-foreground transition-colors hover:text-foreground"
              >
                Problems
              </Link>
            </div>
          </div>

          <div className="flex items-center gap-4 text-sm">
            <button
              onClick={handleToggleTheme}
              className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-secondary hover:text-foreground"
              title={
                theme === "light"
                  ? "Switch to dark mode"
                  : "Switch to light mode"
              }
            >
              {theme === "light" ? <MoonIcon /> : <SunIcon />}
            </button>
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
                      <span className="truncate text-sm font-semibold">
                        {user?.username}
                      </span>
                      <span className="truncate text-xs text-muted-foreground">
                        {user?.email}
                      </span>
                    </div>
                  </div>
                  <DropdownMenuSeparator />
                  <DropdownMenuItem onSelect={() => navigate("/profile")}>
                    Profile
                  </DropdownMenuItem>
                  <DropdownMenuItem onSelect={logout}>
                    Log out
                  </DropdownMenuItem>
                </DropdownMenuContent>
              </DropdownMenu>
            ) : (
              <button
                onClick={() => {
                  sessionStorage.setItem("returnUrl", "/")
                  navigate("/login")
                }}
                className="text-muted-foreground transition-colors hover:text-foreground"
              >
                Login
              </button>
            )}
          </div>
        </div>
      </nav>

      {/* Page sections */}
      <main>
        <HeroSection />
        <ScienceSection />
        <MethodSection />
        <CtaSection />
      </main>

      <FooterSection />
    </div>
  )
}

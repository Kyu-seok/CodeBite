import { useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { GraduationCap } from "lucide-react"
import { useAuth } from "@/context/AuthContext"
import { getRecentSubmissions } from "@/api/profile"
import { Button } from "@/components/ui/Button"
import { useStartTutorial } from "@/hooks/useTutorial"
import {
  browserStorage,
  dismissTutorialBanner,
  readTutorial,
  readTutorialBannerDismissed,
  tutorialBannerShows,
} from "@/onboarding"

/**
 * Whether the signed-in user has any submission: null while unknown (signed out, loading, or the
 * request failed, which hides the banner rather than offering the Tutorial to someone who may not
 * need it). One row of the profile's recent submissions answers it.
 */
function useHasSubmissions(signedIn: boolean): boolean | null {
  const [hasSubmissions, setHasSubmissions] = useState<boolean | null>(null)
  useEffect(() => {
    if (!signedIn) return
    let current = true
    getRecentSubmissions(0, 1)
      .then((res) => current && setHasSubmissions(res.data.content.length > 0))
      // eslint-disable-next-line no-restricted-syntax -- The banner is an offer; when it can't be decided it simply isn't shown.
      .catch(() => {})
    return () => {
      current = false
    }
  }, [signedIn])
  return signedIn ? hasSubmissions : null
}

/** The /problems banner offering the Tutorial; `tutorialBannerShows` decides, this only shows it. */
export function TutorialBanner() {
  const { t } = useTranslation("problem")
  const { isAuthenticated, loading } = useAuth()
  const startTutorial = useStartTutorial()
  const hasSubmissions = useHasSubmissions(isAuthenticated)
  const [dismissed, setDismissed] = useState(() => readTutorialBannerDismissed(browserStorage))
  const [tutorial] = useState(() => readTutorial(browserStorage))

  const viewer = isAuthenticated ? { signedIn: true as const, hasSubmissions } : { signedIn: false as const }
  if (loading || !tutorialBannerShows(viewer, tutorial, dismissed)) return null

  return (
    <aside
      aria-label={t("tutorialBanner.label")}
      className="mb-4 flex flex-col gap-3 rounded-lg border border-accent-500/30 bg-accent-500/5 p-4 text-sm sm:flex-row sm:items-center"
    >
      <GraduationCap className="hidden h-5 w-5 shrink-0 text-accent-700 sm:block dark:text-accent-400" aria-hidden />
      <div className="min-w-0 flex-1">
        <p className="font-semibold text-foreground">{t("tutorialBanner.title")}</p>
        <p className="mt-1 leading-relaxed text-muted-foreground">{t("tutorialBanner.body")}</p>
      </div>
      <div className="flex shrink-0 items-center gap-2">
        <Button variant="accent" size="sm" onClick={startTutorial}>
          {t("tutorialBanner.start")}
        </Button>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => setDismissed(dismissTutorialBanner(browserStorage))}
          aria-label={t("tutorialBanner.dismissLabel")}
        >
          {t("tutorialBanner.dismiss")}
        </Button>
      </div>
    </aside>
  )
}

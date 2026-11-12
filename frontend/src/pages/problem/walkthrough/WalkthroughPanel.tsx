// The Walkthrough tab (docs/adr/0011). LeftPanel imports it with `lazy`, so the player (a copy of the
// public walkthrough skill's kit under components/walkthrough/) downloads only when the tab opens.
import { useEffect, useMemo, useState } from "react"
import { useTranslation } from "react-i18next"
import { Button } from "@/components/ui/Button"
import LoadError from "@/components/ui/LoadError"
import Spinner from "@/components/ui/Spinner"
import { useTheme } from "@/context/ThemeContext"
import { getWalkthrough } from "@/api/problems"
import { Walkthrough } from "@/components/walkthrough/react/Walkthrough"
import type { Walkthrough as WalkthroughData } from "@/components/walkthrough/walkthrough.js"
import { textIn, walkthroughLang, type WalkthroughPlace } from "./walkthroughTab"

interface WalkthroughPanelProps {
  slug: string
  place: WalkthroughPlace
  onReveal: () => void
  onStep: (run: number, frame: number) => void
}

export default function WalkthroughPanel({ slug, place, onReveal, onStep }: WalkthroughPanelProps) {
  const { t } = useTranslation("problem")
  if (!place.revealed) {
    return (
      <div className="flex flex-col items-start gap-3 p-4">
        <h2 className="text-lg font-semibold">{t("tabs.walkthrough")}</h2>
        <p className="text-sm text-muted-foreground">{t("walkthrough.intro")}</p>
        <p className="text-sm text-muted-foreground">{t("walkthrough.spoiler")}</p>
        <Button onClick={onReveal}>{t("walkthrough.reveal")}</Button>
      </div>
    )
  }
  return <RevealedWalkthrough slug={slug} place={place} onStep={onStep} />
}

type Load = { slug: string; data: WalkthroughData } | { slug: string; failed: true }

function RevealedWalkthrough({ slug, place, onStep }: Omit<WalkthroughPanelProps, "onReveal">) {
  const { t, i18n } = useTranslation("problem")
  const { theme } = useTheme()
  const lang = walkthroughLang(i18n.resolvedLanguage ?? i18n.language)
  const [load, setLoad] = useState<Load | null>(null)
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    let current = true
    getWalkthrough(slug)
      .then((res) => current && setLoad({ slug, data: res.data }))
      .catch(() => current && setLoad({ slug, failed: true }))
    return () => {
      current = false
    }
  }, [slug, attempt])

  // The player remounts when its options change, so keep them stable across renders.
  const ui = useMemo(
    () => ({
      expected: t("walkthrough.expected"),
      extra: t("walkthrough.extra"),
      step: t("walkthrough.step"),
      first: t("walkthrough.first"),
      prev: t("walkthrough.prev"),
      next: t("walkthrough.next"),
      play: t("walkthrough.play"),
      pause: t("walkthrough.pause"),
      hint: t("walkthrough.hint"),
    }),
    [t],
  )

  if (!load || load.slug !== slug) {
    return (
      <div className="flex items-center gap-2 p-4 text-sm text-muted-foreground">
        <Spinner size="sm" className="p-0" />
        {t("walkthrough.loading")}
      </div>
    )
  }
  if ("failed" in load) {
    return (
      <LoadError
        message={t("walkthrough.loadError")}
        onRetry={() => {
          setLoad(null)
          setAttempt((n) => n + 1)
        }}
      />
    )
  }
  return (
    <div className="p-4">
      <h2 className="text-lg font-semibold">{textIn(load.data.title, lang)}</h2>
      <p className="mb-3 text-sm text-muted-foreground">{textIn(load.data.approach, lang)}</p>
      <Walkthrough
        data={load.data}
        lang={lang}
        theme={theme}
        ui={ui}
        // The place the learner left, whenever the player (re)mounts: a tab switch, the theme, the language.
        start={{ run: place.run, frame: place.frame }}
        onStep={onStep}
      />
    </div>
  )
}

import { useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { List, Network } from "lucide-react"
import { useRoadmap } from "@/hooks/useRoadmap"
import { useMediaQuery } from "@/hooks/useMediaQuery"
import Spinner from "@/components/ui/Spinner"
import LoadError from "@/components/ui/LoadError"
import { Button } from "@/components/ui/Button"
import RoadmapFlow from "./RoadmapFlow"
import RoadmapList from "./RoadmapList"

const DESKTOP_QUERY = "(min-width: 1024px)"

export default function RoadmapPage() {
  const { t } = useTranslation("roadmap")
  const { categories, loading, failed, reload } = useRoadmap()
  // Mount one view, not both hidden by CSS (as #34 did for the workspace): React Flow is
  // heavy on a phone where it would never show.
  const isDesktop = useMediaQuery(DESKTOP_QUERY)
  // The list is also offered on desktop, for keyboard and screen-reader users and anyone who
  // would rather read the topics in order than pan a graph.
  const [listOnDesktop, setListOnDesktop] = useState(false)

  useEffect(() => {
    document.title = t("title")
  }, [t])

  if (loading) return <Spinner />

  if (failed) {
    return (
      <div className="mx-auto max-w-md px-4 py-20">
        <h1 className="sr-only">{t("heading")}</h1>
        <LoadError onRetry={reload} />
      </div>
    )
  }

  if (isDesktop && !listOnDesktop) {
    return (
      <div className="relative" style={{ height: "calc(100dvh - 3.5rem)" }}>
        <h1 className="sr-only">{t("heading")}</h1>
        <Button
          variant="outline"
          size="sm"
          className="absolute left-4 top-4 z-10 bg-card"
          onClick={() => setListOnDesktop(true)}
        >
          <List aria-hidden className="h-4 w-4" />
          {t("listView")}
        </Button>
        <RoadmapFlow categories={categories} />
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-6 sm:px-6">
      <div className="mb-4 flex items-center justify-between gap-3">
        <h1 className="text-xl font-bold text-foreground">{t("heading")}</h1>
        {isDesktop && (
          <Button variant="outline" size="sm" onClick={() => setListOnDesktop(false)}>
            <Network aria-hidden className="h-4 w-4" />
            {t("graphView")}
          </Button>
        )}
      </div>
      <RoadmapList categories={categories} />
    </div>
  )
}

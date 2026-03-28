import { useEffect } from "react"
import { useRoadmap } from "@/hooks/useRoadmap"
import Spinner from "@/components/ui/Spinner"
import RoadmapFlow from "./RoadmapFlow"
import RoadmapList from "./RoadmapList"

export default function RoadmapPage() {
  const { categories, loading, error } = useRoadmap()

  useEffect(() => {
    document.title = "Roadmap — CodeBite"
  }, [])

  if (loading) return <Spinner />

  if (error) {
    return (
      <div className="flex items-center justify-center p-12 text-sm text-muted-foreground">
        {error}
      </div>
    )
  }

  return (
    <>
      {/* Desktop: full-screen graph */}
      <div className="hidden lg:block" style={{ height: "calc(100vh - 3.5rem)" }}>
        <RoadmapFlow categories={categories} />
      </div>

      {/* Mobile/tablet: vertical list */}
      <div className="lg:hidden px-4 py-6 sm:px-6">
        <RoadmapList categories={categories} />
      </div>
    </>
  )
}

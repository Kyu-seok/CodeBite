import { useEffect, useState } from "react"
import { getRoadmap } from "../api/roadmap"
import type { RoadmapCategory } from "../types/roadmap"

export function useRoadmap() {
  const [categories, setCategories] = useState<RoadmapCategory[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    getRoadmap()
      .then((res) => setCategories(res.data.categories))
      .catch(() => setError("Failed to load roadmap"))
      .finally(() => setLoading(false))
  }, [])

  return { categories, loading, error }
}

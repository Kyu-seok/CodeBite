import { useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { getRoadmap } from "../api/roadmap"
import type { RoadmapCategory } from "../types/roadmap"

export function useRoadmap() {
  const { i18n } = useTranslation()
  const [categories, setCategories] = useState<RoadmapCategory[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    setLoading(true)
    getRoadmap()
      .then((res) => setCategories(res.data.categories))
      .catch(() => setError("Failed to load roadmap"))
      .finally(() => setLoading(false))
  }, [i18n.language])

  return { categories, loading, error }
}

import { useCallback, useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { getRoadmap } from "../api/roadmap"
import type { RoadmapCategory } from "../types/roadmap"

export function useRoadmap() {
  const { i18n } = useTranslation()
  const [categories, setCategories] = useState<RoadmapCategory[]>([])
  const [loading, setLoading] = useState(true)
  const [failed, setFailed] = useState(false)

  const fetchRoadmap = useCallback(() => {
    getRoadmap()
      .then((res) => {
        setCategories(res.data.categories)
        setFailed(false)
      })
      .catch(() => setFailed(true))
      .finally(() => setLoading(false))
  }, [])

  // Refetch on a language switch: problem titles come back translated.
  useEffect(fetchRoadmap, [fetchRoadmap, i18n.language])

  const reload = useCallback(() => {
    setLoading(true)
    fetchRoadmap()
  }, [fetchRoadmap])

  return { categories, loading, failed, reload }
}

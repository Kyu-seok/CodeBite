import { useCallback, useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { getRoadmap } from "../api/roadmap"
import type { RoadmapCategory } from "../types/roadmap"

export function useRoadmap() {
  const { i18n } = useTranslation()
  const [categories, setCategories] = useState<RoadmapCategory[]>([])
  const [loading, setLoading] = useState(true)
  const [failed, setFailed] = useState(false)

  // isCurrent drops a response that lands after a newer request, so a quick en→ko→en
  // switch can't leave titles in the wrong language.
  const fetchRoadmap = useCallback((isCurrent: () => boolean = () => true) => {
    getRoadmap()
      .then((res) => {
        if (!isCurrent()) return
        setCategories(res.data.categories)
        setFailed(false)
      })
      .catch(() => {
        if (isCurrent()) setFailed(true)
      })
      .finally(() => {
        if (isCurrent()) setLoading(false)
      })
  }, [])

  // Refetch on a language switch: problem titles come back translated.
  useEffect(() => {
    let current = true
    fetchRoadmap(() => current)
    return () => {
      current = false
    }
  }, [fetchRoadmap, i18n.language])

  const reload = useCallback(() => {
    setLoading(true)
    fetchRoadmap()
  }, [fetchRoadmap])

  return { categories, loading, failed, reload }
}

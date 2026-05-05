import { useCallback, useEffect, useState } from "react"
import { listSolutions, listComments, type ListSolutionsParams } from "@/api/solutions"
import type { SolutionListItem, SolutionComment } from "@/types/solution"

interface PageState<T> {
  items: T[]
  totalElements: number
  totalPages: number
  page: number
  size: number
}

export function useSolutionsList(slug: string, params: ListSolutionsParams) {
  const [state, setState] = useState<PageState<SolutionListItem> | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Stable key from params for the effect dependency.
  const key = JSON.stringify(params)

  const fetchPage = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      const res = await listSolutions(slug, params)
      setState({
        items: res.data.content,
        totalElements: res.data.totalElements,
        totalPages: res.data.totalPages,
        page: res.data.number,
        size: res.data.size,
      })
    } catch {
      setError("Failed to load solutions.")
    } finally {
      setLoading(false)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [slug, key])

  useEffect(() => {
    fetchPage()
  }, [fetchPage])

  return { state, loading, error, refetch: fetchPage }
}

export function useComments(solutionId: number | null) {
  const [comments, setComments] = useState<SolutionComment[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const fetchComments = useCallback(async () => {
    if (solutionId == null) return
    setLoading(true)
    setError(null)
    try {
      const res = await listComments(solutionId)
      setComments(res.data.content)
    } catch {
      setError("Failed to load comments.")
    } finally {
      setLoading(false)
    }
  }, [solutionId])

  useEffect(() => {
    fetchComments()
  }, [fetchComments])

  return { comments, setComments, loading, error, refetch: fetchComments }
}

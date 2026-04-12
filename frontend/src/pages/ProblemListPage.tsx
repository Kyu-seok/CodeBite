import { useEffect, useState } from "react"
import { Link, useNavigate, useSearchParams } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { useProblems } from "../hooks/useProblems"
import { useProblemStats } from "../hooks/useProblemStats"
import { useTags } from "../hooks/useTags"
import DifficultyBadge from "../components/ui/DifficultyBadge"
import Spinner from "../components/ui/Spinner"
import { Button } from "@/components/ui/Button"
import { Input } from "@/components/ui/Input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/Select"
import { getRandomProblem } from "../api/problems"

function SortableHeader({
  label,
  field,
  currentSort,
  onSort,
  className,
}: {
  label: string
  field: string
  currentSort: string
  onSort: (sort: string) => void
  className?: string
}) {
  const [currentField, currentDir] = currentSort.split(",")
  const isActive = currentField === field
  const arrow = isActive ? (currentDir === "asc" ? " ↑" : " ↓") : ""

  const handleClick = () => {
    if (isActive) {
      onSort(`${field},${currentDir === "asc" ? "desc" : "asc"}`)
    } else {
      onSort(`${field},asc`)
    }
  }

  return (
    <th
      className={`px-4 py-3 text-left text-xs font-medium uppercase cursor-pointer select-none hover:text-foreground transition-colors ${
        isActive ? "text-accent-500" : "text-muted-foreground"
      } ${className || ""}`}
      onClick={handleClick}
    >
      {label}
      {arrow}
    </th>
  )
}

function StatusIcon({ status }: { status: "SOLVED" | "ATTEMPTED" | null }) {
  if (status === "SOLVED") {
    return (
      <svg className="w-4 h-4 text-success-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M20 6 9 17l-5-5" />
      </svg>
    )
  }
  if (status === "ATTEMPTED") {
    return <span className="inline-block w-2.5 h-2.5 rounded-full bg-warning-500" />
  }
  return null
}

export default function ProblemListPage() {
  const { t } = useTranslation("problem")
  const { t: tc } = useTranslation("common")
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const page = Number(searchParams.get("page") || "0")
  const search = searchParams.get("search") || ""
  const sort = searchParams.get("sort") || "problemNumber,asc"
  const tag = searchParams.get("tag") || ""
  const curation = searchParams.get("curation") || "CB50"
  const [searchInput, setSearchInput] = useState(search)
  const [randomLoading, setRandomLoading] = useState(false)
  const { tags } = useTags()
  const { stats } = useProblemStats(curation)
  const { data, loading, error } = useProblems(
    page, 20, undefined, search || undefined, sort, tag || undefined, curation
  )

  useEffect(() => {
    document.title = t("list.title")
  }, [])

  // Debounce search input → URL param
  useEffect(() => {
    const timeout = setTimeout(() => {
      if (searchInput !== search) {
        const params = new URLSearchParams(searchParams)
        if (searchInput) {
          params.set("search", searchInput)
        } else {
          params.delete("search")
        }
        params.set("page", "0")
        setSearchParams(params)
      }
    }, 300)
    return () => clearTimeout(timeout)
  }, [searchInput]) // eslint-disable-line react-hooks/exhaustive-deps

  const setPage = (p: number) => {
    const params = new URLSearchParams(searchParams)
    params.set("page", String(p))
    setSearchParams(params)
  }

  const setSort = (value: string) => {
    const params = new URLSearchParams(searchParams)
    params.set("sort", value)
    params.set("page", "0")
    setSearchParams(params)
  }

  const handleRandom = async () => {
    setRandomLoading(true)
    try {
      const res = await getRandomProblem()
      navigate(`/problems/${res.data.slug}`)
    } catch {
      // ignore
    } finally {
      setRandomLoading(false)
    }
  }

  const setCuration = (value: string) => {
    const params = new URLSearchParams(searchParams)
    params.set("curation", value)
    params.set("page", "0")
    setSearchParams(params)
  }

  const toggleTag = (slug: string) => {
    const params = new URLSearchParams(searchParams)
    if (tag === slug) {
      params.delete("tag")
    } else {
      params.set("tag", slug)
    }
    params.set("page", "0")
    setSearchParams(params)
  }

  return (
    <div className="mx-auto max-w-4xl px-4 py-8 sm:px-6">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold text-foreground">{t("list.heading")}</h1>
        <div className="flex items-center gap-3">
          <Button
            variant="outline"
            size="sm"
            onClick={handleRandom}
            disabled={randomLoading}
            className="border-accent-500/40 text-accent-500 hover:bg-accent-500/10 hover:border-accent-500"
          >
            <svg className="w-4 h-4 mr-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M16 3h5v5" /><path d="M4 20 21 3" /><path d="M21 16v5h-5" /><path d="m15 15 6 6" /><path d="M4 4l5 5" />
            </svg>
            {t("list.random")}
          </Button>
          <Input
            placeholder={t("list.search")}
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            inputSize="sm"
            className="w-[200px]"
          />
          <Select
            value={curation}
            onValueChange={setCuration}
          >
            <SelectTrigger className="w-[160px]">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="CB50">CodeBite 50</SelectItem>
              <SelectItem value="CB100">CodeBite 100</SelectItem>
              <SelectItem value="CB200">CodeBite 200</SelectItem>
            </SelectContent>
          </Select>
        </div>
      </div>

      {tags.length > 0 && (
        <div className="flex flex-wrap gap-1.5 mb-4">
          {tags.map((t) => (
            <button
              key={t.slug}
              onClick={() => toggleTag(t.slug)}
              className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium transition-colors cursor-pointer border ${
                tag === t.slug
                  ? "bg-accent-500 text-white border-accent-500"
                  : "bg-secondary text-secondary-foreground border-border hover:bg-accent-500/10 hover:text-accent-500 hover:border-accent-500/30"
              }`}
            >
              {t.name}
            </button>
          ))}
        </div>
      )}

      {stats && (
        <div className="flex items-center gap-6 mb-4 p-4 rounded-lg border border-border bg-card">
          <div className="text-sm font-medium text-foreground">
            {stats.solvedEasy + stats.solvedMedium + stats.solvedHard}
            <span className="text-muted-foreground"> / {stats.totalEasy + stats.totalMedium + stats.totalHard} {t("list.solved")}</span>
          </div>
          <div className="flex items-center gap-4 text-xs">
            <span className="text-success-600 dark:text-success-400">
              {tc("difficulty.easy")} {stats.solvedEasy}/{stats.totalEasy}
            </span>
            <span className="text-warning-600 dark:text-warning-400">
              {tc("difficulty.medium")} {stats.solvedMedium}/{stats.totalMedium}
            </span>
            <span className="text-error-600 dark:text-error-400">
              {tc("difficulty.hard")} {stats.solvedHard}/{stats.totalHard}
            </span>
          </div>
          {(stats.totalEasy + stats.totalMedium + stats.totalHard) > 0 && (
            <div className="flex-1 h-2 rounded-full bg-muted overflow-hidden flex">
              {stats.totalEasy > 0 && (
                <div
                  className="h-full bg-success-500"
                  style={{ width: `${(stats.solvedEasy / (stats.totalEasy + stats.totalMedium + stats.totalHard)) * 100}%` }}
                />
              )}
              {stats.totalMedium > 0 && (
                <div
                  className="h-full bg-warning-500"
                  style={{ width: `${(stats.solvedMedium / (stats.totalEasy + stats.totalMedium + stats.totalHard)) * 100}%` }}
                />
              )}
              {stats.totalHard > 0 && (
                <div
                  className="h-full bg-error-500"
                  style={{ width: `${(stats.solvedHard / (stats.totalEasy + stats.totalMedium + stats.totalHard)) * 100}%` }}
                />
              )}
            </div>
          )}
        </div>
      )}

      {loading && <Spinner />}
      {error && <p className="text-destructive">{error}</p>}

      {data && data.content.length === 0 && (
        <p className="text-muted-foreground text-center py-12">
          {t("list.noProblems")}
        </p>
      )}

      {data && data.content.length > 0 && (
        <>
          <div className="w-full rounded-lg border border-border overflow-hidden">
            <table className="w-full">
              <thead className="bg-muted border-b border-border">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase w-12">
                    &nbsp;
                  </th>
                  <SortableHeader label={t("list.columnNumber")} field="problemNumber" currentSort={sort} onSort={setSort} className="w-16" />
                  <SortableHeader label={t("list.columnTitle")} field="title" currentSort={sort} onSort={setSort} />
                  <SortableHeader label={t("list.columnDifficulty")} field="difficulty" currentSort={sort} onSort={setSort} className="w-28" />
                  <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase w-28">
                    {t("list.columnAcceptance")}
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.content.map((problem) => (
                  <tr
                    key={problem.id}
                    className={`transition-colors ${
                      problem.status === "SOLVED"
                        ? "bg-success-500/5 hover:bg-success-500/10"
                        : "hover:bg-accent-500/5"
                    }`}
                  >
                    <td className="px-4 py-3 text-center">
                      <StatusIcon status={problem.status} />
                    </td>
                    <td className="px-4 py-3 text-sm text-muted-foreground">
                      {problem.problemNumber ?? problem.id}
                    </td>
                    <td className="px-4 py-3">
                      <Link
                        to={`/problems/${problem.slug}`}
                        className="text-foreground hover:text-accent-500 hover:underline font-medium"
                      >
                        {problem.title}
                      </Link>
                    </td>
                    <td className="px-4 py-3">
                      <DifficultyBadge difficulty={problem.difficulty} />
                    </td>
                    <td className="px-4 py-3 text-sm text-muted-foreground">
                      {problem.acceptanceRate != null
                        ? `${problem.acceptanceRate.toFixed(1)}%`
                        : "—"}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {data.totalPages > 1 && (
            <div className="flex items-center justify-center gap-4 mt-6">
              <Button
                variant="outline"
                size="sm"
                onClick={() => setPage(page - 1)}
                disabled={data.first}
              >
                {tc("button.previous")}
              </Button>
              <span className="text-sm text-muted-foreground">
                {tc("pagination.pageOf", { current: data.number + 1, total: data.totalPages })}
              </span>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setPage(page + 1)}
                disabled={data.last}
              >
                {tc("button.next")}
              </Button>
            </div>
          )}
        </>
      )}
    </div>
  )
}

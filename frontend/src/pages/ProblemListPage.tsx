import { useEffect, useState } from "react"
import { Link, useNavigate, useSearchParams } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { useAuth } from "@/context/AuthContext"
import { updateCuration as saveCuration, updateSinglePage as saveSinglePage } from "@/api/user"
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
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/Select"
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationButton,
  PaginationPrevious,
  PaginationNext,
  PaginationEllipsis,
} from "@/components/ui/Pagination"
import { Switch } from "@/components/ui/Switch"
import { getRandomProblem } from "../api/problems"

// DESIGN.md focus: a 2px Ember ring, offset so it clears the control (same as the app shell).
const focusRing =
  "outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background"

// Phone widths drop the acceptance column and tighten cell padding so titles keep their room.
const cell = "px-2 py-3 sm:px-4"

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
  const ascending = currentDir === "asc"

  const handleClick = () => {
    if (isActive) {
      onSort(`${field},${currentDir === "asc" ? "desc" : "asc"}`)
    } else {
      onSort(`${field},asc`)
    }
  }

  return (
    <th
      scope="col"
      aria-sort={isActive ? (ascending ? "ascending" : "descending") : undefined}
      className={`${cell} text-left text-xs font-medium uppercase ${className || ""}`}
    >
      <button
        type="button"
        onClick={handleClick}
        className={`-mx-1 inline-flex items-center gap-1 rounded-sm px-1 uppercase transition-colors hover:text-foreground ${focusRing} ${
          // Readable Ember: the 800 step holds 4.5:1 on the Mist header row; 400 on night.
          isActive ? "text-accent-800 dark:text-accent-400" : "text-secondary-foreground dark:text-muted-foreground"
        }`}
      >
        {label}
        {isActive && (
          <svg className="h-3 w-3" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
            {ascending ? <path d="m18 15-6-6-6 6" /> : <path d="m6 9 6 6 6-6" />}
          </svg>
        )}
      </button>
    </th>
  )
}

function StatusIcon({ status }: { status: "SOLVED" | "ATTEMPTED" | null }) {
  const { t } = useTranslation("problem")
  if (status === "SOLVED") {
    return (
      <svg role="img" aria-label={t("list.statusSolved")} className="mx-auto w-4 h-4 text-success-600 dark:text-success-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
        <path d="M20 6 9 17l-5-5" />
      </svg>
    )
  }
  if (status === "ATTEMPTED") {
    return <span role="img" aria-label={t("list.statusAttempted")} className="inline-block w-2.5 h-2.5 rounded-full bg-warning-500" />
  }
  return null
}

function generatePageNumbers(current: number, total: number): (number | "ellipsis")[] {
  if (total <= 7) {
    return Array.from({ length: total }, (_, i) => i)
  }
  const pages: (number | "ellipsis")[] = [0]
  if (current > 2) pages.push("ellipsis")
  for (let i = Math.max(1, current - 1); i <= Math.min(total - 2, current + 1); i++) {
    pages.push(i)
  }
  if (current < total - 3) pages.push("ellipsis")
  pages.push(total - 1)
  return pages
}

export default function ProblemListPage() {
  const { t } = useTranslation("problem")
  const { t: tc } = useTranslation("common")
  const { user, isAuthenticated, updateUser } = useAuth()
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const page = Number(searchParams.get("page") || "0")
  const search = searchParams.get("search") || ""
  const sort = searchParams.get("sort") || "problemNumber,asc"
  const tag = searchParams.get("tag") || ""
  const curation = searchParams.get("curation") || user?.curation || "CB100"
  const [searchInput, setSearchInput] = useState(search)
  const [randomLoading, setRandomLoading] = useState(false)
  const [randomError, setRandomError] = useState(false)
  const [showAll, setShowAll] = useState(user?.singlePage ?? true)
  const { tags } = useTags()
  const { stats } = useProblemStats(curation)
  const pageSize = showAll ? 200 : 20
  const { data, loading, error, retry } = useProblems(
    showAll ? 0 : page, pageSize, undefined, search || undefined, sort, tag || undefined, curation
  )

  useEffect(() => {
    document.title = t("list.title")
  }, [t])

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
    setRandomError(false)
    try {
      const res = await getRandomProblem()
      navigate(`/problems/${res.data.slug}`)
    } catch {
      setRandomError(true)
    } finally {
      setRandomLoading(false)
    }
  }

  const setCuration = (value: string) => {
    const params = new URLSearchParams(searchParams)
    params.set("curation", value)
    params.set("page", "0")
    setSearchParams(params)
    if (isAuthenticated) {
      updateUser({ curation: value })
      saveCuration(value).catch(() => {})
    }
  }

  const handleSinglePageChange = (checked: boolean) => {
    setShowAll(checked)
    if (isAuthenticated) {
      updateUser({ singlePage: checked })
      saveSinglePage(checked).catch(() => {})
    }
  }

  const hasFilters = Boolean(search || tag)

  const clearFilters = () => {
    const params = new URLSearchParams(searchParams)
    params.delete("search")
    params.delete("tag")
    params.set("page", "0")
    setSearchInput("")
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
      <div className="mb-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <h1 className="shrink-0 text-2xl font-bold text-foreground">{t("list.heading")}</h1>
        {/* Wraps on phones: Random + search on one row, curation + single page below. */}
        <div className="flex flex-wrap items-center gap-2 sm:flex-nowrap sm:gap-3">
          <Button
            variant="outline"
            size="sm"
            onClick={handleRandom}
            disabled={randomLoading}
            aria-busy={randomLoading}
            // Readable Ember: orange text is the 700 step on paper (800 on hover), 400 on night.
            className="border-accent-700/40 text-accent-700 hover:border-accent-700 hover:bg-accent-500/10 hover:text-accent-800 dark:border-accent-400/40 dark:text-accent-400 dark:hover:border-accent-400 dark:hover:text-accent-400"
          >
            <svg className="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
              <path d="M16 3h5v5" /><path d="M4 20 21 3" /><path d="M21 16v5h-5" /><path d="m15 15 6 6" /><path d="M4 4l5 5" />
            </svg>
            {t("list.random")}
          </Button>
          <Input
            type="search"
            aria-label={t("list.searchLabel")}
            placeholder={t("list.search")}
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            inputSize="sm"
            className="min-w-0 flex-1 basis-40 sm:w-[200px] sm:flex-none sm:basis-auto"
          />
          <Select
            value={curation}
            onValueChange={setCuration}
          >
            <SelectTrigger aria-label={t("list.curationLabel")} className={`w-[160px] ${focusRing}`}>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectGroup>
                <SelectLabel>{t("list.curationLabel")}</SelectLabel>
                <SelectItem
                  value="CB50"
                  description={t("list.curationDescription.CB50")}
                >
                  CodeBite 50
                </SelectItem>
                <SelectItem
                  value="CB100"
                  description={t("list.curationDescription.CB100")}
                >
                  CodeBite 100
                </SelectItem>
                <SelectItem
                  value="CB200"
                  description={t("list.curationDescription.CB200")}
                >
                  CodeBite 200
                </SelectItem>
              </SelectGroup>
            </SelectContent>
          </Select>
          <label className="flex items-center gap-1.5 whitespace-nowrap text-xs text-muted-foreground">
            <Switch checked={showAll} onCheckedChange={handleSinglePageChange} />
            {t("list.singlePage")}
          </label>
        </div>
      </div>

      {randomError && (
        <p role="alert" className="mb-4 text-sm text-error-700 dark:text-error-400">
          {t("list.randomError")}
        </p>
      )}

      {tags.length > 0 && (
        <div role="group" aria-label={t("list.tagsLabel")} className="flex flex-wrap gap-1.5 mb-4">
          {tags.map((tagItem) => (
            <button
              key={tagItem.slug}
              type="button"
              aria-pressed={tag === tagItem.slug}
              onClick={() => toggleTag(tagItem.slug)}
              className={`inline-flex items-center rounded-full px-2.5 py-1 text-xs font-medium transition-colors cursor-pointer border ${focusRing} ${
                tag === tagItem.slug
                  ? // Readable Ember: white text sits on the 700 step (4.7:1), never on bright Ember.
                    "bg-accent-700 text-white border-accent-700 hover:bg-accent-800 hover:border-accent-800"
                  : "bg-secondary text-secondary-foreground border-border hover:bg-accent-500/10 hover:text-accent-800 hover:border-accent-500/30 dark:hover:text-accent-400"
              }`}
            >
              {tagItem.name}
            </button>
          ))}
        </div>
      )}

      {stats && (
        <div className="flex flex-wrap items-center gap-x-6 gap-y-3 mb-4 p-4 rounded-lg border border-border bg-card">
          <div className="whitespace-nowrap text-sm font-medium text-foreground">
            {stats.solvedEasy + stats.solvedMedium + stats.solvedHard}
            <span className="text-muted-foreground"> / {stats.totalEasy + stats.totalMedium + stats.totalHard} {t("list.solved")}</span>
          </div>
          {/* Wash-and-Text: the 700 step on paper, 400 on night. */}
          <div className="flex items-center gap-4 whitespace-nowrap text-xs">
            <span className="text-success-700 dark:text-success-400">
              {tc("difficulty.easy")} {stats.solvedEasy}/{stats.totalEasy}
            </span>
            <span className="text-warning-700 dark:text-warning-400">
              {tc("difficulty.medium")} {stats.solvedMedium}/{stats.totalMedium}
            </span>
            <span className="text-error-700 dark:text-error-400">
              {tc("difficulty.hard")} {stats.solvedHard}/{stats.totalHard}
            </span>
          </div>
          {(stats.totalEasy + stats.totalMedium + stats.totalHard) > 0 && (
            // The counts beside it already say this; the bar is a picture of them.
            <div aria-hidden className="h-2 min-w-0 basis-full sm:basis-auto flex-1 rounded-full bg-muted overflow-hidden flex">
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

      {/* First load only: later loads keep the table in place, dimmed, instead of pushing it down. */}
      {loading && !data && <Spinner />}

      {error && (
        <div role="alert" className="mb-4 flex flex-wrap items-center gap-3 rounded-lg border border-border bg-card p-4 text-sm">
          <span className="text-error-700 dark:text-error-400">{t("list.loadError")}</span>
          <Button variant="outline" size="sm" onClick={retry}>
            {t("list.retry")}
          </Button>
        </div>
      )}

      {data && data.content.length === 0 && (
        <div className="flex flex-col items-center gap-3 py-12 text-center">
          <p className="text-muted-foreground">{t("list.noProblems")}</p>
          {hasFilters && (
            <Button variant="outline" size="sm" onClick={clearFilters}>
              {t("list.clearFilters")}
            </Button>
          )}
        </div>
      )}

      {data && data.content.length > 0 && (
        <>
          <div
            aria-busy={loading}
            className={`w-full rounded-lg border border-border overflow-x-auto transition-opacity ${loading ? "opacity-60" : ""}`}
          >
            <table className="w-full">
              <thead className="bg-muted border-b border-border">
                <tr>
                  <th scope="col" className={`${cell} w-8 sm:w-12`}>
                    <span className="sr-only">{t("list.columnStatus")}</span>
                  </th>
                  <SortableHeader label={t("list.columnNumber")} field="problemNumber" currentSort={sort} onSort={setSort} className="w-10 sm:w-16" />
                  <SortableHeader label={t("list.columnTitle")} field="title" currentSort={sort} onSort={setSort} />
                  <SortableHeader label={t("list.columnDifficulty")} field="difficulty" currentSort={sort} onSort={setSort} className="w-24 sm:w-28" />
                  <th scope="col" className={`${cell} hidden sm:table-cell text-left text-xs font-medium text-secondary-foreground dark:text-muted-foreground uppercase w-28`}>
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
                    <td className={`${cell} text-center`}>
                      <StatusIcon status={problem.status} />
                    </td>
                    {/* neutral-600, not Graphite: Graphite drops to 4.1:1 on the solved-row tint (also below). */}
                    <td className={`${cell} text-sm tabular-nums text-neutral-600 dark:text-muted-foreground`}>
                      {problem.problemNumber ?? problem.id}
                    </td>
                    <td className={cell}>
                      <Link
                        to={`/problems/${problem.slug}`}
                        className={`rounded-sm text-foreground hover:text-accent-700 hover:underline dark:hover:text-accent-400 font-medium ${focusRing}`}
                      >
                        {problem.title}
                      </Link>
                    </td>
                    <td className={cell}>
                      <DifficultyBadge difficulty={problem.difficulty} />
                    </td>
                    <td className={`${cell} hidden sm:table-cell text-sm tabular-nums text-neutral-600 dark:text-muted-foreground`}>
                      {problem.acceptanceRate != null
                        ? `${problem.acceptanceRate.toFixed(1)}%`
                        : "—"}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {!showAll && data.totalPages > 1 && (
            <Pagination className="mt-6">
              <PaginationContent>
                <PaginationItem>
                  <PaginationPrevious
                    onClick={() => setPage(page - 1)}
                    disabled={data.first}
                  />
                </PaginationItem>
                {generatePageNumbers(data.number, data.totalPages).map((item, i) =>
                  item === "ellipsis" ? (
                    <PaginationItem key={`e${i}`}>
                      <PaginationEllipsis />
                    </PaginationItem>
                  ) : (
                    <PaginationItem key={item}>
                      <PaginationButton
                        isActive={item === data.number}
                        onClick={() => setPage(item)}
                      >
                        {item + 1}
                      </PaginationButton>
                    </PaginationItem>
                  )
                )}
                <PaginationItem>
                  <PaginationNext
                    onClick={() => setPage(page + 1)}
                    disabled={data.last}
                  />
                </PaginationItem>
              </PaginationContent>
            </Pagination>
          )}
        </>
      )}
    </div>
  )
}

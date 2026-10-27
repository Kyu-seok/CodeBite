import { useEffect, useMemo, useState } from "react"
import { useNavigate } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ChevronUp, MessageSquare } from "lucide-react"
import { Button } from "@/components/ui/Button"
import { Badge } from "@/components/ui/Badge"
import Spinner from "@/components/ui/Spinner"
import { useSolutionsList } from "@/hooks/useSolutions"
import { LanguagePill } from "./LanguagePill"
import { SUPPORTED_LANGUAGES, formatDate, languageLabel } from "../submissionDisplay"
import { AuthorAvatar } from "./AuthorAvatar"
import type { SolutionListItem, SolutionSort } from "@/types/solution"

interface SolutionsListPanelProps {
  slug: string
  isAuthenticated: boolean
}

const SORT_OPTIONS: SolutionSort[] = ["NET_SCORE", "RECENT", "COMMENTS", "OLDEST"]
const SEARCH_DEBOUNCE_MS = 300

export function SolutionsListPanel({ slug, isAuthenticated }: SolutionsListPanelProps) {
  const { t } = useTranslation("problem")
  const navigate = useNavigate()
  const [language, setLanguage] = useState<string | undefined>(undefined)
  const [sort, setSort] = useState<SolutionSort>("NET_SCORE")
  // The input updates on every keystroke; the query waits until typing pauses.
  const [searchInput, setSearchInput] = useState("")
  const [search, setSearch] = useState("")
  const [page, setPage] = useState(0)

  useEffect(() => {
    const handle = setTimeout(() => {
      setSearch(searchInput.trim())
      setPage(0)
    }, SEARCH_DEBOUNCE_MS)
    return () => clearTimeout(handle)
  }, [searchInput])

  const params = useMemo(
    () => ({
      language,
      sort,
      search: search || undefined,
      page,
      size: 10,
    }),
    [language, sort, search, page],
  )

  const { state, loading, error } = useSolutionsList(slug, params)

  const handleShare = () => {
    if (!isAuthenticated) {
      sessionStorage.setItem("returnUrl", `/problems/${slug}/solutions/new`)
      navigate("/login")
      return
    }
    navigate(`/problems/${slug}/solutions/new`)
  }

  return (
    <div className="flex h-full flex-col">
      {/* Filter bar */}
      <div className="border-b border-border p-3 space-y-2">
        <div
          role="group"
          aria-label={t("solutions.languageFilter")}
          className="flex items-center gap-2 flex-wrap">
          <Button
            variant={language === undefined ? "secondary" : "ghost"}
            size="sm"
            aria-pressed={language === undefined}
            onClick={() => setLanguage(undefined)}>
            {t("solutions.filterAllLanguages")}
          </Button>
          {SUPPORTED_LANGUAGES.map((code) => (
            <Button
              key={code}
              variant={language === code ? "secondary" : "ghost"}
              size="sm"
              aria-pressed={language === code}
              onClick={() => setLanguage(language === code ? undefined : code)}>
              {languageLabel(code)}
            </Button>
          ))}
        </div>
        <div className="flex items-center gap-2">
          <input
            type="search"
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            placeholder={t("solutions.searchPlaceholder")}
            aria-label={t("solutions.searchLabel")}
            className="flex-1 rounded-md border border-border bg-background px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <select
            aria-label={t("solutions.sortLabel")}
            value={sort}
            onChange={(e) => {
              setSort(e.target.value as SolutionSort)
              setPage(0)
            }}
            className="rounded-md border border-border bg-background px-2 py-1.5 text-xs focus:outline-none focus:ring-2 focus:ring-ring">
            {SORT_OPTIONS.map((opt) => (
              <option key={opt} value={opt}>
                {t(`solutions.sort.${opt}`)}
              </option>
            ))}
          </select>
          <Button size="sm" onClick={handleShare}>
            {t("solutions.shareYourSolution")}
          </Button>
        </div>
      </div>

      {/* Body */}
      <div className="flex-1 overflow-auto">
        {loading && !state ? (
          <div className="flex justify-center py-8">
            <Spinner />
          </div>
        ) : error ? (
          <div role="alert" className="p-4 text-sm text-destructive">{error}</div>
        ) : !state || state.items.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 px-4 text-center text-muted-foreground">
            <p className="text-sm">{t("solutions.noSolutions")}</p>
          </div>
        ) : (
          <div className="divide-y divide-border">
            {state.items.map((s) => (
              <SolutionCard key={s.id} solution={s} slug={slug} />
            ))}
          </div>
        )}
      </div>

      {/* Pagination */}
      {state && state.totalPages > 1 && (
        <div className="flex items-center justify-between border-t border-border px-3 py-2 text-xs text-muted-foreground">
          <span>
            {t("solutions.pageOf", { current: page + 1, total: state.totalPages })}
          </span>
          <div className="flex gap-1">
            <Button
              variant="ghost"
              size="sm"
              disabled={page === 0}
              onClick={() => setPage((p) => Math.max(0, p - 1))}>
              {t("solutions.prev")}
            </Button>
            <Button
              variant="ghost"
              size="sm"
              disabled={page >= state.totalPages - 1}
              onClick={() => setPage((p) => p + 1)}>
              {t("solutions.next")}
            </Button>
          </div>
        </div>
      )}
    </div>
  )
}

function SolutionCard({ solution, slug }: { solution: SolutionListItem; slug: string }) {
  const { t, i18n } = useTranslation("problem")
  const navigate = useNavigate()
  const netScore = solution.upvotesCount - solution.downvotesCount
  return (
    <button
      type="button"
      onClick={() => navigate(`/problems/${slug}/solutions/${solution.id}`)}
      className="w-full p-4 text-left hover:bg-muted/50 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-ring">
      <div className="flex items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2 mb-1">
            <AuthorAvatar
              avatarUrl={solution.authorAvatarUrl}
              username={solution.authorUsername}
              className="h-5 w-5"
            />
            <span className="text-xs text-muted-foreground">{solution.authorUsername}</span>
            <span className="text-xs text-muted-foreground">
              · {formatDate(solution.createdAt, i18n.language)}
            </span>
          </div>
          <h3 className="text-sm font-semibold text-foreground line-clamp-2">{solution.title}</h3>
          <div className="mt-2 flex flex-wrap items-center gap-1.5">
            {solution.languages.map((l) => (
              <LanguagePill key={l} code={l} />
            ))}
            {solution.tags.map((tag) => (
              <Badge key={tag.slug} variant="outline" className="text-xs">
                {tag.name}
              </Badge>
            ))}
          </div>
        </div>
        <div className="flex flex-col items-end gap-1 font-mono text-xs tabular-nums text-muted-foreground shrink-0">
          <span className="inline-flex items-center gap-0.5 font-semibold text-foreground">
            <ChevronUp aria-hidden="true" className="h-3.5 w-3.5" />
            <span className="sr-only">{t("solutions.score", { n: netScore })}</span>
            <span aria-hidden="true">{netScore}</span>
          </span>
          <span className="inline-flex items-center gap-1">
            <MessageSquare aria-hidden="true" className="h-3 w-3" />
            <span className="sr-only">{t("solutions.commentsCount", { n: solution.commentsCount })}</span>
            <span aria-hidden="true">{solution.commentsCount}</span>
          </span>
        </div>
      </div>
    </button>
  )
}

import { useEffect, useState } from "react"
import { Link, useSearchParams } from "react-router-dom"
import { useProblems } from "../hooks/useProblems"
import { useTags } from "../hooks/useTags"
import DifficultyBadge from "../components/ui/DifficultyBadge"
import { Badge } from "../components/ui/Badge"
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
import type { Difficulty } from "../types/problem"

const DIFFICULTIES: Difficulty[] = ["EASY", "MEDIUM", "HARD"]

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
        isActive ? "text-foreground" : "text-muted-foreground"
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
  const [searchParams, setSearchParams] = useSearchParams()
  const page = Number(searchParams.get("page") || "0")
  const difficulty = (searchParams.get("difficulty") as Difficulty) || undefined
  const search = searchParams.get("search") || ""
  const sort = searchParams.get("sort") || "id,asc"
  const tag = searchParams.get("tag") || ""
  const [searchInput, setSearchInput] = useState(search)
  const { tags } = useTags()
  const { data, loading, error } = useProblems(
    page, 20, difficulty, search || undefined, sort, tag || undefined
  )

  useEffect(() => {
    document.title = "Problems | CodeBite"
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

  const setDifficulty = (value: string) => {
    const params = new URLSearchParams(searchParams)
    if (value && value !== "ALL") {
      params.set("difficulty", value)
    } else {
      params.delete("difficulty")
    }
    params.set("page", "0")
    setSearchParams(params)
  }

  const setSort = (value: string) => {
    const params = new URLSearchParams(searchParams)
    params.set("sort", value)
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
    <div className="max-w-5xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-4">
        <h1 className="text-2xl font-bold text-foreground">Problems</h1>
        <div className="flex items-center gap-3">
          <Input
            placeholder="Search problems..."
            value={searchInput}
            onChange={(e) => setSearchInput(e.target.value)}
            inputSize="sm"
            className="w-[200px]"
          />
          <Select
            value={difficulty || "ALL"}
            onValueChange={setDifficulty}
          >
            <SelectTrigger className="w-[160px]">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="ALL">All Difficulties</SelectItem>
              {DIFFICULTIES.map((d) => (
                <SelectItem key={d} value={d}>
                  {d}
                </SelectItem>
              ))}
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
              className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium transition-colors cursor-pointer ${
                tag === t.slug
                  ? "bg-primary text-primary-foreground"
                  : "bg-secondary text-secondary-foreground hover:bg-secondary/80"
              }`}
            >
              {t.name}
            </button>
          ))}
        </div>
      )}

      {loading && <Spinner />}
      {error && <p className="text-destructive">{error}</p>}

      {data && data.content.length === 0 && (
        <p className="text-muted-foreground text-center py-12">
          No problems found.
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
                  <SortableHeader label="#" field="id" currentSort={sort} onSort={setSort} className="w-16" />
                  <SortableHeader label="Title" field="title" currentSort={sort} onSort={setSort} />
                  <SortableHeader label="Difficulty" field="difficulty" currentSort={sort} onSort={setSort} className="w-28" />
                  <th className="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase w-28">
                    Acceptance
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-border">
                {data.content.map((problem) => (
                  <tr
                    key={problem.id}
                    className="hover:bg-muted/50 transition-colors"
                  >
                    <td className="px-4 py-3 text-center">
                      <StatusIcon status={problem.status} />
                    </td>
                    <td className="px-4 py-3 text-sm text-muted-foreground">
                      {problem.id}
                    </td>
                    <td className="px-4 py-3">
                      <div className="flex items-center gap-2">
                        <Link
                          to={`/problems/${problem.slug}`}
                          className="text-primary hover:underline font-medium"
                        >
                          {problem.title}
                        </Link>
                        {problem.tags.length > 0 && (
                          <div className="flex gap-1">
                            {problem.tags.map((t) => (
                              <Badge key={t} variant="secondary" className="text-[10px] px-1.5 py-0">
                                {t}
                              </Badge>
                            ))}
                          </div>
                        )}
                      </div>
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
                Previous
              </Button>
              <span className="text-sm text-muted-foreground">
                Page {data.number + 1} of {data.totalPages}
              </span>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setPage(page + 1)}
                disabled={data.last}
              >
                Next
              </Button>
            </div>
          )}
        </>
      )}
    </div>
  )
}

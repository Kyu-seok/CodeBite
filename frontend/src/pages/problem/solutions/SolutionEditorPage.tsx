import { useEffect, useMemo, useRef, useState } from "react"
import { useNavigate, useParams, useSearchParams } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ArrowLeft } from "lucide-react"
import { AxiosError } from "axios"
import { Button } from "@/components/ui/Button"
import Spinner from "@/components/ui/Spinner"
import { useAuth } from "@/context/AuthContext"
import {
  createSolution,
  getSolution,
  updateSolution,
} from "@/api/solutions"
import { getSubmission } from "@/api/submissions"
import type { ApiError } from "@/types/api"
import { LanguagePill, SUPPORTED_LANGUAGES, languageLabel } from "./LanguagePill"
import { MarkdownEditor } from "./MarkdownEditor"
import { TagPicker } from "./TagPicker"

interface SolutionEditorPageProps {
  mode: "create" | "edit"
}

interface DraftPayload {
  title: string
  content: string
  languages: string[]
  tagSlugs: string[]
}

const TITLE_MAX = 100
const CONTENT_MIN = 50
const CONTENT_MAX = 50_000

function emptyDraft(): DraftPayload {
  return { title: "", content: "", languages: [], tagSlugs: [] }
}

export default function SolutionEditorPage({ mode }: SolutionEditorPageProps) {
  const { t } = useTranslation("problem")
  const navigate = useNavigate()
  const { user } = useAuth()
  const { slug, solutionId } = useParams<{ slug: string; solutionId: string }>()
  const [searchParams] = useSearchParams()

  const draftKey = useMemo(
    () => (slug && user ? `solution-draft:${slug}:${user.id}` : null),
    [slug, user],
  )

  const [draft, setDraft] = useState<DraftPayload>(emptyDraft)
  const [loading, setLoading] = useState(mode === "edit")
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const seededRef = useRef(false)

  // Seed: localStorage draft for create mode, or fetched solution for edit mode.
  useEffect(() => {
    if (seededRef.current) return
    if (mode === "edit" && solutionId) {
      seededRef.current = true
      getSolution(Number(solutionId))
        .then((res) => {
          setDraft({
            title: res.data.title,
            content: res.data.content,
            languages: res.data.languages,
            tagSlugs: res.data.tags.map((t) => t.slug),
          })
          if (!res.data.ownedByViewer && user?.role !== "ADMIN") {
            navigate(`/problems/${slug}/solutions/${solutionId}`, { replace: true })
          }
        })
        .catch(() => setError(t("solutions.failedToLoad")))
        .finally(() => setLoading(false))
      return
    }

    if (mode === "create") {
      seededRef.current = true
      const fromSubmissionId = searchParams.get("fromSubmission")
      if (draftKey) {
        try {
          const stored = localStorage.getItem(draftKey)
          if (stored) {
            const parsed = JSON.parse(stored) as DraftPayload
            setDraft(parsed)
          }
        } catch {
          // ignore
        }
      }
      if (fromSubmissionId) {
        getSubmission(Number(fromSubmissionId)).then((res) => {
          const lang = res.data.language
          const fence = "```" + lang + "\n" + res.data.sourceCode + "\n```"
          setDraft((prev) => {
            if (prev.content) return prev
            return {
              ...prev,
              content: `## My Approach\n\n_Describe your idea here._\n\n## Code\n\n${fence}\n`,
              languages: prev.languages.length > 0 ? prev.languages : [lang],
            }
          })
        })
      }
    }
  }, [mode, solutionId, slug, draftKey, searchParams, navigate, user, t])

  // Persist draft (create mode only).
  useEffect(() => {
    if (mode !== "create" || !draftKey) return
    const handle = setTimeout(() => {
      try {
        localStorage.setItem(draftKey, JSON.stringify(draft))
      } catch {
        // ignore
      }
    }, 300)
    return () => clearTimeout(handle)
  }, [draft, draftKey, mode])

  const toggleLanguage = (lang: string) => {
    setDraft((prev) => ({
      ...prev,
      languages: prev.languages.includes(lang)
        ? prev.languages.filter((l) => l !== lang)
        : [...prev.languages, lang],
    }))
  }

  const validate = (): string | null => {
    if (draft.title.trim().length < 5) return t("solutions.editor.titleTooShort")
    if (draft.title.length > TITLE_MAX) return t("solutions.editor.titleTooLong")
    if (draft.content.length < CONTENT_MIN) return t("solutions.editor.contentTooShort")
    if (draft.content.length > CONTENT_MAX) return t("solutions.editor.contentTooLong")
    if (draft.languages.length === 0) return t("solutions.editor.languagesRequired")
    return null
  }

  const handlePublish = async () => {
    const validationError = validate()
    if (validationError) {
      setError(validationError)
      return
    }
    setSubmitting(true)
    setError(null)
    try {
      if (mode === "create") {
        const fromSubmissionId = searchParams.get("fromSubmission")
        const res = await createSolution(slug!, {
          title: draft.title.trim(),
          content: draft.content,
          languages: draft.languages,
          tagSlugs: draft.tagSlugs,
          fromSubmissionId: fromSubmissionId ? Number(fromSubmissionId) : null,
        })
        if (draftKey) localStorage.removeItem(draftKey)
        navigate(`/problems/${slug}/solutions/${res.data.id}`, { replace: true })
      } else {
        await updateSolution(Number(solutionId), {
          title: draft.title.trim(),
          content: draft.content,
          languages: draft.languages,
          tagSlugs: draft.tagSlugs,
        })
        navigate(`/problems/${slug}/solutions/${solutionId}`, { replace: true })
      }
    } catch (err) {
      if (err instanceof AxiosError && err.response?.data) {
        setError((err.response.data as ApiError).message ?? t("solutions.editor.publishFailed"))
      } else {
        setError(t("solutions.editor.publishFailed"))
      }
    } finally {
      setSubmitting(false)
    }
  }

  if (loading) {
    return (
      <div className="flex h-[calc(100vh-3.5rem)] items-center justify-center">
        <Spinner />
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-6">
      <button
        onClick={() => navigate(`/problems/${slug}`)}
        className="mb-4 inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-3.5 w-3.5" />
        {t("solutions.backToProblem")}
      </button>

      <h1 className="text-2xl font-bold text-foreground">
        {mode === "create" ? t("solutions.create") : t("solutions.edit")}
      </h1>

      <div className="mt-4 space-y-4">
        <div>
          <label className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.title")}
          </label>
          <input
            type="text"
            value={draft.title}
            onChange={(e) =>
              setDraft((prev) => ({ ...prev, title: e.target.value.slice(0, TITLE_MAX) }))
            }
            maxLength={TITLE_MAX}
            placeholder={t("solutions.editor.titlePlaceholder")}
            className="mt-1 w-full rounded-md border border-border bg-background px-3 py-2 text-base focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <p className="mt-1 text-xs text-muted-foreground">
            {draft.title.length}/{TITLE_MAX}
          </p>
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.languages")}
          </label>
          <div className="mt-1 flex flex-wrap items-center gap-1.5">
            {SUPPORTED_LANGUAGES.map((code) => {
              const selected = draft.languages.includes(code)
              return (
                <button
                  key={code}
                  type="button"
                  onClick={() => toggleLanguage(code)}
                  className="focus:outline-none">
                  {selected ? (
                    <LanguagePill code={code} className="ring-2 ring-ring" />
                  ) : (
                    <span className="inline-flex items-center rounded-md border border-border bg-background px-2 py-0.5 text-xs text-muted-foreground hover:bg-muted">
                      {languageLabel(code)}
                    </span>
                  )}
                </button>
              )
            })}
          </div>
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.tags")}
          </label>
          <div className="mt-1">
            <TagPicker
              selected={draft.tagSlugs}
              onChange={(tagSlugs) => setDraft((prev) => ({ ...prev, tagSlugs }))}
            />
          </div>
        </div>

        <div>
          <label className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.content")}
          </label>
          <div className="mt-1">
            <MarkdownEditor
              value={draft.content}
              onChange={(content) => setDraft((prev) => ({ ...prev, content }))}
              maxLength={CONTENT_MAX}
            />
          </div>
        </div>

        {error && (
          <div className="rounded-md border border-error-200 bg-error-100 p-3 text-sm text-error-700">
            {error}
          </div>
        )}

        <div className="flex items-center justify-end gap-2">
          <Button variant="outline" onClick={() => navigate(`/problems/${slug}`)}>
            {t("solutions.editor.cancel")}
          </Button>
          <Button variant="accent" disabled={submitting} onClick={handlePublish}>
            {submitting
              ? t("solutions.editor.publishing")
              : mode === "create"
              ? t("solutions.editor.publish")
              : t("solutions.editor.update")}
          </Button>
        </div>
      </div>
    </div>
  )
}

import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { Link, useNavigate, useParams, useSearchParams } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ArrowLeft } from "lucide-react"
import { AxiosError } from "axios"
import { Button } from "@/components/ui/Button"
import Spinner from "@/components/ui/Spinner"
import LoadError from "@/components/ui/LoadError"
import { useAuth } from "@/context/AuthContext"
import {
  createSolution,
  getSolution,
  updateSolution,
} from "@/api/solutions"
import { getSubmission } from "@/api/submissions"
import type { ApiError } from "@/types/api"
import { LanguagePill } from "./LanguagePill"
import { SUPPORTED_LANGUAGES, languageLabel } from "../submissionDisplay"
import { MarkdownEditor } from "./MarkdownEditor"
import { TagPicker } from "./TagPicker"
import { ConfirmDialog } from "../ConfirmDialog"
import { draftChanged, type SolutionDraft } from "@/lib/draftChanged"

interface SolutionEditorPageProps {
  mode: "create" | "edit"
}

type Field = "title" | "languages" | "content"
type FieldErrors = Partial<Record<Field, string>>

const TITLE_MIN = 5
const TITLE_MAX = 100
const CONTENT_MIN = 50
const CONTENT_MAX = 50_000

const fieldError = "mt-1 text-xs text-error-700 dark:text-error-400"
const fieldHint = "mt-1 text-xs text-muted-foreground"

function emptyDraft(): SolutionDraft {
  return { title: "", content: "", languages: [], tagSlugs: [] }
}

export default function SolutionEditorPage({ mode }: SolutionEditorPageProps) {
  const { t } = useTranslation("problem")
  const navigate = useNavigate()
  const { user } = useAuth()
  const { slug, solutionId } = useParams<{ slug: string; solutionId: string }>()
  const [searchParams] = useSearchParams()
  const fromSubmissionId = searchParams.get("fromSubmission")
  const problemPath = `/problems/${slug}`

  const draftKey = useMemo(
    () => (slug && user ? `solution-draft:${slug}:${user.id}` : null),
    [slug, user],
  )

  const [draft, setDraft] = useState<SolutionDraft>(emptyDraft)
  // The solution as loaded, so edit mode knows when there's something to lose.
  const [original, setOriginal] = useState<SolutionDraft | null>(null)
  const [ownedByViewer, setOwnedByViewer] = useState<boolean | null>(null)
  const [loading, setLoading] = useState(mode === "edit")
  const [loadFailed, setLoadFailed] = useState(false)
  const [loadAttempt, setLoadAttempt] = useState(0)
  const [seedFailed, setSeedFailed] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [errors, setErrors] = useState<FieldErrors>({})
  const [publishError, setPublishError] = useState<string | null>(null)
  const [draftSaved, setDraftSaved] = useState(false)
  // Where an in-app link or Cancel would take the user, while the leave dialog asks
  const [leaveTo, setLeaveTo] = useState<string | null>(null)
  const [confirmingDiscard, setConfirmingDiscard] = useState(false)
  const seededRef = useRef(false)
  const titleRef = useRef<HTMLInputElement>(null)
  const languagesRef = useRef<HTMLDivElement>(null)

  const dirty = mode === "edit" && original !== null && draftChanged(original, draft)

  useEffect(() => {
    document.title = `${mode === "create" ? t("solutions.create") : t("solutions.edit")} | CodeBite`
  }, [mode, t])

  // Edit mode: load the solution. A failed load shows an error, never an empty form that could
  // be published over the real solution.
  useEffect(() => {
    if (mode !== "edit" || !solutionId) return
    getSolution(Number(solutionId))
      .then((res) => {
        const loaded = {
          title: res.data.title,
          content: res.data.content,
          languages: res.data.languages,
          tagSlugs: res.data.tags.map((tag) => tag.slug),
        }
        setDraft(loaded)
        setOriginal(loaded)
        setOwnedByViewer(res.data.ownedByViewer)
      })
      .catch(() => setLoadFailed(true))
      .finally(() => setLoading(false))
  }, [mode, solutionId, loadAttempt])

  // Someone else's solution: back to reading it (admins may edit any).
  useEffect(() => {
    if (ownedByViewer === false && user?.role !== "ADMIN") {
      navigate(`/problems/${slug}/solutions/${solutionId}`, { replace: true })
    }
  }, [ownedByViewer, user, navigate, slug, solutionId])

  const retryLoad = () => {
    setLoadFailed(false)
    setLoading(true)
    setLoadAttempt((n) => n + 1)
  }

  // "Share as Solution" from an Accepted submission: start the content from its code.
  const seedFromSubmission = useCallback(
    (id: string) => {
      getSubmission(Number(id))
        .then((res) => {
          const lang = res.data.language
          const fence = "```" + lang + "\n" + res.data.sourceCode + "\n```"
          setDraft((prev) => {
            if (prev.content) return prev
            return {
              ...prev,
              content: t("solutions.seedTemplate", { code: fence, interpolation: { escapeValue: false } }),
              languages: prev.languages.length > 0 ? prev.languages : [lang],
            }
          })
        })
        .catch(() => setSeedFailed(true))
    },
    [t],
  )

  // Create mode: restore this device's draft, then seed from the submission if there is one.
  useEffect(() => {
    if (mode !== "create" || seededRef.current) return
    seededRef.current = true
    if (draftKey) {
      try {
        const stored = localStorage.getItem(draftKey)
        if (stored) setDraft(JSON.parse(stored) as SolutionDraft)
      } catch {
        // ignore
      }
    }
    if (fromSubmissionId) seedFromSubmission(fromSubmissionId)
  }, [mode, draftKey, fromSubmissionId, seedFromSubmission])

  // Persist the draft (create mode only), and say so quietly.
  useEffect(() => {
    if (mode !== "create" || !draftKey) return
    const handle = setTimeout(() => {
      try {
        localStorage.setItem(draftKey, JSON.stringify(draft))
        setDraftSaved(draftChanged(emptyDraft(), draft))
      } catch {
        // ignore
      }
    }, 300)
    return () => clearTimeout(handle)
  }, [draft, draftKey, mode])

  const forgetDraft = () => {
    if (!draftKey) return
    try {
      localStorage.removeItem(draftKey)
    } catch {
      // ignore
    }
  }

  // Edit mode: any in-app link (the Back link, the nav bar) asks before leaving unsaved edits.
  // The browser's own Back button can't be caught under BrowserRouter.
  useEffect(() => {
    if (!dirty) return
    const guard = (e: MouseEvent) => {
      if (e.defaultPrevented || e.button !== 0 || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return
      const link = e.target instanceof Element ? e.target.closest<HTMLAnchorElement>("a[href]") : null
      if (!link || link.target === "_blank" || link.hasAttribute("download")) return
      const url = new URL(link.href)
      if (url.origin !== window.location.origin) return
      e.preventDefault()
      e.stopPropagation()
      setLeaveTo(url.pathname + url.search + url.hash)
    }
    document.addEventListener("click", guard, true)
    return () => document.removeEventListener("click", guard, true)
  }, [dirty])

  // Edit mode: closing or reloading the tab with unsaved edits asks first.
  useEffect(() => {
    if (!dirty) return
    const warn = (e: BeforeUnloadEvent) => e.preventDefault()
    window.addEventListener("beforeunload", warn)
    return () => window.removeEventListener("beforeunload", warn)
  }, [dirty])

  const update = (field: keyof SolutionDraft, value: SolutionDraft[keyof SolutionDraft]) => {
    setDraft((prev) => ({ ...prev, [field]: value }))
    if (field in errors) setErrors((prev) => ({ ...prev, [field]: undefined }))
  }

  // From the latest state, so two quick toggles before a re-render both count.
  const toggleLanguage = (lang: string) => {
    setDraft((prev) => ({
      ...prev,
      languages: prev.languages.includes(lang)
        ? prev.languages.filter((l) => l !== lang)
        : [...prev.languages, lang],
    }))
    if ("languages" in errors) setErrors((prev) => ({ ...prev, languages: undefined }))
  }

  // Every rule at once, in the order the fields appear.
  const validate = (): FieldErrors => {
    const next: FieldErrors = {}
    const title = draft.title.trim()
    if (title.length < TITLE_MIN) next.title = t("solutions.editor.titleTooShort")
    else if (title.length > TITLE_MAX) next.title = t("solutions.editor.titleTooLong")
    if (draft.languages.length === 0) next.languages = t("solutions.editor.languagesRequired")
    if (draft.content.length < CONTENT_MIN) next.content = t("solutions.editor.contentTooShort")
    else if (draft.content.length > CONTENT_MAX) next.content = t("solutions.editor.contentTooLong")
    return next
  }

  const focusField = (field: Field) => {
    if (field === "title") titleRef.current?.focus()
    else if (field === "languages") languagesRef.current?.querySelector("button")?.focus()
    else document.getElementById("solution-content")?.focus()
  }

  const handlePublish = async () => {
    const found = validate()
    setErrors(found)
    const first = (["title", "languages", "content"] as const).find((f) => found[f])
    if (first) {
      focusField(first)
      return
    }
    setSubmitting(true)
    setPublishError(null)
    try {
      if (mode === "create") {
        const res = await createSolution(slug!, {
          title: draft.title.trim(),
          content: draft.content,
          languages: draft.languages,
          tagSlugs: draft.tagSlugs,
          fromSubmissionId: fromSubmissionId ? Number(fromSubmissionId) : null,
        })
        forgetDraft()
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
        setPublishError((err.response.data as ApiError).message ?? t("solutions.editor.publishFailed"))
      } else {
        setPublishError(t("solutions.editor.publishFailed"))
      }
    } finally {
      setSubmitting(false)
    }
  }

  const leave = () => {
    if (dirty) setLeaveTo(problemPath)
    else navigate(problemPath)
  }

  const discardDraft = () => {
    forgetDraft()
    setConfirmingDiscard(false)
    navigate(problemPath)
  }

  const describedBy = (field: Field) =>
    [`solution-${field}-hint`, errors[field] ? `solution-${field}-error` : null].filter(Boolean).join(" ")

  if (loading) {
    return (
      <div className="flex h-[calc(100dvh-3.5rem)] items-center justify-center">
        <Spinner />
      </div>
    )
  }

  if (loadFailed) {
    return (
      <div className="mx-auto max-w-md px-4 py-20">
        <h1 className="sr-only">{t("solutions.edit")}</h1>
        <LoadError message={t("solutions.editor.loadFailed")} onRetry={retryLoad} />
        <p className="text-center text-sm">
          <Link to={problemPath} className="text-muted-foreground underline-offset-4 hover:text-foreground hover:underline">
            {t("solutions.backToProblem")}
          </Link>
        </p>
      </div>
    )
  }

  return (
    <div className="mx-auto max-w-5xl px-4 py-6">
      <Link
        to={problemPath}
        className="mb-4 inline-flex items-center gap-1 rounded-sm text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft aria-hidden className="h-3.5 w-3.5" />
        {t("solutions.backToProblem")}
      </Link>

      <h1 className="text-2xl font-bold text-foreground">
        {mode === "create" ? t("solutions.create") : t("solutions.edit")}
      </h1>

      <div className="mt-4 space-y-4">
        <div>
          <label htmlFor="solution-title" className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.title")}
          </label>
          <input
            id="solution-title"
            ref={titleRef}
            type="text"
            value={draft.title}
            onChange={(e) => update("title", e.target.value.slice(0, TITLE_MAX))}
            maxLength={TITLE_MAX}
            aria-describedby={describedBy("title")}
            aria-invalid={errors.title ? true : undefined}
            placeholder={t("solutions.editor.titlePlaceholder")}
            className="mt-1 w-full rounded-md border border-border bg-background px-3 py-2 text-base focus:outline-none focus:ring-2 focus:ring-ring aria-invalid:border-error-500"
          />
          <div className="flex items-baseline justify-between gap-3">
            <p id="solution-title-hint" className={fieldHint}>
              {t("solutions.editor.titleHint")}
            </p>
            <p aria-hidden className="mt-1 font-mono text-xs tabular-nums text-muted-foreground">
              {draft.title.length}/{TITLE_MAX}
            </p>
          </div>
          {errors.title && (
            <p id="solution-title-error" className={fieldError}>
              {errors.title}
            </p>
          )}
        </div>

        <div>
          <p id="solution-languages" className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.languages")}
          </p>
          <div
            ref={languagesRef}
            role="group"
            aria-labelledby="solution-languages"
            aria-describedby={describedBy("languages")}
            className="mt-1 flex flex-wrap items-center gap-1.5">
            {SUPPORTED_LANGUAGES.map((code) => {
              const selected = draft.languages.includes(code)
              return (
                <button
                  key={code}
                  type="button"
                  aria-pressed={selected}
                  onClick={() => toggleLanguage(code)}
                  className="rounded-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2">
                  {selected ? (
                    <LanguagePill code={code} className="bg-accent-100 text-accent-700 ring-1 ring-accent-700 dark:bg-accent-950 dark:text-accent-400 dark:ring-accent-400" />
                  ) : (
                    <span className="inline-flex items-center rounded-md border border-border bg-background px-2 py-0.5 text-xs text-muted-foreground hover:bg-muted">
                      {languageLabel(code)}
                    </span>
                  )}
                </button>
              )
            })}
          </div>
          <p id="solution-languages-hint" className={fieldHint}>
            {t("solutions.editor.languagesHint")}
          </p>
          {errors.languages && (
            <p id="solution-languages-error" className={fieldError}>
              {errors.languages}
            </p>
          )}
        </div>

        <div>
          <p id="solution-tags" className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.tags")}
          </p>
          <div className="mt-1" role="group" aria-labelledby="solution-tags">
            <TagPicker
              selected={draft.tagSlugs}
              onChange={(tagSlugs) => update("tagSlugs", tagSlugs)}
            />
          </div>
        </div>

        <div>
          <label htmlFor="solution-content" className="text-xs font-medium text-muted-foreground">
            {t("solutions.editor.content")}
          </label>
          <p id="solution-content-hint" className={fieldHint}>
            {t("solutions.editor.contentHint")}
          </p>
          {seedFailed && fromSubmissionId && (
            <p role="alert" className="mt-1 flex flex-wrap items-center gap-2 text-xs text-error-700 dark:text-error-400">
              {t("solutions.editor.seedFailed")}
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={() => {
                  setSeedFailed(false)
                  seedFromSubmission(fromSubmissionId)
                }}>
                {t("solutions.retry")}
              </Button>
            </p>
          )}
          <div className="mt-1">
            <MarkdownEditor
              id="solution-content"
              value={draft.content}
              onChange={(content) => update("content", content)}
              maxLength={CONTENT_MAX}
              describedBy={describedBy("content")}
              invalid={Boolean(errors.content)}
            />
          </div>
          {errors.content && (
            <p id="solution-content-error" className={fieldError}>
              {errors.content}
            </p>
          )}
        </div>

        {publishError && (
          <div role="alert" className="rounded-md border border-error-200 bg-error-100 p-3 text-sm text-error-700 dark:border-error-900 dark:bg-error-950 dark:text-error-400">
            {publishError}
          </div>
        )}

        <div className="flex flex-wrap items-center justify-end gap-2">
          {mode === "create" && (
            <p role="status" className="mr-auto text-xs text-muted-foreground">
              {draftSaved ? t("solutions.editor.draftSaved") : ""}
            </p>
          )}
          {mode === "create" && draftSaved && (
            <Button variant="ghost" onClick={() => setConfirmingDiscard(true)}>
              {t("solutions.editor.discardDraft")}
            </Button>
          )}
          <Button variant="outline" onClick={leave}>
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

      <ConfirmDialog
        open={leaveTo !== null}
        title={t("solutions.editor.discardChangesTitle")}
        description={t("solutions.editor.discardChangesBody")}
        confirmLabel={t("solutions.editor.discardChanges")}
        onConfirm={() => {
          const to = leaveTo ?? problemPath
          setLeaveTo(null)
          navigate(to)
        }}
        onCancel={() => setLeaveTo(null)}
      />
      <ConfirmDialog
        open={confirmingDiscard}
        title={t("solutions.editor.discardDraftTitle")}
        description={t("solutions.editor.discardDraftBody")}
        confirmLabel={t("solutions.editor.discardDraft")}
        onConfirm={discardDraft}
        onCancel={() => setConfirmingDiscard(false)}
      />
    </div>
  )
}

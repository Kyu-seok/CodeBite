import { useEffect, useState } from "react"
import { useNavigate, useParams } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { ArrowLeft, Flag, Pencil, Trash2 } from "lucide-react"
import { Button } from "@/components/ui/Button"
import { Badge } from "@/components/ui/Badge"
import Spinner from "@/components/ui/Spinner"
import { useAuth } from "@/context/AuthContext"
import { MarkdownRenderer } from "@/components/markdown/MarkdownRenderer"
import { deleteSolution, getSolution, reportSolution } from "@/api/solutions"
import { LanguagePill } from "./LanguagePill"
import { VoteBar } from "./VoteBar"
import { ReportDialog } from "./ReportDialog"
import { CommentThread } from "./CommentThread"
import { AuthorAvatar } from "./AuthorAvatar"
import { ConfirmDialog } from "../ConfirmDialog"
import { formatDate } from "../submissionDisplay"
import { useComments } from "@/hooks/useSolutions"
import type { SolutionDetail } from "@/types/solution"

export default function SolutionDetailPage() {
  const { t, i18n } = useTranslation("problem")
  const { user } = useAuth()
  const navigate = useNavigate()
  const { slug, solutionId } = useParams<{ slug: string; solutionId: string }>()
  const id = solutionId ? Number(solutionId) : null

  const [solution, setSolution] = useState<SolutionDetail | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [reportOpen, setReportOpen] = useState(false)
  const [confirmingDelete, setConfirmingDelete] = useState(false)
  const [actionError, setActionError] = useState<string | null>(null)
  const { comments, setComments } = useComments(id)

  useEffect(() => {
    if (id == null) return
    let cancelled = false
    setLoading(true)
    getSolution(id)
      .then((res) => {
        if (!cancelled) setSolution(res.data)
      })
      .catch(() => {
        if (!cancelled) setError(t("solutions.failedToLoad"))
      })
      .finally(() => {
        if (!cancelled) setLoading(false)
      })
    return () => {
      cancelled = true
    }
  }, [id, t])

  if (loading) {
    return (
      <div className="flex h-[calc(100dvh-3.5rem)] items-center justify-center">
        <Spinner />
      </div>
    )
  }

  if (error || !solution) {
    return (
      <div className="flex h-[calc(100dvh-3.5rem)] items-center justify-center">
        <p className="text-sm text-destructive">{error ?? t("solutions.failedToLoad")}</p>
      </div>
    )
  }

  const canEdit = solution.ownedByViewer || user?.role === "ADMIN"

  const handleDelete = async () => {
    setConfirmingDelete(false)
    setActionError(null)
    try {
      await deleteSolution(solution.id)
      navigate(`/problems/${slug}`)
    } catch {
      setActionError(t("solutions.deleteFailed"))
    }
  }

  return (
    <div className="mx-auto max-w-3xl px-4 py-6">
      <button
        onClick={() => navigate(`/problems/${slug}`)}
        className="mb-4 inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-3.5 w-3.5" />
        {t("solutions.backToProblem")}
      </button>

      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0 flex-1">
          <h1 className="text-2xl font-bold text-foreground">{solution.title}</h1>
          <div className="mt-2 flex items-center gap-2 text-sm text-muted-foreground">
            <AuthorAvatar
              avatarUrl={solution.authorAvatarUrl}
              username={solution.authorUsername}
            />
            <span className="font-medium text-foreground">{solution.authorUsername}</span>
            <span>· {formatDate(solution.createdAt, i18n.language)}</span>
          </div>
          <div className="mt-3 flex flex-wrap items-center gap-1.5">
            {solution.languages.map((l) => (
              <LanguagePill key={l} code={l} />
            ))}
            {solution.tags.map((tag) => (
              <Badge key={tag.slug} variant="outline">
                {tag.name}
              </Badge>
            ))}
          </div>
        </div>
        <VoteBar
          solution={solution}
          slug={slug ?? ""}
          onChange={(next) =>
            setSolution((prev) => (prev ? { ...prev, ...next } : prev))
          }
        />
      </div>

      <div className="my-4 flex items-center justify-end gap-2">
        {canEdit && (
          <>
            <Button
              variant="outline"
              size="sm"
              onClick={() => navigate(`/problems/${slug}/solutions/${solution.id}/edit`)}>
              <Pencil className="h-3.5 w-3.5" />
              {t("solutions.edit")}
            </Button>
            <Button variant="destructive" size="sm" onClick={() => setConfirmingDelete(true)}>
              <Trash2 className="h-3.5 w-3.5" />
              {t("solutions.delete")}
            </Button>
          </>
        )}
        {!solution.ownedByViewer && (
          <Button variant="ghost" size="sm" onClick={() => setReportOpen(true)}>
            <Flag className="h-3.5 w-3.5" />
            {t("solutions.report")}
          </Button>
        )}
      </div>

      {actionError && (
        <p role="alert" className="text-right text-xs text-destructive">{actionError}</p>
      )}

      <MarkdownRenderer source={solution.content} className="my-6" />

      <hr className="my-6 border-border" />

      <h2 className="mb-3 text-lg font-semibold text-foreground">
        {t("solutions.comments.heading", { count: solution.commentsCount })}
      </h2>
      <CommentThread
        solutionId={solution.id}
        slug={slug ?? ""}
        comments={comments}
        onChange={setComments}
      />

      <ConfirmDialog
        open={confirmingDelete}
        title={t("solutions.confirmDelete")}
        description={solution.title}
        confirmLabel={t("solutions.delete")}
        onConfirm={handleDelete}
        onCancel={() => setConfirmingDelete(false)}
      />
      <ReportDialog
        open={reportOpen}
        onClose={() => setReportOpen(false)}
        onSubmit={async (reason) => {
          await reportSolution(solution.id, { reason })
        }}
      />
    </div>
  )
}

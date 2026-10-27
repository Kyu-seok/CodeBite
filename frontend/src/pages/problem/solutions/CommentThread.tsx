import { useRef, useState, type RefObject } from "react"
import { useNavigate } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { Button } from "@/components/ui/Button"
import { useAuth } from "@/context/AuthContext"
import {
  createComment,
  deleteComment,
  reportComment,
  updateComment,
} from "@/api/solutions"
import { ReportDialog } from "./ReportDialog"
import { AuthorAvatar } from "./AuthorAvatar"
import { ConfirmDialog } from "../ConfirmDialog"
import { formatDate } from "../submissionDisplay"
import type { SolutionComment } from "@/types/solution"

interface CommentThreadProps {
  solutionId: number
  slug: string
  comments: SolutionComment[]
  onChange: (comments: SolutionComment[]) => void
}

const errorText = "mt-1 text-xs text-error-700 dark:text-error-400"
const actionClass =
  "rounded px-1 py-0.5 hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"

/** Signing in from a solution comes back to it. */
function useRequireAuth(slug: string, solutionId: number) {
  const navigate = useNavigate()
  return () => {
    sessionStorage.setItem("returnUrl", `/problems/${slug}/solutions/${solutionId}`)
    navigate("/login")
  }
}

export function CommentThread({ solutionId, slug, comments, onChange }: CommentThreadProps) {
  const { t } = useTranslation("problem")
  const { isAuthenticated } = useAuth()
  const requireAuth = useRequireAuth(slug, solutionId)
  const [composer, setComposer] = useState("")
  const [submitting, setSubmitting] = useState(false)
  const [composerError, setComposerError] = useState<string | null>(null)
  const composerRef = useRef<HTMLTextAreaElement>(null)

  const submitTopLevel = async () => {
    const content = composer.trim()
    if (!content || submitting) return
    setSubmitting(true)
    setComposerError(null)
    try {
      const res = await createComment(solutionId, { content })
      onChange([...comments, res.data])
      setComposer("")
    } catch {
      setComposerError(t("solutions.comments.failed"))
    } finally {
      setSubmitting(false)
    }
  }

  // A deleted comment takes its focused button with it; land on the composer instead of <body>.
  const afterDelete = (next: SolutionComment[]) => {
    onChange(next)
    requestAnimationFrame(() => composerRef.current?.focus())
  }

  return (
    <div className="space-y-4">
      {isAuthenticated ? (
        <div>
          <textarea
            ref={composerRef}
            aria-label={t("solutions.comments.label")}
            value={composer}
            onChange={(e) => setComposer(e.target.value)}
            maxLength={2000}
            rows={3}
            placeholder={t("solutions.comments.composerPlaceholder")}
            className="w-full resize-y rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <div className="mt-2 flex items-center justify-between">
            <span className="font-mono text-xs tabular-nums text-muted-foreground">
              {composer.length}/2000
            </span>
            <Button
              size="sm"
              disabled={!composer.trim() || submitting}
              onClick={submitTopLevel}>
              {submitting ? t("solutions.comments.posting") : t("solutions.comments.submit")}
            </Button>
          </div>
          {composerError && (
            <p role="alert" className={errorText}>{composerError}</p>
          )}
        </div>
      ) : (
        // Signed out: offer sign-in up front instead of a composer whose text the redirect drops.
        <div className="flex flex-wrap items-center justify-between gap-3 rounded-md border border-dashed border-border px-3 py-3">
          <p className="text-sm text-muted-foreground">{t("solutions.comments.signInPrompt")}</p>
          <Button size="sm" variant="outline" onClick={requireAuth}>
            {t("solutions.comments.signIn")}
          </Button>
        </div>
      )}

      {comments.length === 0 ? (
        <p className="text-sm text-muted-foreground">{t("solutions.comments.empty")}</p>
      ) : (
        <ul className="space-y-3">
          {comments.map((c) => (
            <CommentItem
              key={c.id}
              comment={c}
              solutionId={solutionId}
              slug={slug}
              isAuthenticated={isAuthenticated}
              onAddReply={(reply) => {
                const next = comments.map((existing) =>
                  existing.id === c.id
                    ? { ...existing, replies: [...existing.replies, reply] }
                    : existing,
                )
                onChange(next)
              }}
              onUpdate={(updated) => {
                const next = comments.map((existing) =>
                  existing.id === c.id ? { ...existing, ...updated } : existing,
                )
                onChange(next)
              }}
              onUpdateReply={(replyId, updated) => {
                const next = comments.map((existing) =>
                  existing.id === c.id
                    ? {
                        ...existing,
                        replies: existing.replies.map((r) =>
                          r.id === replyId ? { ...r, ...updated } : r,
                        ),
                      }
                    : existing,
                )
                onChange(next)
              }}
              onDelete={() => afterDelete(comments.filter((existing) => existing.id !== c.id))}
              onDeleteReply={(replyId) => {
                const next = comments.map((existing) =>
                  existing.id === c.id
                    ? {
                        ...existing,
                        replies: existing.replies.filter((r) => r.id !== replyId),
                      }
                    : existing,
                )
                afterDelete(next)
              }}
            />
          ))}
        </ul>
      )}
    </div>
  )
}

interface CommentItemProps {
  comment: SolutionComment
  solutionId: number
  slug: string
  isAuthenticated: boolean
  onAddReply: (reply: SolutionComment) => void
  onUpdate: (updated: Partial<SolutionComment>) => void
  onUpdateReply: (replyId: number, updated: Partial<SolutionComment>) => void
  onDelete: () => void
  onDeleteReply: (replyId: number) => void
}

function CommentItem({
  comment,
  solutionId,
  slug,
  isAuthenticated,
  onAddReply,
  onUpdate,
  onUpdateReply,
  onDelete,
  onDeleteReply,
}: CommentItemProps) {
  return (
    <li className="rounded-lg border border-border bg-background p-3">
      <CommentRow
        comment={comment}
        solutionId={solutionId}
        slug={slug}
        isAuthenticated={isAuthenticated}
        onAddReply={onAddReply}
        onUpdate={onUpdate}
        onDelete={onDelete}
        canReply
      />
      {comment.replies.length > 0 && (
        <ul className="mt-2 ml-6 space-y-2 border-l border-border pl-3">
          {comment.replies.map((reply) => (
            <li key={reply.id}>
              <CommentRow
                comment={reply}
                solutionId={solutionId}
                slug={slug}
                isAuthenticated={isAuthenticated}
                onUpdate={(u) => onUpdateReply(reply.id, u)}
                onDelete={() => onDeleteReply(reply.id)}
              />
            </li>
          ))}
        </ul>
      )}
    </li>
  )
}

interface CommentRowProps {
  comment: SolutionComment
  solutionId: number
  slug: string
  isAuthenticated: boolean
  canReply?: boolean
  onAddReply?: (reply: SolutionComment) => void
  onUpdate: (updated: Partial<SolutionComment>) => void
  onDelete: () => void
}

function CommentRow({
  comment,
  solutionId,
  slug,
  isAuthenticated,
  canReply,
  onAddReply,
  onUpdate,
  onDelete,
}: CommentRowProps) {
  const { t, i18n } = useTranslation("problem")
  const requireAuth = useRequireAuth(slug, solutionId)
  const [replying, setReplying] = useState(false)
  const [replyDraft, setReplyDraft] = useState("")
  const [editing, setEditing] = useState(false)
  const [editDraft, setEditDraft] = useState(comment.content)
  // One request at a time per row, so a double click can't post the same reply twice.
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [confirmingDelete, setConfirmingDelete] = useState(false)
  const [reportOpen, setReportOpen] = useState(false)
  const replyButtonRef = useRef<HTMLButtonElement>(null)
  const editButtonRef = useRef<HTMLButtonElement>(null)

  const refocus = (ref: RefObject<HTMLButtonElement | null>) =>
    requestAnimationFrame(() => ref.current?.focus())

  const submitReply = async () => {
    const content = replyDraft.trim()
    if (!content || busy) return
    setBusy(true)
    setError(null)
    try {
      const res = await createComment(solutionId, {
        content,
        parentCommentId: comment.id,
      })
      onAddReply?.(res.data)
      setReplyDraft("")
      setReplying(false)
      refocus(replyButtonRef)
    } catch {
      setError(t("solutions.comments.failed"))
    } finally {
      setBusy(false)
    }
  }

  const submitEdit = async () => {
    const content = editDraft.trim()
    if (!content || busy) return
    setBusy(true)
    setError(null)
    try {
      const res = await updateComment(comment.id, { content })
      onUpdate(res.data)
      setEditing(false)
      refocus(editButtonRef)
    } catch {
      setError(t("solutions.comments.failed"))
    } finally {
      setBusy(false)
    }
  }

  const handleDelete = async () => {
    setConfirmingDelete(false)
    setError(null)
    try {
      await deleteComment(comment.id)
      onDelete()
    } catch {
      setError(t("solutions.comments.deleteFailed"))
    }
  }

  return (
    <div>
      <div className="flex items-start gap-2">
        <AuthorAvatar
          avatarUrl={comment.authorAvatarUrl}
          username={comment.authorUsername}
          className="h-7 w-7"
        />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span className="font-semibold text-foreground">{comment.authorUsername}</span>
            <span>· {formatDate(comment.createdAt, i18n.language)}</span>
            {comment.edited && <span>· {t("solutions.comments.edited")}</span>}
          </div>
          {editing ? (
            <div className="mt-1">
              <textarea
                aria-label={t("solutions.comments.editLabel")}
                value={editDraft}
                onChange={(e) => setEditDraft(e.target.value)}
                maxLength={2000}
                rows={3}
                autoFocus
                className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <div className="mt-1 flex gap-2">
                <Button size="sm" onClick={submitEdit} disabled={!editDraft.trim() || busy}>
                  {busy ? t("solutions.comments.saving") : t("solutions.comments.save")}
                </Button>
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={() => {
                    setEditing(false)
                    setEditDraft(comment.content)
                    refocus(editButtonRef)
                  }}>
                  {t("solutions.comments.cancel")}
                </Button>
              </div>
            </div>
          ) : (
            <p className="mt-0.5 whitespace-pre-wrap text-sm text-foreground">
              {comment.content}
            </p>
          )}
          {!editing && (
            <div className="mt-1 flex gap-2 text-xs text-muted-foreground">
              {canReply && (
                <button
                  ref={replyButtonRef}
                  type="button"
                  aria-expanded={isAuthenticated ? replying : undefined}
                  className={actionClass}
                  onClick={() => {
                    if (!isAuthenticated) requireAuth()
                    else setReplying((v) => !v)
                  }}>
                  {t("solutions.comments.reply")}
                </button>
              )}
              {comment.ownedByViewer && (
                <>
                  <button
                    ref={editButtonRef}
                    type="button"
                    className={actionClass}
                    onClick={() => {
                      setEditDraft(comment.content)
                      setEditing(true)
                    }}>
                    {t("solutions.comments.edit")}
                  </button>
                  <button
                    type="button"
                    className="rounded px-1 py-0.5 hover:text-destructive focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                    onClick={() => setConfirmingDelete(true)}>
                    {t("solutions.comments.delete")}
                  </button>
                </>
              )}
              {!comment.ownedByViewer && isAuthenticated && (
                <button
                  type="button"
                  className={actionClass}
                  onClick={() => setReportOpen(true)}>
                  {t("solutions.report")}
                </button>
              )}
            </div>
          )}
          {error && (
            <p role="alert" className={errorText}>{error}</p>
          )}
        </div>
      </div>
      {replying && (
        <div className="mt-2 ml-7">
          <textarea
            aria-label={t("solutions.comments.replyLabel")}
            value={replyDraft}
            onChange={(e) => setReplyDraft(e.target.value)}
            maxLength={2000}
            rows={2}
            autoFocus
            placeholder={t("solutions.comments.composerPlaceholder")}
            className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <div className="mt-1 flex gap-2">
            <Button size="sm" onClick={submitReply} disabled={!replyDraft.trim() || busy}>
              {busy ? t("solutions.comments.posting") : t("solutions.comments.reply")}
            </Button>
            <Button
              size="sm"
              variant="ghost"
              onClick={() => {
                setReplying(false)
                refocus(replyButtonRef)
              }}>
              {t("solutions.comments.cancel")}
            </Button>
          </div>
        </div>
      )}
      <ConfirmDialog
        open={confirmingDelete}
        title={t("solutions.comments.confirmDelete")}
        description={comment.content.length > 120 ? `${comment.content.slice(0, 120)}…` : comment.content}
        confirmLabel={t("solutions.comments.delete")}
        onConfirm={handleDelete}
        onCancel={() => setConfirmingDelete(false)}
      />
      <ReportDialog
        open={reportOpen}
        onClose={() => setReportOpen(false)}
        onSubmit={async (reason) => {
          await reportComment(comment.id, { reason })
        }}
      />
    </div>
  )
}

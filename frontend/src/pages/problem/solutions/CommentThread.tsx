import { useState } from "react"
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
import type { SolutionComment } from "@/types/solution"

interface CommentThreadProps {
  solutionId: number
  slug: string
  comments: SolutionComment[]
  onChange: (comments: SolutionComment[]) => void
}

export function CommentThread({ solutionId, slug, comments, onChange }: CommentThreadProps) {
  const { t } = useTranslation("problem")
  const { isAuthenticated } = useAuth()
  const navigate = useNavigate()
  const [composer, setComposer] = useState("")
  const [submitting, setSubmitting] = useState(false)

  const requireAuth = () => {
    sessionStorage.setItem("returnUrl", `/problems/${slug}/solutions/${solutionId}`)
    navigate("/login")
  }

  const submitTopLevel = async () => {
    const content = composer.trim()
    if (!content) return
    if (!isAuthenticated) {
      requireAuth()
      return
    }
    setSubmitting(true)
    try {
      const res = await createComment(solutionId, { content })
      onChange([...comments, res.data])
      setComposer("")
    } catch {
      // ignore
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="space-y-4">
      <div>
        <textarea
          value={composer}
          onChange={(e) => setComposer(e.target.value)}
          maxLength={2000}
          rows={3}
          placeholder={t("solutions.comments.composerPlaceholder")}
          className="w-full resize-y rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
        />
        <div className="mt-2 flex items-center justify-between">
          <span className="text-xs text-muted-foreground">
            {composer.length}/2000
          </span>
          <Button
            size="sm"
            disabled={!composer.trim() || submitting}
            onClick={submitTopLevel}>
            {t("solutions.comments.submit")}
          </Button>
        </div>
      </div>

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
              onDelete={() => onChange(comments.filter((existing) => existing.id !== c.id))}
              onDeleteReply={(replyId) => {
                const next = comments.map((existing) =>
                  existing.id === c.id
                    ? {
                        ...existing,
                        replies: existing.replies.filter((r) => r.id !== replyId),
                      }
                    : existing,
                )
                onChange(next)
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
  const { t } = useTranslation("problem")
  const navigate = useNavigate()
  const [replying, setReplying] = useState(false)
  const [editing, setEditing] = useState(false)
  const [draft, setDraft] = useState(comment.content)
  const [reportOpen, setReportOpen] = useState(false)

  const requireAuth = () => {
    sessionStorage.setItem("returnUrl", `/problems/${slug}/solutions/${solutionId}`)
    navigate("/login")
  }

  const submitReply = async () => {
    if (!draft.trim()) return
    if (!isAuthenticated) {
      requireAuth()
      return
    }
    try {
      const res = await createComment(solutionId, {
        content: draft.trim(),
        parentCommentId: comment.id,
      })
      onAddReply?.(res.data)
      setDraft(comment.content)
      setReplying(false)
    } catch {
      // ignore
    }
  }

  const submitEdit = async () => {
    if (!draft.trim()) return
    try {
      const res = await updateComment(comment.id, { content: draft.trim() })
      onUpdate(res.data)
      setEditing(false)
    } catch {
      // ignore
    }
  }

  const handleDelete = async () => {
    if (!confirm(t("solutions.comments.confirmDelete"))) return
    try {
      await deleteComment(comment.id)
      onDelete()
    } catch {
      // ignore
    }
  }

  return (
    <div>
      <div className="flex items-start gap-2">
        <AvatarOrInitial
          avatarUrl={comment.authorAvatarUrl}
          username={comment.authorUsername}
        />
        <div className="min-w-0 flex-1">
          <div className="flex items-center gap-2 text-xs text-muted-foreground">
            <span className="font-semibold text-foreground">{comment.authorUsername}</span>
            <span>· {new Date(comment.createdAt).toLocaleDateString()}</span>
            {comment.edited && <span>· {t("solutions.comments.edited")}</span>}
          </div>
          {editing ? (
            <div className="mt-1">
              <textarea
                value={draft}
                onChange={(e) => setDraft(e.target.value)}
                maxLength={2000}
                rows={3}
                className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
              />
              <div className="mt-1 flex gap-2">
                <Button size="sm" onClick={submitEdit}>
                  {t("solutions.comments.save")}
                </Button>
                <Button
                  size="sm"
                  variant="ghost"
                  onClick={() => {
                    setEditing(false)
                    setDraft(comment.content)
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
            <div className="mt-1 flex gap-3 text-xs text-muted-foreground">
              {canReply && (
                <button
                  className="hover:text-foreground"
                  onClick={() => {
                    if (!isAuthenticated) requireAuth()
                    else {
                      setDraft("")
                      setReplying((v) => !v)
                    }
                  }}>
                  {t("solutions.comments.reply")}
                </button>
              )}
              {comment.ownedByViewer && (
                <>
                  <button
                    className="hover:text-foreground"
                    onClick={() => {
                      setDraft(comment.content)
                      setEditing(true)
                    }}>
                    {t("solutions.comments.edit")}
                  </button>
                  <button className="hover:text-destructive" onClick={handleDelete}>
                    {t("solutions.comments.delete")}
                  </button>
                </>
              )}
              {!comment.ownedByViewer && isAuthenticated && (
                <button
                  className="hover:text-foreground"
                  onClick={() => setReportOpen(true)}>
                  {t("solutions.report")}
                </button>
              )}
            </div>
          )}
        </div>
      </div>
      {replying && (
        <div className="mt-2 ml-7">
          <textarea
            value={draft}
            onChange={(e) => setDraft(e.target.value)}
            maxLength={2000}
            rows={2}
            placeholder={t("solutions.comments.composerPlaceholder")}
            className="w-full resize-y rounded-md border border-border bg-background px-2 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring"
          />
          <div className="mt-1 flex gap-2">
            <Button size="sm" onClick={submitReply}>
              {t("solutions.comments.reply")}
            </Button>
            <Button size="sm" variant="ghost" onClick={() => setReplying(false)}>
              {t("solutions.comments.cancel")}
            </Button>
          </div>
        </div>
      )}
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

function AvatarOrInitial({
  avatarUrl,
  username,
}: {
  avatarUrl: string | null
  username: string
}) {
  if (avatarUrl) {
    return (
      <img
        src={avatarUrl}
        alt={username}
        className="h-7 w-7 rounded-full"
      />
    )
  }
  return (
    <div className="flex h-7 w-7 items-center justify-center rounded-full bg-accent text-xs font-bold text-white">
      {username.charAt(0).toUpperCase()}
    </div>
  )
}

import { useRef, type ReactNode } from "react"
import { useTranslation } from "react-i18next"
import { Bold, Italic, Code, Link as LinkIcon, Heading2, List } from "lucide-react"
import { Button } from "@/components/ui/Button"
import { MarkdownRenderer } from "@/components/markdown/MarkdownRenderer"

interface MarkdownEditorProps {
  value: string
  onChange: (next: string) => void
  maxLength?: number
  placeholder?: string
}

export function MarkdownEditor({
  value,
  onChange,
  maxLength = 50_000,
  placeholder,
}: MarkdownEditorProps) {
  const { t } = useTranslation("problem")
  const textareaRef = useRef<HTMLTextAreaElement>(null)

  const wrap = (before: string, after: string = before, placeholderInside = "") => {
    const ta = textareaRef.current
    if (!ta) return
    const start = ta.selectionStart
    const end = ta.selectionEnd
    const selected = value.slice(start, end) || placeholderInside
    const next = value.slice(0, start) + before + selected + after + value.slice(end)
    if (next.length > maxLength) return
    onChange(next)
    requestAnimationFrame(() => {
      ta.focus()
      ta.setSelectionRange(start + before.length, start + before.length + selected.length)
    })
  }

  const insertLine = (prefix: string, placeholderInside = "") => {
    const ta = textareaRef.current
    if (!ta) return
    const start = ta.selectionStart
    const lineStart = value.lastIndexOf("\n", start - 1) + 1
    const selected = value.slice(start, ta.selectionEnd) || placeholderInside
    const next =
      value.slice(0, lineStart) +
      prefix +
      value.slice(lineStart, start) +
      selected +
      value.slice(ta.selectionEnd)
    if (next.length > maxLength) return
    onChange(next)
    requestAnimationFrame(() => {
      ta.focus()
      ta.setSelectionRange(start + prefix.length, start + prefix.length + selected.length)
    })
  }

  const onKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "b") {
      e.preventDefault()
      wrap("**", "**", "bold")
    } else if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "i") {
      e.preventDefault()
      wrap("_", "_", "italic")
    }
  }

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-3">
      <div className="flex flex-col">
        <div className="mb-2 flex flex-wrap items-center gap-1 rounded-md border border-border bg-muted px-2 py-1">
          <ToolbarButton onClick={() => wrap("**", "**", "bold")} label="Bold (⌘B)">
            <Bold className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarButton onClick={() => wrap("_", "_", "italic")} label="Italic (⌘I)">
            <Italic className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarButton onClick={() => wrap("`", "`", "code")} label="Inline code">
            <Code className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarButton onClick={() => wrap("[", "](url)", "link")} label="Link">
            <LinkIcon className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarButton onClick={() => insertLine("## ", "Heading")} label="Heading">
            <Heading2 className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarButton onClick={() => insertLine("- ", "item")} label="List">
            <List className="h-3.5 w-3.5" />
          </ToolbarButton>
          <span className="ml-auto text-xs text-muted-foreground">
            {value.length}/{maxLength}
          </span>
        </div>
        <textarea
          ref={textareaRef}
          value={value}
          onChange={(e) => onChange(e.target.value.slice(0, maxLength))}
          onKeyDown={onKeyDown}
          rows={20}
          placeholder={placeholder ?? t("solutions.editor.contentPlaceholder")}
          className="flex-1 min-h-[400px] resize-y rounded-md border border-border bg-background px-3 py-2 font-mono text-sm focus:outline-none focus:ring-2 focus:ring-ring"
        />
      </div>
      <div className="rounded-md border border-border bg-background p-4 overflow-auto max-h-[calc(100vh-12rem)]">
        {value.trim() ? (
          <MarkdownRenderer source={value} />
        ) : (
          <p className="text-sm text-muted-foreground">
            {t("solutions.editor.previewEmpty")}
          </p>
        )}
      </div>
    </div>
  )
}

function ToolbarButton({
  onClick,
  label,
  children,
}: {
  onClick: () => void
  label: string
  children: ReactNode
}) {
  return (
    <Button
      type="button"
      variant="ghost"
      size="sm"
      className="h-7 w-7 p-0"
      title={label}
      onClick={onClick}>
      {children}
    </Button>
  )
}

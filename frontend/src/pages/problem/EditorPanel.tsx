import Editor from "@monaco-editor/react"
import { Button } from "@/components/ui/Button"
import { Stack } from "@/components/layout/Stack"
import Spinner from "@/components/ui/Spinner"

const LANGUAGE_MAP: Record<string, string> = {
  java: "java",
  python: "python",
  javascript: "javascript",
  cpp: "cpp",
  c: "c",
}

interface EditorPanelProps {
  languages: string[]
  activeLanguage: string
  code: string
  onLanguageChange: (lang: string) => void
  onCodeChange: (value: string | undefined) => void
  onRun: () => void
  onSubmit: () => void
  running: boolean
  submitting: boolean
}

export function EditorPanel({
  languages,
  activeLanguage,
  code,
  onLanguageChange,
  onCodeChange,
  onRun,
  onSubmit,
  running,
  submitting,
}: EditorPanelProps) {
  return (
    <div className="flex h-full flex-col">
      {/* Toolbar */}
      <div className="flex items-center justify-between border-b border-border bg-muted px-3 py-2">
        <select
          value={activeLanguage}
          onChange={(e) => onLanguageChange(e.target.value)}
          className="rounded-md border border-border bg-card px-2 py-1 text-sm text-foreground"
        >
          {languages.map((lang) => (
            <option key={lang} value={lang}>
              {lang}
            </option>
          ))}
        </select>

        <Stack direction="horizontal" gap="sm">
          <Button
            variant="secondary"
            size="sm"
            onClick={onRun}
            disabled={running || submitting}
          >
            {running ? "Running..." : "Run"}
          </Button>
          <Button
            variant="accent"
            size="sm"
            onClick={onSubmit}
            disabled={submitting || running}
          >
            {submitting ? "Submitting..." : "Submit"}
          </Button>
        </Stack>
      </div>

      {/* Editor */}
      <div className="min-h-0 flex-1">
        <Editor
          height="100%"
          language={LANGUAGE_MAP[activeLanguage] || activeLanguage}
          value={code}
          onChange={onCodeChange}
          theme="light"
          loading={<Spinner />}
          options={{
            minimap: { enabled: false },
            fontSize: 14,
            scrollBeyondLastLine: false,
            padding: { top: 12 },
          }}
        />
      </div>
    </div>
  )
}

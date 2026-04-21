import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { useParams, useNavigate, useOutletContext } from "react-router-dom"
import { useProblem } from "@/hooks/useProblem"
import { useSubmissions } from "@/hooks/useSubmissions"
import { useAuth } from "@/context/AuthContext"
import { submitCode, getSubmission, runCode } from "@/api/submissions"
import { ProblemLayout } from "@/components/layout/ProblemLayout"
import Spinner from "@/components/ui/Spinner"
import { LeftPanel } from "./LeftPanel"
import { EditorPanel } from "./EditorPanel"
import { TestPanel } from "./TestPanel"
import type { CodeError, SubmissionResponse, RunResponse } from "@/types/submission"
import { AxiosError } from "axios"
import type { ApiError } from "@/types/api"
import { useKeyboardShortcuts } from "@/hooks/useKeyboardShortcuts"
import type { WorkspaceOutletContext } from "@/components/layout/Layout"
import { formatElapsed } from "@/components/layout/Layout"

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const navigate = useNavigate()
  const { timerActive, elapsed, stopTimer } = useOutletContext<WorkspaceOutletContext>()
  const { user, isAuthenticated, loading: authLoading, updateUser } = useAuth()
  const { problem, loading, error } = useProblem(slug!)
  const { submissions, refetch: refetchSubmissions, updateNote } = useSubmissions(
    slug!,
    isAuthenticated,
  )

  const [language, setLanguage] = useState<string>("")
  const [codeByLang, setCodeByLang] = useState<Record<string, string>>(() => {
    try {
      const stored = localStorage.getItem(`code-draft:${slug}`)
      return stored ? JSON.parse(stored) : {}
    } catch {
      return {}
    }
  })
  const [submitting, setSubmitting] = useState(false)
  const [result, setResult] = useState<SubmissionResponse | null>(null)
  const [submitError, setSubmitError] = useState<string | null>(null)
  const [running, setRunning] = useState(false)
  const [runResult, setRunResult] = useState<RunResponse | null>(null)
  const [runError, setRunError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState("testcases")
  const pollIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const resetLayoutRef = useRef<(() => void) | null>(null)
  const runRef = useRef<() => void>(() => {})
  const submitRef = useRef<() => void>(() => {})
  const timerSnapshotRef = useRef<number | null>(null)
  const codeByLangRef = useRef(codeByLang)
  codeByLangRef.current = codeByLang

  useKeyboardShortcuts(
    useCallback(() => runRef.current(), []),
    useCallback(() => submitRef.current(), []),
    running || submitting,
  )

  useEffect(() => {
    return () => {
      if (pollIntervalRef.current) clearInterval(pollIntervalRef.current)
    }
  }, [])

  useEffect(() => {
    if (problem) document.title = `${problem.title} | CodeBite`
  }, [problem])

  // Debounced draft persistence — avoid synchronous localStorage I/O on every keystroke.
  useEffect(() => {
    if (!slug) return
    const handle = setTimeout(() => {
      try {
        localStorage.setItem(`code-draft:${slug}`, JSON.stringify(codeByLangRef.current))
      } catch {
        // storage full / disabled — ignore
      }
    }, 300)
    return () => clearTimeout(handle)
  }, [codeByLang, slug])

  // Flush latest draft on slug change or unmount so a quick nav-away doesn't drop keystrokes.
  useEffect(() => {
    return () => {
      if (!slug) return
      try {
        localStorage.setItem(`code-draft:${slug}`, JSON.stringify(codeByLangRef.current))
      } catch {
        // ignore
      }
    }
  }, [slug])

  if (loading || authLoading) {
    return (
      <div className="flex h-[calc(100vh-3.5rem)] items-center justify-center">
        <Spinner />
      </div>
    )
  }

  if (error || !problem) {
    return (
      <div className="flex h-[calc(100vh-3.5rem)] items-center justify-center">
        <p className="text-sm text-destructive">{error || "Problem not found"}</p>
      </div>
    )
  }

  const languages = Object.keys(problem.starterCode)
  const recentLang = user?.recentLanguage
  const activeLang = language || (recentLang && languages.includes(recentLang) ? recentLang : languages[0]) || ""
  const code =
    codeByLang[activeLang] ?? problem.starterCode[activeLang] ?? ""

  const editorErrors = useMemo<CodeError[]>(() => {
    const results = runResult?.results ?? result?.results ?? []
    for (const r of results) {
      if (r.errors && r.errors.length > 0) return r.errors
    }
    return []
  }, [runResult, result])

  const handleLanguageChange = (lang: string) => {
    setLanguage(lang)
    updateUser({ recentLanguage: lang })
  }

  const handleResetCode = () => {
    setCodeByLang((prev) => {
      const next = { ...prev }
      delete next[activeLang]
      return next
    })
  }

  const handleCodeChange = (value: string | undefined) => {
    if (value !== undefined) {
      setCodeByLang((prev) => ({ ...prev, [activeLang]: value }))
    }
  }

  const pollForResult = (submissionId: number) => {
    const interval = setInterval(async () => {
      try {
        const res = await getSubmission(submissionId)
        if (res.data.status !== "PENDING") {
          clearInterval(interval)
          pollIntervalRef.current = null
          setResult(res.data)
          setSubmitting(false)
          if (timerSnapshotRef.current != null && res.data.status === "ACCEPTED") {
            stopTimer(timerSnapshotRef.current)
            const note = `Completion time: ${formatElapsed(timerSnapshotRef.current)}`
            await updateNote(submissionId, note)
          }
          timerSnapshotRef.current = null
          refetchSubmissions()
        }
      } catch {
        clearInterval(interval)
        pollIntervalRef.current = null
        setSubmitError("Failed to fetch results.")
        setSubmitting(false)
      }
    }, 2000)
    pollIntervalRef.current = interval
  }

  const handleRun = async () => {
    setRunning(true)
    setRunError(null)
    setRunResult(null)
    setResult(null)
    setSubmitError(null)
    setActiveTab("output")
    try {
      const res = await runCode(slug!, {
        language: activeLang,
        sourceCode: code,
      })
      setRunResult(res.data)
    } catch (err) {
      if (err instanceof AxiosError && err.response?.data) {
        setRunError((err.response.data as ApiError).message)
      } else {
        setRunError("Run failed. Please try again.")
      }
    } finally {
      setRunning(false)
    }
  }

  const handleSubmit = async () => {
    if (!isAuthenticated) {
      sessionStorage.setItem("returnUrl", `/problems/${slug}`)
      navigate("/login")
      return
    }
    timerSnapshotRef.current = timerActive ? elapsed : null
    if (pollIntervalRef.current) clearInterval(pollIntervalRef.current)
    setSubmitting(true)
    setSubmitError(null)
    setResult(null)
    setRunResult(null)
    setRunError(null)
    setActiveTab("output")
    try {
      const res = await submitCode(slug!, {
        language: activeLang,
        sourceCode: code,
      })
      setResult(res.data)
      pollForResult(res.data.id)
    } catch (err) {
      if (err instanceof AxiosError && err.response?.data) {
        setSubmitError((err.response.data as ApiError).message)
      } else {
        setSubmitError("Submission failed. Please try again.")
      }
      setSubmitting(false)
    }
  }

  runRef.current = handleRun
  submitRef.current = handleSubmit

  return (
    <ProblemLayout
      resetLayoutRef={resetLayoutRef}
      leftPanel={
        <LeftPanel
          title={problem.title}
          difficulty={problem.difficulty}
          description={problem.description}
          constraints={problem.constraints}
          isAuthenticated={isAuthenticated}
          submissions={submissions}
          onUpdateNote={updateNote}
        />
      }
      editor={
        <EditorPanel
          languages={languages}
          activeLanguage={activeLang}
          code={code}
          errors={editorErrors}
          onLanguageChange={handleLanguageChange}
          onCodeChange={handleCodeChange}
          onResetCode={handleResetCode}
          onResetLayout={() => resetLayoutRef.current?.()}
          onRun={handleRun}
          onSubmit={handleSubmit}
        />
      }
      testPanel={
        <TestPanel
          sampleTestCases={problem.sampleTestCases}
          runResult={runResult}
          runError={runError}
          submitResult={result}
          submitError={submitError}
          running={running}
          submitting={submitting}
          activeTab={activeTab}
          onTabChange={setActiveTab}
          onRun={handleRun}
          onSubmit={handleSubmit}
        />
      }
    />
  )
}

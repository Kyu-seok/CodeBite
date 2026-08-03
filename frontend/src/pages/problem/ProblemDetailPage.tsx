import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { useParams, useNavigate, useOutletContext } from "react-router-dom"
import { useProblem } from "@/hooks/useProblem"
import { useSubmissions } from "@/hooks/useSubmissions"
import { useAuth } from "@/context/AuthContext"
import {
  submitCode,
  getSubmission,
  runCode,
  setSolveTime,
  getStreamToken,
  submissionStreamUrl,
} from "@/api/submissions"
import { setSubmissionReview } from "@/api/reviews"
import { ProblemLayout, type PanelFunctions } from "@/components/layout/ProblemLayout"
import Spinner from "@/components/ui/Spinner"
import { LeftPanel, CollapsedLeftStrip } from "./LeftPanel"
import { EditorPanel } from "./EditorPanel"
import { TestPanel, CollapsedTestStrip } from "./TestPanel"
import { AcceptedModal } from "@/components/review/AcceptedModal"
import { fireConfetti } from "@/components/review/ConfettiBurst"
import type { Confidence } from "@/types/review"
import type {
  CodeError,
  CustomTestCaseInput,
  SubmissionResponse,
  RunResponse,
} from "@/types/submission"
import { AxiosError } from "axios"
import type { ApiError } from "@/types/api"
import { useKeyboardShortcuts } from "@/hooks/useKeyboardShortcuts"
import type { WorkspaceOutletContext } from "@/components/layout/Layout"

// Polling is now the fallback path, not the primary one — results normally arrive over SSE.
const POLL_INTERVAL_MS = 500
const POLL_MAX_DURATION_MS = 60_000
// Below the server's 120s emitter timeout, so the client gives up on a silent stream and
// switches to polling before the connection is closed underneath it.
const SSE_MAX_DURATION_MS = 90_000

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
  const [acceptedModal, setAcceptedModal] = useState<{
    open: boolean
    submissionId: number | null
    solveTimeSeconds: number | null
  }>({ open: false, submissionId: null, solveTimeSeconds: null })
  const [customTests, setCustomTests] = useState<CustomTestCaseInput[]>(() => {
    try {
      const stored = localStorage.getItem(`custom-tests:${slug}`)
      return stored ? JSON.parse(stored) : []
    } catch {
      return []
    }
  })
  const [leftPanelTab, setLeftPanelTab] = useState('description')
  const [leftCollapsed, setLeftCollapsed] = useState(false)
  const [rightCollapsed, setRightCollapsed] = useState(false)
  const [editorCollapsed, setEditorCollapsed] = useState(false)
  const [testsCollapsed, setTestsCollapsed] = useState(false)
  const panelFunctionsRef = useRef<PanelFunctions | null>(null)
  const pollIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const eventSourceRef = useRef<EventSource | null>(null)
  const resetLayoutRef = useRef<(() => void) | null>(null)
  const runRef = useRef<() => void>(() => {})
  const submitRef = useRef<() => void>(() => {})
  const timerSnapshotRef = useRef<number | null>(null)
  const codeByLangRef = useRef(codeByLang)
  codeByLangRef.current = codeByLang
  const customTestsRef = useRef(customTests)
  customTestsRef.current = customTests

  useKeyboardShortcuts(
    useCallback(() => runRef.current(), []),
    useCallback(() => submitRef.current(), []),
    running || submitting,
  )

  useEffect(() => {
    return () => {
      if (pollIntervalRef.current) clearInterval(pollIntervalRef.current)
      if (eventSourceRef.current) eventSourceRef.current.close()
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

  // Custom tests — debounced persistence + flush on unmount, mirrors code-draft.
  useEffect(() => {
    if (!slug) return
    const handle = setTimeout(() => {
      try {
        localStorage.setItem(`custom-tests:${slug}`, JSON.stringify(customTestsRef.current))
      } catch {
        // ignore
      }
    }, 300)
    return () => clearTimeout(handle)
  }, [customTests, slug])

  useEffect(() => {
    return () => {
      if (!slug) return
      try {
        localStorage.setItem(`custom-tests:${slug}`, JSON.stringify(customTestsRef.current))
      } catch {
        // ignore
      }
    }
  }, [slug])

  const editorErrors = useMemo<CodeError[]>(() => {
    const results = runResult?.results ?? result?.results ?? []
    for (const r of results) {
      if (r.errors && r.errors.length > 0) return r.errors
    }
    return []
  }, [runResult, result])

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

  const handleLoadIntoEditor = (sourceCode: string, lang: string) => {
    setCodeByLang((prev) => ({ ...prev, [lang]: sourceCode }))
    if (lang !== activeLang) {
      handleLanguageChange(lang)
    }
  }

  const stopWatching = () => {
    if (pollIntervalRef.current) {
      clearInterval(pollIntervalRef.current)
      pollIntervalRef.current = null
    }
    if (eventSourceRef.current) {
      eventSourceRef.current.close()
      eventSourceRef.current = null
    }
  }

  /**
   * Loads the finished submission and runs the post-submit side effects.
   * Shared by the stream and the polling fallback so both settle identically.
   * Returns false when the submission is still PENDING.
   */
  const finalizeSubmission = async (submissionId: number): Promise<boolean> => {
    const res = await getSubmission(submissionId)
    if (res.data.status === "PENDING") return false

    stopWatching()
    setResult(res.data)
    setSubmitting(false)

    let capturedSolveTime: number | null = null
    if (timerSnapshotRef.current != null && res.data.status === "ACCEPTED") {
      capturedSolveTime = timerSnapshotRef.current
      stopTimer(capturedSolveTime)
      // Persist as a structured field on the submission.
      try {
        await setSolveTime(submissionId, capturedSolveTime)
      } catch {
        // Non-fatal; the modal still lets the user enter time manually.
      }
    }
    timerSnapshotRef.current = null

    if (res.data.status === "ACCEPTED") {
      fireConfetti()
      setAcceptedModal({
        open: true,
        submissionId,
        solveTimeSeconds: capturedSolveTime,
      })
    }

    refetchSubmissions()
    return true
  }

  const pollForResult = (submissionId: number) => {
    if (pollIntervalRef.current) return
    const startTime = Date.now()
    const interval = setInterval(async () => {
      if (Date.now() - startTime > POLL_MAX_DURATION_MS) {
        stopWatching()
        setSubmitError("Submission is taking longer than expected. Please refresh to check the result.")
        setSubmitting(false)
        return
      }
      try {
        await finalizeSubmission(submissionId)
      } catch {
        stopWatching()
        setSubmitError("Failed to fetch results.")
        setSubmitting(false)
      }
    }, POLL_INTERVAL_MS)
    pollIntervalRef.current = interval
  }

  /**
   * Waits for the result over SSE, falling back to polling on any failure — no token
   * (Redis disabled), a refused connection, or a mid-stream drop. The fallback is what
   * keeps this safe to ship: the worker always writes the row, so polling still resolves.
   */
  const watchForResult = async (submissionId: number) => {
    let token: string
    try {
      const res = await getStreamToken(submissionId)
      token = res.data.token
    } catch {
      pollForResult(submissionId)
      return
    }

    let source: EventSource
    try {
      source = new EventSource(submissionStreamUrl(submissionId, token))
    } catch {
      pollForResult(submissionId)
      return
    }
    eventSourceRef.current = source

    // Backstop for a stream that stays open without ever delivering a result.
    const deadline = setTimeout(() => {
      if (eventSourceRef.current === source) {
        source.close()
        eventSourceRef.current = null
        pollForResult(submissionId)
      }
    }, SSE_MAX_DURATION_MS)

    source.addEventListener("result", () => {
      clearTimeout(deadline)
      finalizeSubmission(submissionId).catch(() => {
        stopWatching()
        setSubmitError("Failed to fetch results.")
        setSubmitting(false)
      })
    })

    source.onerror = () => {
      // EventSource retries on its own; only step in once it has actually given up.
      if (source.readyState !== EventSource.CLOSED) return
      clearTimeout(deadline)
      if (eventSourceRef.current === source) eventSourceRef.current = null
      pollForResult(submissionId)
    }
  }

  const handleAcceptedReviewSubmit = async ({
    submissionId,
    confidence,
    notes,
    solveTimeSeconds,
  }: {
    submissionId: number
    confidence: Confidence
    notes: string | null
    solveTimeSeconds: number | null
  }) => {
    // If the user edited the time in the modal, persist that value (overrides the auto-capture).
    if (
      solveTimeSeconds != null &&
      solveTimeSeconds !== acceptedModal.solveTimeSeconds
    ) {
      try {
        await setSolveTime(submissionId, solveTimeSeconds)
      } catch {
        // ignore — primary path is the rating
      }
    }
    await setSubmissionReview(submissionId, {
      confidence,
      notes: notes ?? undefined,
    })
    refetchSubmissions()
  }

  const handleFoldLeft = () => panelFunctionsRef.current?.collapseLeft()
  const handleMaximizeLeft = () => {
    if (rightCollapsed) panelFunctionsRef.current?.expandRight()
    else panelFunctionsRef.current?.collapseRight()
  }
  const handleToggleTests = () => {
    if (testsCollapsed) panelFunctionsRef.current?.expandTests()
    else panelFunctionsRef.current?.collapseTests()
  }
  const handleMaximizeEditor = () => {
    if (leftCollapsed && testsCollapsed) {
      panelFunctionsRef.current?.expandLeft()
      panelFunctionsRef.current?.expandTests()
    } else {
      panelFunctionsRef.current?.collapseLeft()
      panelFunctionsRef.current?.collapseTests()
    }
  }
  const handleFoldTests = () => panelFunctionsRef.current?.collapseTests()
  const handleMaximizeTests = () => {
    if (editorCollapsed) panelFunctionsRef.current?.expandEditor()
    else panelFunctionsRef.current?.collapseEditor()
  }

  const handleRun = async () => {
    setRunning(true)
    setRunError(null)
    setRunResult(null)
    setResult(null)
    setSubmitError(null)
    setActiveTab("output")
    try {
      const cleaned = customTests
        .map((tc) => ({ input: tc.input.trim(), expectedOutput: tc.expectedOutput }))
        .filter((tc) => tc.input.length > 0)
      const res = await runCode(slug!, {
        language: activeLang,
        sourceCode: code,
        customTestCases: cleaned.length > 0 ? cleaned : undefined,
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
      watchForResult(res.data.id)
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
    <>
      <ProblemLayout
        resetLayoutRef={resetLayoutRef}
        panelFunctionsRef={panelFunctionsRef}
        onLeftCollapsed={setLeftCollapsed}
        onRightCollapsed={setRightCollapsed}
        onEditorCollapsed={setEditorCollapsed}
        onTestsCollapsed={setTestsCollapsed}
        collapsedLeftContent={
          <CollapsedLeftStrip
            activeTab={leftPanelTab}
            onTabSelect={setLeftPanelTab}
            onExpand={() => panelFunctionsRef.current?.expandLeft()}
            onMaximize={handleMaximizeLeft}
            isMaximized={rightCollapsed}
          />
        }
        collapsedTestContent={
          <CollapsedTestStrip
            onExpand={() => panelFunctionsRef.current?.expandTests()}
            onMaximize={handleMaximizeTests}
            isMaximized={editorCollapsed}
          />
        }
        leftPanel={
          <LeftPanel
            slug={slug!}
            title={problem.title}
            difficulty={problem.difficulty}
            description={problem.description}
            constraints={problem.constraints}
            isAuthenticated={isAuthenticated}
            submissions={submissions}
            activeTab={leftPanelTab}
            onTabChange={setLeftPanelTab}
            onUpdateNote={updateNote}
            onLoadIntoEditor={handleLoadIntoEditor}
            onFold={handleFoldLeft}
            onMaximize={handleMaximizeLeft}
            isMaximized={rightCollapsed}
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
            onToggleTests={handleToggleTests}
            onMaximize={handleMaximizeEditor}
            testsCollapsed={testsCollapsed}
            isMaximized={leftCollapsed && testsCollapsed}
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
            userSource={code}
            customTests={customTests}
            onCustomTestsChange={setCustomTests}
            onTabChange={setActiveTab}
            onRun={handleRun}
            onSubmit={handleSubmit}
            onFold={handleFoldTests}
            onMaximize={handleMaximizeTests}
            isMaximized={editorCollapsed}
          />
        }
      />
      <AcceptedModal
        open={acceptedModal.open}
        onOpenChange={(open) => setAcceptedModal((prev) => ({ ...prev, open }))}
        submissionId={acceptedModal.submissionId}
        defaultSolveTimeSeconds={acceptedModal.solveTimeSeconds}
        onSubmit={handleAcceptedReviewSubmit}
      />
    </>
  )
}

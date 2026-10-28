import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { Link, useParams, useNavigate, useOutletContext } from "react-router-dom"
import { useTranslation } from "react-i18next"
import { useProblem } from "@/hooks/useProblem"
import { useSubmissions } from "@/hooks/useSubmissions"
import { useAuth } from "@/context/AuthContext"
import { submitCode, runCode, setSolveTime } from "@/api/submissions"
import { setSubmissionReview } from "@/api/reviews"
import { notifyStreakChanged } from "@/api/streak"
import { ProblemLayout, type PanelFunctions } from "@/components/layout/ProblemLayout"
import Spinner from "@/components/ui/Spinner"
import { Button } from "@/components/ui/Button"
import { LeftPanel, CollapsedLeftStrip } from "./LeftPanel"
import { EditorPanel } from "./EditorPanel"
import { TestPanel, CollapsedTestStrip, ResultAnnouncer } from "./TestPanel"
import { ConfirmDialog } from "./ConfirmDialog"
import { languageLabel } from "./submissionDisplay"
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
import { useSubmissionWatch } from "@/hooks/useSubmissionWatch"
import type { WatchFailure } from "@/judge/watchSubmission"
import type { WorkspaceOutletContext } from "@/components/layout/Layout"

// Every way the watch can lose sight of the verdict has its message; the Record keeps it so.
const WATCH_FAILURE_KEYS: Record<WatchFailure, string> = {
  slow: "workspace.judgingSlow",
  unreachable: "workspace.resultFetchFailed",
}

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const navigate = useNavigate()
  const { t } = useTranslation("problem")
  const { getTimerSnapshot, stopTimer, notifyEditing } = useOutletContext<WorkspaceOutletContext>()
  const { user, isAuthenticated, loading: authLoading, updateUser } = useAuth()
  const { problem, loading, error, retry: retryProblem } = useProblem(slug!)
  const { submissions, failed: submissionsFailed, refetch: refetchSubmissions, updateNote } = useSubmissions(
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
  const [submitStartedAt, setSubmitStartedAt] = useState<number | null>(null)
  // The submission whose verdict is being watched; null once it settles or fails.
  const [watchedSubmissionId, setWatchedSubmissionId] = useState<number | null>(null)
  // A pending overwrite of the editor (reset or load), held until the learner confirms it.
  const [pendingOverwrite, setPendingOverwrite] = useState<
    { kind: "reset" | "load"; lang: string; sourceCode?: string } | null
  >(null)
  const [result, setResult] = useState<SubmissionResponse | null>(null)
  const [submitError, setSubmitError] = useState<string | null>(null)
  const [running, setRunning] = useState(false)
  const [runStartedAt, setRunStartedAt] = useState<number | null>(null)
  const [runResult, setRunResult] = useState<RunResponse | null>(null)
  const [runError, setRunError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState("testcases")
  const [acceptedModal, setAcceptedModal] = useState<{
    open: boolean
    submissionId: number | null
    solveTimeSeconds: number | null
    reviewIntervalDays: Record<Confidence, number> | null
  }>({ open: false, submissionId: null, solveTimeSeconds: null, reviewIntervalDays: null })
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

  /**
   * The post-submit side effects, run once per verdict because the watch emits once. The order
   * matters: the solve time is saved before the modal opens, so the modal shows it.
   */
  const onSubmitSettled = async (submission: SubmissionResponse) => {
    setResult(submission)
    setSubmitting(false)
    setSubmitStartedAt(null)

    let capturedSolveTime: number | null = null
    if (timerSnapshotRef.current != null && submission.status === "ACCEPTED") {
      capturedSolveTime = timerSnapshotRef.current
      stopTimer(capturedSolveTime)
      // Persist as a structured field on the submission.
      try {
        await setSolveTime(submission.id, capturedSolveTime)
      } catch {
        // Non-fatal; the modal still lets the user enter time manually.
      }
    }
    timerSnapshotRef.current = null

    if (submission.status === "ACCEPTED") {
      notifyStreakChanged()
      fireConfetti()
      setAcceptedModal({
        open: true,
        submissionId: submission.id,
        solveTimeSeconds: capturedSolveTime,
        reviewIntervalDays: submission.reviewIntervalDays ?? null,
      })
    }

    refetchSubmissions()
  }

  useSubmissionWatch(watchedSubmissionId, (ev) => {
    setWatchedSubmissionId(null)
    if (ev.type === "failed") {
      setSubmitError(t(WATCH_FAILURE_KEYS[ev.reason]))
      setSubmitting(false)
      setSubmitStartedAt(null)
      return
    }
    void onSubmitSettled(ev.submission)
  })

  if (loading || authLoading) {
    return (
      <div className="flex h-[calc(100dvh-3.5rem)] items-center justify-center">
        <Spinner />
      </div>
    )
  }

  if (error || !problem) {
    return (
      <div className="flex h-[calc(100dvh-3.5rem)] flex-col items-center justify-center gap-3 px-4 text-center">
        <p className="text-sm text-foreground" role="alert">
          {error === "failed" ? t("workspace.problemLoadFailed") : t("workspace.problemNotFound")}
        </p>
        {error === "failed" && (
          <Button variant="outline" size="sm" onClick={retryProblem}>
            {t("workspace.retryLoad")}
          </Button>
        )}
        <Link
          to="/problems"
          className="text-sm text-accent-700 underline-offset-4 hover:underline dark:text-accent-400">
          {t("workspace.goToProblems")}
        </Link>
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

  // True when the editor holds work for `lang` that an overwrite would lose.
  const hasOwnCode = (lang: string, incoming?: string) => {
    const current = codeByLang[lang]
    return current != null && current !== problem.starterCode[lang] && current !== incoming
  }

  const resetCode = (lang: string) => {
    setCodeByLang((prev) => {
      const next = { ...prev }
      delete next[lang]
      return next
    })
  }

  const handleResetCode = () => {
    if (hasOwnCode(activeLang)) setPendingOverwrite({ kind: "reset", lang: activeLang })
    else resetCode(activeLang)
  }

  const handleCodeChange = (value: string | undefined) => {
    if (value !== undefined) {
      setCodeByLang((prev) => ({ ...prev, [activeLang]: value }))
      notifyEditing()
    }
  }

  const loadIntoEditor = (sourceCode: string, lang: string) => {
    setCodeByLang((prev) => ({ ...prev, [lang]: sourceCode }))
    if (lang !== activeLang) {
      handleLanguageChange(lang)
    }
  }

  const handleLoadIntoEditor = (sourceCode: string, lang: string) => {
    if (hasOwnCode(lang, sourceCode)) setPendingOverwrite({ kind: "load", lang, sourceCode })
    else loadIntoEditor(sourceCode, lang)
  }

  const confirmOverwrite = () => {
    if (!pendingOverwrite) return
    if (pendingOverwrite.kind === "reset") resetCode(pendingOverwrite.lang)
    else loadIntoEditor(pendingOverwrite.sourceCode ?? "", pendingOverwrite.lang)
    setPendingOverwrite(null)
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
    // Clearing it sends null: no time, rather than 0:00.
    if (solveTimeSeconds !== acceptedModal.solveTimeSeconds) {
      try {
        await setSolveTime(submissionId, solveTimeSeconds)
      } catch {
        // ignore — primary path is the rating
      }
    }
    const res = await setSubmissionReview(submissionId, {
      confidence,
      notes: notes ?? undefined,
    })
    refetchSubmissions()
    return res.data
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
    setRunStartedAt(Date.now())
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
        setRunError(t("workspace.runFailed"))
      }
    } finally {
      setRunning(false)
      setRunStartedAt(null)
    }
  }

  const handleSubmit = async () => {
    if (!isAuthenticated) {
      sessionStorage.setItem("returnUrl", `/problems/${slug}`)
      navigate("/login")
      return
    }
    timerSnapshotRef.current = getTimerSnapshot()
    setSubmitting(true)
    setSubmitStartedAt(Date.now())
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
      setWatchedSubmissionId(res.data.id)
    } catch (err) {
      if (err instanceof AxiosError && err.response?.data) {
        setSubmitError((err.response.data as ApiError).message)
      } else {
        setSubmitError(t("workspace.submitFailed"))
      }
      setSubmitting(false)
      setSubmitStartedAt(null)
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
            submissionsFailed={submissionsFailed}
            onRetrySubmissions={refetchSubmissions}
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
            problemSlug={slug!}
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
            submitStartedAt={submitStartedAt}
            runStartedAt={runStartedAt}
            language={activeLang}
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
      <ResultAnnouncer
        running={running}
        submitting={submitting}
        runResult={runResult}
        runError={runError}
        submitResult={result}
        submitError={submitError}
      />
      <AcceptedModal
        open={acceptedModal.open}
        onOpenChange={(open) => setAcceptedModal((prev) => ({ ...prev, open }))}
        submissionId={acceptedModal.submissionId}
        problemSlug={slug!}
        defaultSolveTimeSeconds={acceptedModal.solveTimeSeconds}
        reviewIntervalDays={acceptedModal.reviewIntervalDays}
        onSubmit={handleAcceptedReviewSubmit}
      />
      <ConfirmDialog
        open={pendingOverwrite != null}
        title={t(pendingOverwrite?.kind === "load" ? "workspace.loadConfirmTitle" : "workspace.resetConfirmTitle")}
        description={t(
          pendingOverwrite?.kind === "load" ? "workspace.loadConfirmBody" : "workspace.resetConfirmBody",
          { language: languageLabel(pendingOverwrite?.lang ?? activeLang) },
        )}
        confirmLabel={t(pendingOverwrite?.kind === "load" ? "workspace.loadConfirm" : "workspace.resetConfirm")}
        onConfirm={confirmOverwrite}
        onCancel={() => setPendingOverwrite(null)}
      />
    </>
  )
}

import { useCallback, useEffect, useMemo, useRef, useState } from "react"
import { Link, useLocation, useParams, useNavigate, useOutletContext } from "react-router-dom"
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
import { languageLabel, problemLanguages } from "./submissionDisplay"
import { AcceptedModal } from "@/components/review/AcceptedModal"
import { fireConfetti } from "@/components/review/ConfettiBurst"
import type { Confidence } from "@/types/review"
import type { CodeError, CustomTestCaseInput, SubmissionResponse } from "@/types/submission"
import { addCustomTest, type AddCustomTestOutcome } from "./customTests"
import { AxiosError } from "axios"
import type { ApiError } from "@/types/api"
import { useKeyboardShortcuts } from "@/hooks/useKeyboardShortcuts"
import { useSubmissionWatch } from "@/hooks/useSubmissionWatch"
import { usePersistedDraft } from "@/hooks/usePersistedDraft"
import type { JudgeAttempt } from "@/judge/attempt"
import type { WorkspaceOutletContext } from "@/components/layout/Layout"
import { browserStorage, markTipSeen, pulsedButton, readSeenTips, tipFor, type Tip, type TutorialEvent } from "@/onboarding"
import { useTutorial, type TutorialNavigationState } from "@/hooks/useTutorial"
import { TutorialCard } from "./TutorialCard"
import { languageOnReturn, submitReturnUrl } from "@/lib/signInReturn"

/** The server's reason for refusing a Run or Submit, when it gave one; the panel has a generic fallback. */
function rejectionMessage(err: unknown): string | undefined {
  if (err instanceof AxiosError && err.response?.data) return (err.response.data as ApiError).message
  return undefined
}

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const navigate = useNavigate()
  const { t } = useTranslation("problem")
  const { getTimerSnapshot, stopTimer, notifyEditing } = useOutletContext<WorkspaceOutletContext>()
  const { user, isAuthenticated, loading: authLoading, updateUser } = useAuth()
  const { problem, loading, error, retry: retryProblem } = useProblem(slug!)
  // A Former Slug still finds the problem; move to its current Slug so links and drafts use that.
  useEffect(() => {
    if (problem && problem.slug !== slug) navigate(`/problems/${problem.slug}`, { replace: true })
  }, [problem, slug, navigate])
  const { submissions, failed: submissionsFailed, refetch: refetchSubmissions, updateNote } = useSubmissions(
    slug!,
    isAuthenticated,
  )

  const [language, setLanguage] = useState<string>("")
  const [codeByLang, setCodeByLang] = usePersistedDraft<Record<string, string>>(`code-draft:${slug}`, {})
  // The one Run or Submit in progress or last finished; TestPanel renders it as is.
  const [attempt, setAttempt] = useState<JudgeAttempt>({ kind: "idle" })
  // A pending overwrite of the editor (reset or load), held until the learner confirms it.
  const [pendingOverwrite, setPendingOverwrite] = useState<
    { kind: "reset" | "load"; lang: string; sourceCode?: string } | null
  >(null)
  const [activeTab, setActiveTab] = useState("testcases")
  // Tips dismissed in this browser; a dismissal holds for the page even when storage can't keep it.
  const [seenTips, setSeenTips] = useState(() => readSeenTips(browserStorage))
  const tip = attempt.kind === "settled" ? tipFor(attempt, seenTips) : null
  const dismissTip = (dismissed: Tip) => setSeenTips((seen) => markTipSeen(browserStorage, dismissed, seen))
  // The Tutorial runs only on the Tutorial Problem; elsewhere what the user does leaves it be.
  const location = useLocation()
  const { tutorial, dispatch: dispatchTutorial } = useTutorial()
  const onTutorialProblem = problem?.tutorial === true
  const tutorialStepNow = onTutorialProblem && tutorial.status === "active" ? tutorial.step : null
  const tutorialEvent = (event: TutorialEvent) => {
    if (onTutorialProblem) dispatchTutorial(event)
  }
  // The navigation that (re)started the Tutorial: the editor is offered back its Starter Code once,
  // then the flag is cleared from history so a reload doesn't offer it again.
  const replayRequested = (location.state as TutorialNavigationState | null)?.tutorialReplayed === true
  const [replayHandledFor, setReplayHandledFor] = useState<string | null>(null)
  useEffect(() => {
    if (replayRequested && problem) navigate(location.pathname, { replace: true, state: null })
  }, [replayRequested, problem, navigate, location.pathname])
  // Back from signing in at Submit: the editor takes up the language the code was written in, then
  // the way back is cleared from the address.
  const returnedLang = problem ? languageOnReturn(location.search, problemLanguages(problem.starterCode)) : null
  useEffect(() => {
    if (!returnedLang) return
    setLanguage(returnedLang)
    navigate(location.pathname, { replace: true, state: location.state })
  }, [returnedLang, navigate, location.pathname, location.state])
  const [acceptedModal, setAcceptedModal] = useState<{
    open: boolean
    submissionId: number | null
    solveTimeSeconds: number | null
    reviewIntervalDays: Record<Confidence, number> | null
  }>({ open: false, submissionId: null, solveTimeSeconds: null, reviewIntervalDays: null })
  const [customTests, setCustomTests] = usePersistedDraft<CustomTestCaseInput[]>(`custom-tests:${slug}`, [])
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

  useKeyboardShortcuts(
    useCallback(() => runRef.current(), []),
    useCallback(() => submitRef.current(), []),
    attempt.kind === "judging",
  )

  useEffect(() => {
    if (problem) document.title = `${problem.title} | CodeBite`
  }, [problem])

  const editorErrors = useMemo<CodeError[]>(() => {
    const results = attempt.kind === "settled" ? attempt.result.results : []
    for (const r of results) {
      if (r.errors && r.errors.length > 0) return r.errors
    }
    return []
  }, [attempt])

  /**
   * The post-submit side effects, run once per verdict because the watch emits once. The order
   * matters: the solve time is saved before the modal opens, so the modal shows it.
   */
  const onSubmitSettled = async (submission: SubmissionResponse) => {
    setAttempt((prev) => ({
      kind: "settled",
      mode: "submit",
      result: submission,
      startedAt: prev.kind === "judging" ? prev.startedAt : Date.now(),
    }))
    // Step 6's celebration takes the place of the first-Accepted Tip, so the user isn't
    // congratulated twice. Set with the result, before any await, so the Tip never flashes.
    if (submission.status === "ACCEPTED" && onTutorialProblem) {
      if (dispatchTutorial({ type: "accepted" }).status === "active") {
        setSeenTips((seen) => markTipSeen(browserStorage, "firstAccepted", seen))
      }
    }

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

  // Watched while a Submit is judging and the server has given it an id.
  const watchedSubmissionId =
    attempt.kind === "judging" && attempt.mode === "submit" ? (attempt.submissionId ?? null) : null
  useSubmissionWatch(watchedSubmissionId, (ev) => {
    if (ev.type === "failed") {
      setAttempt({ kind: "failed", mode: "submit", reason: ev.reason })
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

  const languages = problemLanguages(problem.starterCode)
  const recentLang = user?.recentLanguage
  // The language picked here, else the user's recent one, else Python (the least boilerplate for a newcomer).
  const fallbackLang = languages.includes("python") ? "python" : languages[0]
  const activeLang = language || returnedLang || (recentLang && languages.includes(recentLang) ? recentLang : fallbackLang) || ""
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

  // Replaying the Tutorial starts again from Starter Code, after the usual confirmation.
  if (replayRequested && onTutorialProblem && replayHandledFor !== location.key) {
    setReplayHandledFor(location.key)
    if (hasOwnCode(activeLang)) setPendingOverwrite({ kind: "reset", lang: activeLang })
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
      tutorialEvent({ type: "edited" })
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

  // Adds a submission's Failing Case to the custom test cases and brings the Test panel up on them.
  const handleAddCustomTest = (tc: CustomTestCaseInput): AddCustomTestOutcome => {
    const { tests, outcome } = addCustomTest(customTests, tc)
    if (outcome === "added") setCustomTests(tests)
    if (outcome !== "full") {
      setActiveTab("testcases")
      if (testsCollapsed) panelFunctionsRef.current?.expandTests()
    }
    return outcome
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
    // One Attempt at a time: the buttons and page shortcuts are disabled while judging, and the
    // editor's own shortcut lands here too.
    if (attempt.kind === "judging") return
    const startedAt = Date.now()
    setAttempt({ kind: "judging", mode: "run", startedAt })
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
      setAttempt({ kind: "settled", mode: "run", result: res.data, startedAt })
      tutorialEvent({ type: "ran", passed: res.data.overallStatus === "ACCEPTED" })
    } catch (err) {
      setAttempt({ kind: "failed", mode: "run", reason: "rejected", message: rejectionMessage(err) })
    }
  }

  const handleSubmit = async () => {
    if (!isAuthenticated) {
      sessionStorage.setItem("returnUrl", submitReturnUrl(slug!, activeLang))
      navigate("/login")
      return
    }
    if (attempt.kind === "judging") return
    tutorialEvent({ type: "submitted" })
    timerSnapshotRef.current = getTimerSnapshot()
    const startedAt = Date.now()
    setAttempt({ kind: "judging", mode: "submit", startedAt })
    setActiveTab("output")
    try {
      const res = await submitCode(slug!, {
        language: activeLang,
        sourceCode: code,
      })
      // The id starts the watch; the verdict arrives through onSubmitSettled.
      setAttempt({ kind: "judging", mode: "submit", startedAt, submissionId: res.data.id })
    } catch (err) {
      setAttempt({ kind: "failed", mode: "submit", reason: "rejected", message: rejectionMessage(err) })
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
            tutorial={problem.tutorial}
            description={problem.description}
            constraints={problem.constraints}
            languages={languages}
            isAuthenticated={isAuthenticated}
            submissions={submissions}
            submissionsFailed={submissionsFailed}
            onRetrySubmissions={refetchSubmissions}
            activeTab={leftPanelTab}
            onTabChange={setLeftPanelTab}
            onUpdateNote={updateNote}
            onLoadIntoEditor={handleLoadIntoEditor}
            onAddCustomTest={handleAddCustomTest}
            onFold={handleFoldLeft}
            onMaximize={handleMaximizeLeft}
            isMaximized={rightCollapsed}
            stepCard={
              tutorialStepNow && (
                <TutorialCard
                  step={tutorialStepNow}
                  onNext={() => tutorialEvent({ type: "read" })}
                  onSkip={() => tutorialEvent({ type: "skipped" })}
                />
              )
            }
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
            attempt={attempt}
            language={activeLang}
            activeTab={activeTab}
            userSource={code}
            customTests={customTests}
            onCustomTestsChange={setCustomTests}
            onAddCustomTest={handleAddCustomTest}
            tip={tip}
            onDismissTip={dismissTip}
            pulse={pulsedButton(tutorialStepNow)}
            onTabChange={setActiveTab}
            onRun={handleRun}
            onSubmit={handleSubmit}
            onFold={handleFoldTests}
            onMaximize={handleMaximizeTests}
            isMaximized={editorCollapsed}
          />
        }
      />
      <ResultAnnouncer attempt={attempt} />
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

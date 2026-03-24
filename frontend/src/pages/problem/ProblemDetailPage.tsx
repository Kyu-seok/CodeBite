import { useEffect, useRef, useState } from "react"
import { useParams, useNavigate } from "react-router-dom"
import { useProblem } from "@/hooks/useProblem"
import { useSubmissions } from "@/hooks/useSubmissions"
import { useAuth } from "@/context/AuthContext"
import { submitCode, getSubmission, runCode } from "@/api/submissions"
import { ProblemLayout } from "@/components/layout/ProblemLayout"
import Spinner from "@/components/ui/Spinner"
import { LeftPanel } from "./LeftPanel"
import { EditorPanel } from "./EditorPanel"
import { TestPanel } from "./TestPanel"
import type { SubmissionResponse, RunResponse } from "@/types/submission"
import { AxiosError } from "axios"
import type { ApiError } from "@/types/api"

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>()
  const navigate = useNavigate()
  const { user, isAuthenticated, updateUser } = useAuth()
  const { problem, loading, error } = useProblem(slug!)
  const { submissions, refetch: refetchSubmissions } = useSubmissions(
    slug!,
    isAuthenticated,
  )

  const [language, setLanguage] = useState<string>("")
  const [codeByLang, setCodeByLang] = useState<Record<string, string>>({})
  const [submitting, setSubmitting] = useState(false)
  const [result, setResult] = useState<SubmissionResponse | null>(null)
  const [submitError, setSubmitError] = useState<string | null>(null)
  const [running, setRunning] = useState(false)
  const [runResult, setRunResult] = useState<RunResponse | null>(null)
  const [runError, setRunError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState("testcases")
  const pollIntervalRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const resetLayoutRef = useRef<(() => void) | null>(null)

  useEffect(() => {
    return () => {
      if (pollIntervalRef.current) clearInterval(pollIntervalRef.current)
    }
  }, [])

  useEffect(() => {
    if (problem) document.title = `${problem.title} | CodeBite`
  }, [problem])

  if (loading) {
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

  const pollForResult = (submissionId: number) => {
    const interval = setInterval(async () => {
      try {
        const res = await getSubmission(submissionId)
        if (res.data.status !== "PENDING") {
          clearInterval(interval)
          pollIntervalRef.current = null
          setResult(res.data)
          setSubmitting(false)
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
      navigate("/login")
      return
    }
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

  return (
    <ProblemLayout
      resetLayoutRef={resetLayoutRef}
      leftPanel={
        <LeftPanel
          title={problem.title}
          difficulty={problem.difficulty}
          description={problem.description}
          constraints={problem.constraints}
          sampleTestCases={problem.sampleTestCases}
          isAuthenticated={isAuthenticated}
          submissions={submissions}
        />
      }
      editor={
        <EditorPanel
          languages={languages}
          activeLanguage={activeLang}
          code={code}
          onLanguageChange={handleLanguageChange}
          onCodeChange={handleCodeChange}
          onResetCode={handleResetCode}
          onResetLayout={() => resetLayoutRef.current?.()}
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

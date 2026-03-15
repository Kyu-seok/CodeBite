import { useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import ReactMarkdown from "react-markdown";
import Editor from "@monaco-editor/react";
import { useProblem } from "../hooks/useProblem";
import { useSubmissions } from "../hooks/useSubmissions";
import { useAuth } from "../context/AuthContext";
import { submitCode } from "../api/submissions";
import DifficultyBadge from "../components/ui/DifficultyBadge";
import StatusBadge from "../components/ui/StatusBadge";
import Spinner from "../components/ui/Spinner";
import type { SubmissionResponse } from "../types/submission";
import { AxiosError } from "axios";
import type { ApiError } from "../types/api";

const LANGUAGE_MAP: Record<string, string> = {
  java: "java",
  python: "python",
  javascript: "javascript",
  cpp: "cpp",
  c: "c",
};

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const navigate = useNavigate();
  const { isAuthenticated } = useAuth();
  const { problem, loading, error } = useProblem(slug!);
  const { submissions, refetch: refetchSubmissions } = useSubmissions(slug!, isAuthenticated);
  const [language, setLanguage] = useState<string>("");
  const [codeByLang, setCodeByLang] = useState<Record<string, string>>({});
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<SubmissionResponse | null>(null);
  const [submitError, setSubmitError] = useState<string | null>(null);

  if (loading) return <Spinner />;
  if (error || !problem) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <p className="text-red-600">{error || "Problem not found"}</p>
      </div>
    );
  }

  const languages = Object.keys(problem.starterCode);
  const activeLang = language || languages[0] || "";
  const code = codeByLang[activeLang] ?? problem.starterCode[activeLang] ?? "";

  const handleCodeChange = (value: string | undefined) => {
    if (value !== undefined) {
      setCodeByLang((prev) => ({ ...prev, [activeLang]: value }));
    }
  };

  const handleSubmit = async () => {
    if (!isAuthenticated) {
      navigate("/login");
      return;
    }
    setSubmitting(true);
    setSubmitError(null);
    setResult(null);
    try {
      const res = await submitCode(slug!, { language: activeLang, sourceCode: code });
      setResult(res.data);
      refetchSubmissions();
    } catch (err) {
      if (err instanceof AxiosError && err.response?.data) {
        setSubmitError((err.response.data as ApiError).message);
      } else {
        setSubmitError("Submission failed. Please try again.");
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-4 py-6">
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Left panel — description */}
        <div className="bg-white rounded-lg shadow p-6 overflow-auto max-h-[calc(100vh-6rem)]">
          <div className="flex items-center gap-3 mb-4">
            <h1 className="text-xl font-bold text-gray-900">{problem.title}</h1>
            <DifficultyBadge difficulty={problem.difficulty} />
          </div>

          <div className="prose prose-sm max-w-none mb-6">
            <ReactMarkdown>{problem.description}</ReactMarkdown>
          </div>

          {problem.constraints && (
            <div className="mb-6">
              <h2 className="text-sm font-semibold text-gray-700 mb-2">Constraints</h2>
              <div className="prose prose-sm max-w-none">
                <ReactMarkdown>{problem.constraints}</ReactMarkdown>
              </div>
            </div>
          )}

          {problem.sampleTestCases.length > 0 && (
            <div>
              <h2 className="text-sm font-semibold text-gray-700 mb-2">Sample Test Cases</h2>
              <div className="space-y-3">
                {problem.sampleTestCases.map((tc, i) => (
                  <div key={tc.id} className="bg-gray-50 rounded p-3 text-sm">
                    <p className="font-medium text-gray-600 mb-1">Example {i + 1}</p>
                    <p>
                      <span className="text-gray-500">Input: </span>
                      <code className="bg-gray-200 px-1 rounded">{tc.input}</code>
                    </p>
                    <p>
                      <span className="text-gray-500">Output: </span>
                      <code className="bg-gray-200 px-1 rounded">{tc.expectedOutput}</code>
                    </p>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Right panel — editor + results */}
        <div className="flex flex-col gap-4">
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <div className="flex items-center justify-between px-4 py-2 bg-gray-50 border-b border-gray-200">
              <select
                value={activeLang}
                onChange={(e) => setLanguage(e.target.value)}
                className="px-2 py-1 border border-gray-300 rounded text-sm bg-white"
              >
                {languages.map((lang) => (
                  <option key={lang} value={lang}>
                    {lang}
                  </option>
                ))}
              </select>
            </div>
            <Editor
              height="60vh"
              language={LANGUAGE_MAP[activeLang] || activeLang}
              value={code}
              onChange={handleCodeChange}
              theme="vs-dark"
              loading={<Spinner />}
              options={{
                minimap: { enabled: false },
                fontSize: 14,
                scrollBeyondLastLine: false,
                padding: { top: 12 },
              }}
            />
          </div>

          <button
            onClick={handleSubmit}
            disabled={submitting}
            className="w-full py-2 px-4 bg-green-600 text-white rounded-md hover:bg-green-700 disabled:opacity-50 font-medium"
          >
            {submitting ? "Submitting..." : "Submit"}
          </button>

          {submitError && (
            <div className="bg-red-50 border border-red-200 text-red-700 rounded p-3 text-sm">
              {submitError}
            </div>
          )}

          {result && (
            <div className="bg-white rounded-lg shadow p-4">
              <div className="flex items-center justify-between mb-3">
                <StatusBadge status={result.status} />
                <div className="text-xs text-gray-500 space-x-3">
                  {result.runtimeMs != null && <span>Runtime: {result.runtimeMs}ms</span>}
                  {result.memoryKb != null && <span>Memory: {result.memoryKb}KB</span>}
                </div>
              </div>
              {result.results.length > 0 && (
                <div className="space-y-2">
                  <h3 className="text-sm font-semibold text-gray-700">Test Results</h3>
                  {result.results.map((r, i) => (
                    <div
                      key={r.testCaseId}
                      className="bg-gray-50 rounded p-3 text-sm"
                    >
                      <div className="flex items-center justify-between mb-1">
                        <span className="font-medium text-gray-600">Test {i + 1}</span>
                        <StatusBadge status={r.status} />
                      </div>
                      {r.input && (
                        <p>
                          <span className="text-gray-500">Input: </span>
                          <code className="bg-gray-200 px-1 rounded">{r.input}</code>
                        </p>
                      )}
                      {r.expectedOutput && (
                        <p>
                          <span className="text-gray-500">Expected: </span>
                          <code className="bg-gray-200 px-1 rounded">{r.expectedOutput}</code>
                        </p>
                      )}
                      {r.actualOutput && (
                        <p>
                          <span className="text-gray-500">Output: </span>
                          <code className="bg-gray-200 px-1 rounded">{r.actualOutput}</code>
                        </p>
                      )}
                    </div>
                  ))}
                </div>
              )}
            </div>
          )}

          {/* Submission History */}
          <div className="bg-white rounded-lg shadow p-4">
            <h3 className="text-sm font-semibold text-gray-700 mb-3">Submission History</h3>
            {!isAuthenticated ? (
              <p className="text-sm text-gray-400">Log in to see submission history</p>
            ) : submissions.length === 0 ? (
              <p className="text-sm text-gray-400">No submissions yet</p>
            ) : (
              <div className="space-y-2">
                {submissions.map((s) => (
                  <div
                    key={s.id}
                    className="flex items-center justify-between bg-gray-50 rounded p-2 text-sm"
                  >
                    <div className="flex items-center gap-3">
                      <StatusBadge status={s.status} />
                      <span className="text-gray-500">{s.language}</span>
                    </div>
                    <div className="flex items-center gap-3 text-xs text-gray-400">
                      {s.runtimeMs != null && <span>{s.runtimeMs}ms</span>}
                      {s.memoryKb != null && <span>{s.memoryKb}KB</span>}
                      <span>{new Date(s.createdAt).toLocaleString()}</span>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

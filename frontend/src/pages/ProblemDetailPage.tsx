import { useState } from "react";
import { useParams } from "react-router-dom";
import ReactMarkdown from "react-markdown";
import Editor from "@monaco-editor/react";
import { useProblem } from "../hooks/useProblem";
import DifficultyBadge from "../components/ui/DifficultyBadge";
import Spinner from "../components/ui/Spinner";

const LANGUAGE_MAP: Record<string, string> = {
  java: "java",
  python: "python",
  javascript: "javascript",
  cpp: "cpp",
  c: "c",
};

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const { problem, loading, error } = useProblem(slug!);
  const [language, setLanguage] = useState<string>("");
  const [codeByLang, setCodeByLang] = useState<Record<string, string>>({});

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

        {/* Right panel — editor */}
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
            className="w-full py-2 px-4 bg-green-600 text-white rounded-md hover:bg-green-700 font-medium"
          >
            Submit
          </button>

          {/* Results placeholder */}
          <div className="bg-white rounded-lg shadow p-4 text-gray-400 text-sm text-center">
            Submit your solution to see results
          </div>
        </div>
      </div>
    </div>
  );
}

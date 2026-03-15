import { useParams } from "react-router-dom";
import ReactMarkdown from "react-markdown";
import { useProblem } from "../hooks/useProblem";
import DifficultyBadge from "../components/ui/DifficultyBadge";
import Spinner from "../components/ui/Spinner";

export default function ProblemDetailPage() {
  const { slug } = useParams<{ slug: string }>();
  const { problem, loading, error } = useProblem(slug!);

  if (loading) return <Spinner />;
  if (error || !problem) {
    return (
      <div className="max-w-7xl mx-auto px-4 py-8">
        <p className="text-red-600">{error || "Problem not found"}</p>
      </div>
    );
  }

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

        {/* Right panel — editor placeholder */}
        <div className="bg-white rounded-lg shadow p-6 flex items-center justify-center text-gray-400 min-h-[400px]">
          Code editor coming soon
        </div>
      </div>
    </div>
  );
}

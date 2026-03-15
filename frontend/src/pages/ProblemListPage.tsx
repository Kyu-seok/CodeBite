import { useEffect } from "react";
import { Link, useSearchParams } from "react-router-dom";
import { useProblems } from "../hooks/useProblems";
import DifficultyBadge from "../components/ui/DifficultyBadge";
import Spinner from "../components/ui/Spinner";
import type { Difficulty } from "../types/problem";

const DIFFICULTIES: Difficulty[] = ["EASY", "MEDIUM", "HARD"];

export default function ProblemListPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const page = Number(searchParams.get("page") || "0");
  const difficulty = (searchParams.get("difficulty") as Difficulty) || undefined;
  const { data, loading, error } = useProblems(page, 20, difficulty);

  useEffect(() => {
    document.title = "Problems | CodeBite";
  }, []);

  const setPage = (p: number) => {
    const params = new URLSearchParams(searchParams);
    params.set("page", String(p));
    setSearchParams(params);
  };

  const setDifficulty = (d: string) => {
    const params = new URLSearchParams(searchParams);
    if (d) {
      params.set("difficulty", d);
    } else {
      params.delete("difficulty");
    }
    params.set("page", "0");
    setSearchParams(params);
  };

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-gray-900">Problems</h1>
        <select
          value={difficulty || ""}
          onChange={(e) => setDifficulty(e.target.value)}
          className="px-3 py-1.5 border border-gray-300 rounded-md text-sm bg-white"
        >
          <option value="">All Difficulties</option>
          {DIFFICULTIES.map((d) => (
            <option key={d} value={d}>
              {d}
            </option>
          ))}
        </select>
      </div>

      {loading && <Spinner />}
      {error && <p className="text-red-600">{error}</p>}

      {data && data.content.length === 0 && (
        <p className="text-gray-500 text-center py-12">No problems found.</p>
      )}

      {data && data.content.length > 0 && (
        <>
          <table className="w-full bg-white rounded-lg shadow overflow-hidden">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase w-16">
                  #
                </th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Title
                </th>
                <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase w-28">
                  Difficulty
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {data.content.map((problem) => (
                <tr key={problem.id} className="hover:bg-gray-50">
                  <td className="px-4 py-3 text-sm text-gray-500">{problem.id}</td>
                  <td className="px-4 py-3">
                    <Link
                      to={`/problems/${problem.slug}`}
                      className="text-blue-600 hover:underline font-medium"
                    >
                      {problem.title}
                    </Link>
                  </td>
                  <td className="px-4 py-3">
                    <DifficultyBadge difficulty={problem.difficulty} />
                  </td>
                </tr>
              ))}
            </tbody>
          </table>

          {data.totalPages > 1 && (
            <div className="flex items-center justify-center gap-4 mt-6">
              <button
                onClick={() => setPage(page - 1)}
                disabled={data.first}
                className="px-3 py-1 text-sm border border-gray-300 rounded-md disabled:opacity-50 hover:bg-gray-50"
              >
                Previous
              </button>
              <span className="text-sm text-gray-600">
                Page {data.number + 1} of {data.totalPages}
              </span>
              <button
                onClick={() => setPage(page + 1)}
                disabled={data.last}
                className="px-3 py-1 text-sm border border-gray-300 rounded-md disabled:opacity-50 hover:bg-gray-50"
              >
                Next
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}

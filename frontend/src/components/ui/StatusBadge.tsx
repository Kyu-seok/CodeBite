import type { SubmissionStatus } from "../../types/submission";

const styles: Record<SubmissionStatus, string> = {
  ACCEPTED: "bg-green-100 text-green-700",
  WRONG_ANSWER: "bg-red-100 text-red-700",
  TIME_LIMIT_EXCEEDED: "bg-orange-100 text-orange-700",
  RUNTIME_ERROR: "bg-red-100 text-red-700",
  COMPILATION_ERROR: "bg-yellow-100 text-yellow-700",
  PENDING: "bg-gray-100 text-gray-700",
  INTERNAL_ERROR: "bg-gray-100 text-gray-700",
};

const labels: Record<SubmissionStatus, string> = {
  ACCEPTED: "Accepted",
  WRONG_ANSWER: "Wrong Answer",
  TIME_LIMIT_EXCEEDED: "Time Limit Exceeded",
  RUNTIME_ERROR: "Runtime Error",
  COMPILATION_ERROR: "Compilation Error",
  PENDING: "Pending",
  INTERNAL_ERROR: "Internal Error",
};

export default function StatusBadge({ status }: { status: SubmissionStatus }) {
  return (
    <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${styles[status]}`}>
      {labels[status]}
    </span>
  );
}

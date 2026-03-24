import { Badge, type BadgeProps } from "@/components/ui/Badge"
import type { SubmissionStatus } from "@/types/submission"

const variantMap: Record<SubmissionStatus, BadgeProps["variant"]> = {
  ACCEPTED: "success",
  WRONG_ANSWER: "destructive",
  TIME_LIMIT_EXCEEDED: "warning",
  RUNTIME_ERROR: "destructive",
  COMPILATION_ERROR: "warning",
  PENDING: "secondary",
  INTERNAL_ERROR: "outline",
}

const labels: Record<SubmissionStatus, string> = {
  ACCEPTED: "Accepted",
  WRONG_ANSWER: "Wrong Answer",
  TIME_LIMIT_EXCEEDED: "Time Limit Exceeded",
  RUNTIME_ERROR: "Runtime Error",
  COMPILATION_ERROR: "Compilation Error",
  PENDING: "Pending",
  INTERNAL_ERROR: "Internal Error",
}

export default function StatusBadge({ status }: { status: SubmissionStatus }) {
  return <Badge variant={variantMap[status]}>{labels[status]}</Badge>
}

import { useTranslation } from "react-i18next"
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

const keyMap: Record<SubmissionStatus, string> = {
  ACCEPTED: "status.accepted",
  WRONG_ANSWER: "status.wrongAnswer",
  TIME_LIMIT_EXCEEDED: "status.timeLimitExceeded",
  RUNTIME_ERROR: "status.runtimeError",
  COMPILATION_ERROR: "status.compilationError",
  PENDING: "status.pending",
  INTERNAL_ERROR: "status.internalError",
}

export default function StatusBadge({ status }: { status: SubmissionStatus }) {
  const { t } = useTranslation("common")
  return <Badge variant={variantMap[status]}>{t(keyMap[status])}</Badge>
}

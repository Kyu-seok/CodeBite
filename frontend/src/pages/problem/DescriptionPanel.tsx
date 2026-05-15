import { useTranslation } from "react-i18next"
import { MarkdownRenderer } from "@/components/markdown/MarkdownRenderer"
import DifficultyBadge from "@/components/ui/DifficultyBadge"
import { Stack } from "@/components/layout/Stack"
import { ReviewBadge } from "@/components/review/ReviewBadge"
import { ProgressionStrip } from "@/components/review/ProgressionStrip"
import { useReviewHistory } from "@/hooks/useReviewHistory"
import type { Difficulty } from "@/types/problem"

interface DescriptionPanelProps {
  slug: string
  title: string
  difficulty: Difficulty
  description: string
  constraints: string | null
  isAuthenticated: boolean
  onOpenSubmission?: (submissionId: number) => void
}

export function DescriptionPanel({
  slug,
  title,
  difficulty,
  description,
  constraints,
  isAuthenticated,
  onOpenSubmission,
}: DescriptionPanelProps) {
  const { t } = useTranslation("problem")
  const { history } = useReviewHistory(slug, isAuthenticated)
  return (
    <div className="p-6">
      <Stack direction="horizontal" gap="sm" align="center">
        <h1 className="text-xl font-bold text-foreground">{title}</h1>
        <DifficultyBadge difficulty={difficulty} />
      </Stack>

      {isAuthenticated && (
        <div className="mt-3 space-y-2">
          <ReviewBadge slug={slug} enabled={isAuthenticated} />
          {history.length > 0 && onOpenSubmission && (
            <ProgressionStrip history={history} onPillClick={onOpenSubmission} />
          )}
        </div>
      )}

      <MarkdownRenderer source={description} className="mt-4" />

      {constraints && (
        <div className="mt-6">
          <h2 className="text-sm font-semibold text-muted-foreground mb-2">
            {t("description.constraints")}
          </h2>
          <MarkdownRenderer source={constraints} />
        </div>
      )}
    </div>
  )
}

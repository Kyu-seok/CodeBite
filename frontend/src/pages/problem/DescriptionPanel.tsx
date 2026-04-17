import { useTranslation } from "react-i18next"
import ReactMarkdown from "react-markdown"
import DifficultyBadge from "@/components/ui/DifficultyBadge"
import { Stack } from "@/components/layout/Stack"
import type { Difficulty } from "@/types/problem"

interface DescriptionPanelProps {
  title: string
  difficulty: Difficulty
  description: string
  constraints: string | null
}

export function DescriptionPanel({
  title,
  difficulty,
  description,
  constraints,
}: DescriptionPanelProps) {
  const { t } = useTranslation("problem")
  return (
    <div className="p-6">
      <Stack direction="horizontal" gap="sm" align="center">
        <h1 className="text-xl font-bold text-foreground">{title}</h1>
        <DifficultyBadge difficulty={difficulty} />
      </Stack>

      <div className="prose prose-sm dark:prose-invert max-w-none mt-4">
        <ReactMarkdown>{description}</ReactMarkdown>
      </div>

      {constraints && (
        <div className="mt-6">
          <h2 className="text-sm font-semibold text-muted-foreground mb-2">
            {t("description.constraints")}
          </h2>
          <div className="prose prose-sm dark:prose-invert max-w-none">
            <ReactMarkdown>{constraints}</ReactMarkdown>
          </div>
        </div>
      )}
    </div>
  )
}

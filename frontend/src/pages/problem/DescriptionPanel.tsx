import { useTranslation } from "react-i18next"
import ReactMarkdown from "react-markdown"
import DifficultyBadge from "@/components/ui/DifficultyBadge"
import { Stack } from "@/components/layout/Stack"
import type { Difficulty, TestCase } from "@/types/problem"

interface DescriptionPanelProps {
  title: string
  difficulty: Difficulty
  description: string
  constraints: string | null
  sampleTestCases: TestCase[]
}

export function DescriptionPanel({
  title,
  difficulty,
  description,
  constraints,
  sampleTestCases,
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

      {sampleTestCases.length > 0 && (
        <div className="mt-6">
          <h2 className="text-sm font-semibold text-muted-foreground mb-2">
            {t("description.examples")}
          </h2>
          <Stack gap="sm">
            {sampleTestCases.map((tc, i) => (
              <div key={tc.id} className="rounded-lg bg-muted p-3 text-sm">
                <p className="font-medium text-muted-foreground mb-1">
                  {t("description.example", { n: i + 1 })}
                </p>
                <p>
                  <span className="text-muted-foreground">{t("test.input")}</span>
                  <code className="rounded bg-secondary px-1 text-foreground">
                    {tc.input}
                  </code>
                </p>
                <p>
                  <span className="text-muted-foreground">{t("description.output")}</span>
                  <code className="rounded bg-secondary px-1 text-foreground">
                    {tc.expectedOutput}
                  </code>
                </p>
              </div>
            ))}
          </Stack>
        </div>
      )}
    </div>
  )
}

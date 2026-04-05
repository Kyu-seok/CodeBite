import { useTranslation } from "react-i18next"
import { Badge, type BadgeProps } from "@/components/ui/Badge"
import type { Difficulty } from "@/types/problem"

const variantMap: Record<Difficulty, BadgeProps["variant"]> = {
  EASY: "success",
  MEDIUM: "warning",
  HARD: "destructive",
}

const keyMap: Record<Difficulty, string> = {
  EASY: "difficulty.easy",
  MEDIUM: "difficulty.medium",
  HARD: "difficulty.hard",
}

export default function DifficultyBadge({ difficulty }: { difficulty: Difficulty }) {
  const { t } = useTranslation("common")
  return <Badge variant={variantMap[difficulty]}>{t(keyMap[difficulty])}</Badge>
}

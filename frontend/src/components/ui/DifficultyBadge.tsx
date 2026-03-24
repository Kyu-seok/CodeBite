import { Badge, type BadgeProps } from "@/components/ui/Badge"
import type { Difficulty } from "@/types/problem"

const variantMap: Record<Difficulty, BadgeProps["variant"]> = {
  EASY: "success",
  MEDIUM: "warning",
  HARD: "destructive",
}

export default function DifficultyBadge({ difficulty }: { difficulty: Difficulty }) {
  return <Badge variant={variantMap[difficulty]}>{difficulty}</Badge>
}

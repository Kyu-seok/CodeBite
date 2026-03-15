import type { Difficulty } from "../../types/problem";

const styles: Record<Difficulty, string> = {
  EASY: "bg-green-100 text-green-700",
  MEDIUM: "bg-yellow-100 text-yellow-700",
  HARD: "bg-red-100 text-red-700",
};

export default function DifficultyBadge({ difficulty }: { difficulty: Difficulty }) {
  return (
    <span className={`inline-block px-2 py-0.5 rounded text-xs font-medium ${styles[difficulty]}`}>
      {difficulty}
    </span>
  );
}

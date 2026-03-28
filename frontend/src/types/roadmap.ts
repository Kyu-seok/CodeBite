import type { Difficulty } from "./problem"

export interface RoadmapProblem {
  id: number
  title: string
  slug: string
  difficulty: Difficulty
  status: "SOLVED" | "ATTEMPTED" | null
}

export interface RoadmapCategory {
  id: number
  name: string
  slug: string
  description: string
  displayOrder: number
  prerequisiteSlugs: string[]
  problems: RoadmapProblem[]
}

export interface RoadmapResponse {
  categories: RoadmapCategory[]
}

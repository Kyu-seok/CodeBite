export type Difficulty = "EASY" | "MEDIUM" | "HARD";

export interface ProblemListItem {
  id: number;
  title: string;
  slug: string;
  difficulty: Difficulty;
  tags: string[];
  status: "SOLVED" | "ATTEMPTED" | null;
  acceptanceRate: number | null;
}

export interface TagDto {
  name: string;
  slug: string;
}

export interface TestCase {
  id: number;
  input: string;
  expectedOutput: string;
  sample: boolean;
  orderIndex: number;
}

export interface ProblemStats {
  totalEasy: number;
  totalMedium: number;
  totalHard: number;
  solvedEasy: number;
  solvedMedium: number;
  solvedHard: number;
}

export interface ProblemDetail {
  id: number;
  title: string;
  slug: string;
  description: string;
  difficulty: Difficulty;
  starterCode: Record<string, string>;
  constraints: string;
  published: boolean;
  sampleTestCases: TestCase[];
  createdAt: string;
  updatedAt: string;
}

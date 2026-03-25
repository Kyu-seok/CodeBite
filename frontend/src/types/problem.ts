export type Difficulty = "EASY" | "MEDIUM" | "HARD";

export interface ProblemListItem {
  id: number;
  title: string;
  slug: string;
  difficulty: Difficulty;
  tags: string[];
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

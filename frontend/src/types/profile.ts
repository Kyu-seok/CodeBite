export interface ProfileStats {
  totalSolved: number;
  totalProblems: number;
  solvedEasy: number;
  solvedMedium: number;
  solvedHard: number;
  totalEasy: number;
  totalMedium: number;
  totalHard: number;
  currentStreak: number;
  longestStreak: number;
  totalActiveDays: number;
  memberSince: string;
}

export interface ActivityDay {
  date: string;
  count: number;
}

export interface TagProficiency {
  tagName: string;
  tagSlug: string;
  solved: number;
  total: number;
}

export interface RecentSubmission {
  id: number;
  problemTitle: string;
  problemSlug: string;
  difficulty: string;
  status: string;
  language: string;
  runtimeMs: number | null;
  memoryKb: number | null;
  createdAt: string;
}

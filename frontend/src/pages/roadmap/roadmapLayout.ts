export interface NodePosition {
  col: number  // horizontal position (left to right)
  row: number  // vertical position (top to bottom)
}

// Horizontal layout: left-to-right flow
// col = depth level (1=start, 9=end), row = vertical spread within a level
export const ROADMAP_LAYOUT: Record<string, NodePosition> = {
  "foundations":          { col: 1, row: 3 },
  "hash-maps":           { col: 2, row: 1 },
  "stacks":              { col: 2, row: 3 },
  "sorting":             { col: 2, row: 5 },
  "two-pointers":        { col: 3, row: 1 },
  "linked-lists":        { col: 3, row: 3 },
  "binary-search":       { col: 3, row: 5 },
  "recursion":           { col: 4, row: 3 },
  "trees":               { col: 5, row: 2 },
  "backtracking":        { col: 5, row: 4 },
  "tries":               { col: 6, row: 1 },
  "heaps":               { col: 6, row: 3 },
  "graphs":              { col: 6, row: 5 },
  "greedy":              { col: 7, row: 4 },
  "dynamic-programming": { col: 8, row: 3 },
  "math-and-bits":       { col: 9, row: 3 },
}

// Topological order for the mobile list view
export const TOPOLOGICAL_ORDER: string[] = [
  "foundations",
  "hash-maps",
  "stacks",
  "sorting",
  "two-pointers",
  "linked-lists",
  "binary-search",
  "recursion",
  "trees",
  "backtracking",
  "tries",
  "heaps",
  "graphs",
  "greedy",
  "dynamic-programming",
  "math-and-bits",
]

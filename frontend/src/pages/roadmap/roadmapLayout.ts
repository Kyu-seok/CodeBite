export interface NodePosition {
  col: number  // horizontal position (left to right)
  row: number  // vertical position (top to bottom)
}

// Horizontal layout: left-to-right flow
// col = depth level (1=start, 7=end), row = vertical spread within a level
export const ROADMAP_LAYOUT: Record<string, NodePosition> = {
  "arrays-and-hashing":    { col: 1, row: 2 },
  "two-pointers":          { col: 2, row: 1 },
  "math-and-geometry":     { col: 2, row: 2 },
  "stacks":                { col: 2, row: 3 },
  "sliding-window":        { col: 3, row: 1 },
  "binary-search":         { col: 3, row: 2 },
  "linked-lists":          { col: 3, row: 3 },
  "trees":                 { col: 4, row: 2 },
  "tries":                 { col: 5, row: 1 },
  "backtracking":          { col: 5, row: 2 },
  "heaps":                 { col: 5, row: 3 },
  "graphs":                { col: 6, row: 1 },
  "dynamic-programming":   { col: 6, row: 2 },
  "greedy":                { col: 6, row: 3 },
  "bit-manipulation":      { col: 7, row: 1 },
  "2d-dynamic-programming":{ col: 7, row: 2 },
  "intervals":             { col: 7, row: 3 },
}

// Topological order for the mobile list view
export const TOPOLOGICAL_ORDER: string[] = [
  "arrays-and-hashing",
  "math-and-geometry",
  "two-pointers",
  "stacks",
  "sliding-window",
  "binary-search",
  "linked-lists",
  "trees",
  "tries",
  "backtracking",
  "heaps",
  "graphs",
  "dynamic-programming",
  "greedy",
  "intervals",
  "2d-dynamic-programming",
  "bit-manipulation",
]

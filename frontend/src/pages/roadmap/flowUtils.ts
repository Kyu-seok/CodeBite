import { MarkerType, Position, type Node, type Edge } from '@xyflow/react';
import type { RoadmapCategory } from '@/types/roadmap';
import { ROADMAP_LAYOUT } from './roadmapLayout';

// ── Node state ──

export type NodeState =
  | 'locked'
  | 'not-started'
  | 'in-progress'
  | 'complete'
  | 'coming-soon';

export interface SkillNodeData {
  category: RoadmapCategory;
  state: NodeState;
  solvedCount: number;
  totalCount: number;
  [key: string]: unknown;
}

function hasSolvedAny(category: RoadmapCategory): boolean {
  return category.problems.some((p) => p.status === 'SOLVED');
}

export function computeNodeState(
  category: RoadmapCategory,
  categoryMap: Map<string, RoadmapCategory>,
  isAuthenticated: boolean,
): NodeState {
  const total = category.problems.length;
  if (total === 0) return 'coming-soon';

  // Skip prerequisite gating for unauthenticated users
  if (isAuthenticated) {
    const allPrereqsMet = category.prerequisiteSlugs.every((slug) => {
      const prereq = categoryMap.get(slug);
      return prereq ? hasSolvedAny(prereq) : true;
    });
    if (!allPrereqsMet) return 'locked';
  }

  const solved = category.problems.filter((p) => p.status === 'SOLVED').length;
  if (solved === 0) return 'not-started';
  if (solved === total) return 'complete';
  return 'in-progress';
}

// ── Build nodes ──

const COL_GAP = 420; // horizontal spacing (left to right)
const ROW_GAP = 200; // vertical spacing (spread within a level)

export function buildFlowNodes(
  categories: RoadmapCategory[],
  isAuthenticated: boolean,
): Node<SkillNodeData>[] {
  const categoryMap = new Map(categories.map((c) => [c.slug, c]));
  const nodes: Node<SkillNodeData>[] = [];

  for (const [slug, pos] of Object.entries(ROADMAP_LAYOUT)) {
    const category = categoryMap.get(slug);
    if (!category) continue;

    const state = computeNodeState(category, categoryMap, isAuthenticated);
    const solvedCount = category.problems.filter(
      (p) => p.status === 'SOLVED',
    ).length;

    nodes.push({
      id: slug,
      type: 'skillNode',
      position: {
        x: (pos.col - 1) * COL_GAP,
        y: (pos.row - 1) * ROW_GAP,
      },
      data: {
        category,
        state,
        solvedCount,
        totalCount: category.problems.length,
      },
      sourcePosition: Position.Right,
      targetPosition: Position.Left,
      draggable: false,
      selectable: true,
    });
  }

  return nodes;
}

// ── Edge colors ──
// CSS custom properties don't work in SVG stroke attributes,
// so we resolve the theme at runtime from the DOM.

function getEdgeColors(): Record<
  NodeState,
  { stroke: string; animated: boolean; dashed: boolean; opacity: number }
> {
  const root = document.documentElement;
  const isDark = root.classList.contains('dark');

  const neutral = isDark ? '#4b5563' : '#9ca3af';
  const muted = isDark ? '#9ca3af' : '#6b7280';
  const accent = '#fe7403';
  const success = isDark ? '#4ade80' : '#22c55e';

  return {
    locked: { stroke: neutral, dashed: true, opacity: 0.7, animated: false },
    'not-started': {
      stroke: muted,
      dashed: false,
      opacity: 0.8,
      animated: false,
    },
    'in-progress': {
      stroke: accent,
      dashed: false,
      opacity: 1,
      animated: true,
    },
    complete: { stroke: success, dashed: false, opacity: 1, animated: false },
    'coming-soon': {
      stroke: neutral,
      dashed: true,
      opacity: 0.5,
      animated: false,
    },
  };
}

export function buildFlowEdges(
  categories: RoadmapCategory[],
  isAuthenticated: boolean,
): Edge[] {
  const categoryMap = new Map(categories.map((c) => [c.slug, c]));
  const colors = getEdgeColors();

  const edges: Edge[] = [];
  for (const category of categories) {
    const targetState = computeNodeState(
      category,
      categoryMap,
      isAuthenticated,
    );
    const style = colors[targetState];

    for (const prereqSlug of category.prerequisiteSlugs) {
      edges.push({
        id: `${prereqSlug}-${category.slug}`,
        source: prereqSlug,
        target: category.slug,
        type: 'default',
        animated: style.animated,
        style: {
          stroke: style.stroke,
          strokeWidth: 2.5,
          strokeDasharray: style.dashed ? '6 4' : undefined,
          opacity: style.opacity,
        },
        markerEnd: {
          type: MarkerType.ArrowClosed,
          width: 18,
          height: 18,
          color: style.stroke,
        },
      });
    }
  }

  return edges;
}

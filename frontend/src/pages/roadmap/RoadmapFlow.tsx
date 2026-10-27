import { useMemo, useState, useCallback, useRef, type KeyboardEvent } from 'react';
import { useTranslation } from 'react-i18next';
import {
  ReactFlow,
  Controls,
  Background,
  BackgroundVariant,
  type Node,
  type NodeMouseHandler,
} from '@xyflow/react';
import '@xyflow/react/dist/style.css';

import type { RoadmapCategory } from '@/types/roadmap';
import { useTheme } from '@/context/ThemeContext';
import { useMediaQuery } from '@/hooks/useMediaQuery';
import {
  buildFlowNodes,
  buildFlowEdges,
  type SkillNodeData,
} from './flowUtils';
import SkillNode from './SkillNode';
import ProblemPanel from './ProblemPanel';

const nodeTypes = { skillNode: SkillNode };

interface RoadmapFlowProps {
  categories: RoadmapCategory[];
}

export default function RoadmapFlow({ categories }: RoadmapFlowProps) {
  const { t } = useTranslation('roadmap');
  const { theme } = useTheme();
  const reduceMotion = useMediaQuery('(prefers-reduced-motion: reduce)');
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);

  // Each node is named with its progress, so a focused node reads as more than "group".
  const nodes = useMemo(
    () =>
      buildFlowNodes(categories).map((node) => {
        const data = node.data as SkillNodeData;
        const name = t(`categories.${data.category.slug}.name`);
        return {
          ...node,
          ariaLabel:
            data.state === 'coming-soon'
              ? t('comingSoonLabel', { name })
              : t('nodeLabel', {
                  name,
                  progress: t('progress', { solved: data.solvedCount, total: data.totalCount }),
                }),
        };
      }),
    [categories, t],
  );
  const edges = useMemo(
    () => buildFlowEdges(categories, { isDark: theme === 'dark', reduceMotion }),
    [categories, theme, reduceMotion],
  );

  const categoryMap = useMemo(
    () => new Map(categories.map((c) => [c.slug, c])),
    [categories],
  );

  const selectedCategory = selectedSlug
    ? (categoryMap.get(selectedSlug) ?? null)
    : null;

  const toggle = useCallback(
    (slug: string) => {
      if (categoryMap.get(slug)?.problems.length === 0) return;
      setSelectedSlug((prev) => (prev === slug ? null : slug));
    },
    [categoryMap],
  );

  const onNodeClick: NodeMouseHandler<Node<SkillNodeData>> = useCallback(
    (_event, node) => toggle(node.id),
    [toggle],
  );

  // React Flow makes nodes focusable but Enter only selects them; open the panel the way a
  // click does, so the graph works without a pointer.
  const onKeyDown = (event: KeyboardEvent<HTMLDivElement>) => {
    if (event.key !== 'Enter' && event.key !== ' ') return;
    const node = (event.target as HTMLElement).closest<HTMLElement>('.react-flow__node');
    const slug = node?.dataset.id;
    if (!slug) return;
    event.preventDefault();
    toggle(slug);
  };

  // Closing returns focus to the node that opened the panel.
  const close = () => {
    const slug = selectedSlug;
    setSelectedSlug(null);
    if (slug) {
      containerRef.current
        ?.querySelector<HTMLElement>(`.react-flow__node[data-id="${CSS.escape(slug)}"]`)
        ?.focus();
    }
  };

  return (
    <div ref={containerRef} className="relative h-full w-full overflow-hidden bg-background" onKeyDown={onKeyDown}>
      <ReactFlow
        nodes={nodes}
        edges={edges}
        nodeTypes={nodeTypes}
        colorMode={theme}
        onNodeClick={onNodeClick}
        onPaneClick={() => setSelectedSlug(null)}
        defaultViewport={{ x: 300, y: 50, zoom: 0.65 }}
        minZoom={0.2}
        maxZoom={1.5}
        zoomOnScroll
        defaultEdgeOptions={{
          type: 'default',
        }}
        proOptions={{ hideAttribution: false }}>
        <Controls position="bottom-left" showInteractive={false} />
        <Background variant={BackgroundVariant.Dots} gap={24} size={1} />
      </ReactFlow>
      <ProblemPanel category={selectedCategory} onClose={close} />
    </div>
  );
}

import { useMemo, useState, useCallback } from 'react';
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
import { useAuth } from '@/context/AuthContext';
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
  const { isAuthenticated } = useAuth();
  const [selectedSlug, setSelectedSlug] = useState<string | null>(null);

  const nodes = useMemo(() => buildFlowNodes(categories, isAuthenticated), [categories, isAuthenticated]);
  const edges = useMemo(() => buildFlowEdges(categories, isAuthenticated), [categories, isAuthenticated]);

  const categoryMap = useMemo(
    () => new Map(categories.map((c) => [c.slug, c])),
    [categories],
  );

  const selectedCategory = selectedSlug
    ? (categoryMap.get(selectedSlug) ?? null)
    : null;

  const onNodeClick: NodeMouseHandler<Node<SkillNodeData>> = useCallback(
    (_event, node) => {
      const data = node.data as SkillNodeData;
      if (data.state === 'locked' || data.state === 'coming-soon') return;
      setSelectedSlug((prev) => (prev === node.id ? null : node.id));
    },
    [],
  );

  return (
    <div className="relative h-full w-full overflow-hidden bg-background">
      <ReactFlow
        nodes={nodes}
        edges={edges}
        nodeTypes={nodeTypes}
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
      <ProblemPanel
        category={selectedCategory}
        onClose={() => setSelectedSlug(null)}
      />
    </div>
  );
}

import type { ReactElement } from "react"
import ReactMarkdown from "react-markdown"
import type { Components } from "react-markdown"
import remarkGfm from "remark-gfm"
import rehypeHighlight from "rehype-highlight"
import { cn } from "@/lib/utils"
import { TreeDiagram } from "./diagrams/TreeDiagram"
import { GraphDiagram } from "./diagrams/GraphDiagram"
import { GridDiagram } from "./diagrams/GridDiagram"
import { LinkedListDiagram } from "./diagrams/LinkedListDiagram"
import { IntervalsDiagram } from "./diagrams/IntervalsDiagram"
import { parseDiagram, type ParsedDiagram } from "./diagrams/parseDiagram"

interface MarkdownRendererProps {
  source: string
  className?: string
}

// Draw a parsed `diagram-*` block as its component; one case per kind parseDiagram knows.
function drawDiagram(diagram: ParsedDiagram): ReactElement {
  switch (diagram.info) {
    case "diagram-tree": {
      const spec = diagram.spec
      return (
        <TreeDiagram
          nodes={spec.nodes}
          highlight={spec.highlight}
          after={spec.after}
        />
      )
    }
    case "diagram-graph": {
      const spec = diagram.spec
      return (
        <GraphDiagram
          edges={spec.edges}
          nodes={spec.nodes}
          directed={spec.directed}
          highlight_path={spec.highlight_path}
          after={spec.after}
        />
      )
    }
    case "diagram-grid": {
      const spec = diagram.spec
      return (
        <GridDiagram
          cells={spec.cells}
          highlight={spec.highlight}
          after={spec.after}
          boxes={spec.boxes}
          blank={spec.blank}
        />
      )
    }
    case "diagram-linked-list": {
      const spec = diagram.spec
      return (
        <LinkedListDiagram
          nodes={spec.nodes}
          cycle_to={spec.cycle_to}
          highlight={spec.highlight}
          after={spec.after}
        />
      )
    }
    case "diagram-intervals": {
      const spec = diagram.spec
      return (
        <IntervalsDiagram
          intervals={spec.intervals}
          highlight={spec.highlight}
          after={spec.after}
          added={spec.added}
          points={spec.points}
        />
      )
    }
  }
}

const components: Components = {
  code({ className, children, ...props }) {
    const match = /language-(\S+)/.exec(className || "")
    const language = match?.[1]
    if (language?.startsWith("diagram-")) {
      const body = String(children).replace(/\n$/, "")
      const parsed = parseDiagram(language, body)
      if (parsed.ok) return drawDiagram(parsed.diagram)
      // Unknown kind or parse error → fall through to default code rendering with the raw body.
    }
    return (
      <code className={className} {...props}>
        {children}
      </code>
    )
  },
}

export function MarkdownRenderer({ source, className }: MarkdownRendererProps) {
  return (
    <div className={cn("prose prose-sm dark:prose-invert max-w-none", className)}>
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeHighlight]}
        components={components}
      >
        {source}
      </ReactMarkdown>
    </div>
  )
}

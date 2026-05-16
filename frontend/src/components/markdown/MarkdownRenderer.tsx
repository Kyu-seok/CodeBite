import type { ReactElement } from "react"
import ReactMarkdown from "react-markdown"
import type { Components } from "react-markdown"
import remarkGfm from "remark-gfm"
import rehypeHighlight from "rehype-highlight"
import { cn } from "@/lib/utils"
import { TreeDiagram } from "./diagrams/TreeDiagram"
import { GraphDiagram } from "./diagrams/GraphDiagram"
import { GridDiagram } from "./diagrams/GridDiagram"
import {
  parseTreeDirective,
  parseGraphDirective,
  parseGridDirective,
} from "./diagrams/parseDirective"

interface MarkdownRendererProps {
  source: string
  className?: string
}

// Render a `diagram-*` fenced block as a custom component. On parse error,
// returns null so the caller renders the raw code block as a fallback.
function renderDiagram(language: string, body: string): ReactElement | null {
  try {
    if (language === "diagram-tree") {
      const spec = parseTreeDirective(body)
      return (
        <TreeDiagram
          nodes={spec.nodes}
          highlight={spec.highlight}
          after={spec.after}
        />
      )
    }
    if (language === "diagram-graph") {
      const spec = parseGraphDirective(body)
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
    if (language === "diagram-grid") {
      const spec = parseGridDirective(body)
      return (
        <GridDiagram
          cells={spec.cells}
          highlight={spec.highlight}
          after={spec.after}
        />
      )
    }
  } catch {
    // Fall through — caller renders the raw block instead.
  }
  return null
}

const components: Components = {
  code({ className, children, ...props }) {
    const match = /language-(\S+)/.exec(className || "")
    const language = match?.[1]
    if (language?.startsWith("diagram-")) {
      const body = String(children).replace(/\n$/, "")
      const rendered = renderDiagram(language, body)
      if (rendered) return rendered
      // Parse error → fall through to default code rendering with the raw body.
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

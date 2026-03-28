import { memo } from "react"
import { Handle, Position, type NodeProps } from "@xyflow/react"
import { Lock, Check } from "lucide-react"
import type { SkillNodeData, NodeState } from "./flowUtils"

const stateStyles: Record<NodeState, string> = {
  "locked":      "opacity-60 border-gray-300 dark:border-gray-600 bg-card cursor-not-allowed",
  "not-started": "border-gray-300 dark:border-gray-500 bg-card cursor-pointer hover:border-gray-400 dark:hover:border-gray-400 hover:shadow-md",
  "in-progress": "border-accent-500 bg-card ring-2 ring-accent-500/25 cursor-pointer hover:shadow-md",
  "complete":    "border-success-500 bg-card ring-2 ring-success-500/25 cursor-pointer hover:shadow-md",
  "coming-soon": "opacity-50 border-dashed border-gray-300 dark:border-gray-600 bg-card cursor-default",
}

const handleStyle = {
  width: 8,
  height: 8,
  background: "var(--color-border)",
  border: "2px solid var(--color-border)",
  borderRadius: "50%",
  opacity: 0,
}

function SkillNode({ data }: NodeProps) {
  const { category, state, solvedCount, totalCount } = data as SkillNodeData

  return (
    <>
      <Handle
        type="target"
        position={Position.Left}
        style={handleStyle}
        isConnectable={false}
      />
      <div
        className={`w-72 rounded-xl border-2 p-4 shadow-sm transition-all ${stateStyles[state]}`}
      >
        <div className="flex items-start justify-between gap-2">
          <h3 className="text-xl font-bold leading-tight text-foreground">
            {category.name}
          </h3>
          {state === "locked" && <Lock className="h-4.5 w-4.5 flex-shrink-0 text-muted-foreground" />}
          {state === "complete" && <Check className="h-5 w-5 flex-shrink-0 text-success-500" />}
        </div>

        <p className="mt-1.5 text-sm leading-snug text-muted-foreground italic">
          &ldquo;{category.description}&rdquo;
        </p>

        {state === "coming-soon" ? (
          <span className="mt-3 inline-block text-xs font-medium uppercase tracking-wider text-muted-foreground/60">
            Coming Soon
          </span>
        ) : (
          <div className="mt-3 flex items-center gap-2.5">
            <div className="h-2 flex-1 overflow-hidden rounded-full bg-secondary">
              <div
                className={`h-full rounded-full transition-all ${
                  state === "complete" ? "bg-success-500" : "bg-accent-500"
                }`}
                style={{ width: totalCount > 0 ? `${(solvedCount / totalCount) * 100}%` : "0%" }}
              />
            </div>
            <span className="text-sm font-semibold text-muted-foreground">
              {solvedCount}/{totalCount}
            </span>
          </div>
        )}
      </div>
      <Handle
        type="source"
        position={Position.Right}
        style={handleStyle}
        isConnectable={false}
      />
    </>
  )
}

export default memo(SkillNode)

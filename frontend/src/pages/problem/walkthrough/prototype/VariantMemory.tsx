// PROTOTYPE variant C: code + memory, in the manner of a memory-model visualiser. The approach's code
// with the running line marked, beside a frame of variables whose index variables are arrows into the
// list object and whose collections are arrows to their objects: a dict drawn as key → value rows.
import { useLayoutEffect, useRef, useState } from "react"
import type { StageProps } from "./PrototypeWalkthrough"
import { CODE, NAMES } from "./model"

function rel(el: Element, host: Element) {
  const a = el.getBoundingClientRect()
  const b = host.getBoundingClientRect()
  return { x: a.left - b.left, y: a.top - b.top, w: a.width, h: a.height }
}

export default function VariantMemory({ kind, run, step, index }: StageProps) {
  const host = useRef<HTMLDivElement>(null)
  const [arrows, setArrows] = useState<{ d: string; hot: boolean; label?: string }[]>([])
  const names = NAMES[kind]
  const code = CODE[kind]
  const vars = [
    { name: names.array, value: "", ref: "list" },
    { name: names.map, value: "", ref: "dict" },
    ...step.vars,
  ]

  useLayoutEffect(() => {
    const h = host.current
    if (!h) return
    const draw = () => {
      const next: { d: string; hot: boolean }[] = []
      h.querySelectorAll<HTMLElement>("[data-var]").forEach((v) => {
        const ref = v.dataset.ref
        const points = v.dataset.points
        const target = ref ? h.querySelector(`[data-obj="${ref}"]`) : points ? h.querySelector(`[data-cell="${points}"]`) : null
        if (!target) return
        const a = rel(v, h)
        const b = rel(target, h)
        const x1 = a.x + a.w
        const y1 = a.y + a.h / 2
        const toCell = !!points
        const x2 = toCell ? b.x + b.w / 2 : b.x
        const y2 = toCell ? b.y + b.h : b.y + 12
        const d = toCell
          ? `M ${x1} ${y1} C ${x1 + 40} ${y1}, ${x2} ${y2 + 40}, ${x2} ${y2}`
          : `M ${x1} ${y1} C ${x1 + 30} ${y1}, ${x2 - 30} ${y2}, ${x2} ${y2}`
        next.push({ d, hot: v.dataset.changed === "1" })
      })
      setArrows(next)
    }
    draw()
    const ro = new ResizeObserver(draw)
    ro.observe(h)
    return () => ro.disconnect()
  }, [index, run])

  return (
    <div ref={host} className="relative flex min-w-fit flex-wrap items-start gap-x-10 gap-y-4">
      <svg className="pointer-events-none absolute inset-0 z-10 h-full w-full overflow-visible">
        <defs>
          <marker id="mem-ah" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M0 0 L10 5 L0 10z" fill="currentColor" />
          </marker>
        </defs>
        {arrows.map((a, i) => (
          <path key={i} d={a.d} fill="none" strokeWidth={a.hot ? 2 : 1.25} markerEnd="url(#mem-ah)"
            className={a.hot ? "stroke-accent-500 text-accent-500" : "stroke-foreground/45 text-foreground/45"} />
        ))}
      </svg>

      {/* code */}
      <pre className="rounded-lg border border-border bg-background py-2 text-[12px] leading-5">
        {code.map((l, i) => (
          <div key={i} className={`flex pr-3 ${step.line === i + 1 ? "bg-accent-500/15" : ""}`}>
            <span className={`w-5 text-center ${step.line === i + 1 ? "text-accent-500" : "text-transparent"}`}>➜</span>
            <span className="w-5 select-none pr-2 text-right text-muted-foreground/60">{i + 1}</span>
            <code className="font-mono">{l}</code>
          </div>
        ))}
      </pre>

      <div className="flex items-start gap-16">
        {/* frame */}
        <div>
          <div className="mb-1 text-[10px] uppercase tracking-wide text-muted-foreground">Frame</div>
          <div className="rounded-lg border border-border bg-background p-2">
            {vars.map((v) => (
              <div key={v.name} className="flex items-center justify-end gap-2 py-0.5">
                <span className="font-mono text-xs text-muted-foreground">{v.name}</span>
                <span
                  data-var
                  data-ref={"ref" in v ? v.ref : undefined}
                  data-points={"points" in v && v.points != null ? String(v.points) : undefined}
                  data-changed={"changed" in v && v.changed ? "1" : "0"}
                  className={`flex h-6 min-w-[2.25rem] items-center justify-center rounded border px-1.5 font-mono text-xs transition-colors duration-300 ${
                    "changed" in v && v.changed ? "border-accent-500 bg-accent-500/15 font-bold" : "border-border"
                  }`}
                >
                  {"ref" in v || ("points" in v && v.points != null) ? "•" : v.value}
                </span>
              </div>
            ))}
          </div>
        </div>

        {/* objects */}
        <div className="flex flex-col gap-10 pt-4">
          <div data-obj="list">
            <div className="mb-0.5 text-[10px] text-muted-foreground">{kind === "count" ? "list" : "str"}</div>
            <div className="flex">
              {run.values.map((v, i) => (
                <div key={i} data-cell={i} className={`flex w-8 flex-col items-center border border-r-0 border-border last:border-r ${step.cursor === i ? "bg-accent-500/15" : step.move?.dir === "out" && step.move.index === i ? "bg-red-500/15" : step.bracket && i >= step.bracket[0] && i <= step.bracket[1] ? "bg-foreground/5" : "bg-background"}`}>
                  <span className="text-[9px] text-muted-foreground">{i}</span>
                  <span className="pb-1 font-mono text-sm font-semibold">{v}</span>
                </div>
              ))}
            </div>
          </div>
          <div data-obj="dict">
            <div className="mb-0.5 text-[10px] text-muted-foreground">{kind === "count" ? "dict" : "Counter"}</div>
            <table className="border-collapse font-mono text-sm">
              <tbody>
                {step.map.length === 0 && (
                  <tr><td className="border border-dashed border-border px-3 py-1 text-xs text-muted-foreground">empty</td></tr>
                )}
                {step.map.map((e) => {
                  const hot = step.hot === e.key
                  const tone = !hot ? "" : step.hotKind === "del" ? "bg-red-500/15 line-through" : step.hotKind === "dec" ? "bg-amber-500/20" : "bg-emerald-500/20"
                  return (
                    <tr key={e.key} className={`transition-colors duration-300 ${tone}`}>
                      <td className="border border-border px-2 py-0.5 text-right">{kind === "count" ? e.key : `'${e.key}'`}</td>
                      <td className="border border-border px-3 py-0.5 font-bold">{e.count}</td>
                    </tr>
                  )
                })}
              </tbody>
            </table>
          </div>
          {(step.ranked || step.done) && (
            <div>
              <div className="mb-0.5 text-[10px] text-muted-foreground">return value</div>
              <div className="inline-flex rounded border-2 border-accent-500 px-2 py-0.5 font-mono text-sm font-bold">
                {step.answer ?? (step.ranked ? `ranked = [${step.ranked.join(", ")}]` : "")}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

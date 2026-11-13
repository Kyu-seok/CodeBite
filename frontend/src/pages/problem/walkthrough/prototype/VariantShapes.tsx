// PROTOTYPE variant A: every structure in its own shape (array strip with window bracket and pointer
// carets, the map as a dict of key cards with count pips and k slots, the output box), and each step's
// value flies from its source to its target, leaving a faint arrow.
import { useLayoutEffect, useRef, useState } from "react"
import type { StageProps } from "./PrototypeWalkthrough"
import { NAMES } from "./model"

const CELL = 40
const GAP = 4

function rel(el: Element, host: Element) {
  const a = el.getBoundingClientRect()
  const b = host.getBoundingClientRect()
  return { x: a.left - b.left, y: a.top - b.top, w: a.width, h: a.height }
}

export default function VariantShapes({ kind, run, step, index, forward }: StageProps) {
  const host = useRef<HTMLDivElement>(null)
  const [arrows, setArrows] = useState<{ d: string; tone: string }[]>([])
  const names = NAMES[kind]
  const reduce = typeof window !== "undefined" && window.matchMedia("(prefers-reduced-motion: reduce)").matches

  // pairs of [source selector, target selector, tone] for this step
  const pairs: [string, string, string][] = []
  if (step.move) {
    const cell = `[data-cell="${step.move.index}"]`
    const card = `[data-key="${step.move.key}"]`
    if (step.move.dir === "in") pairs.push([cell, card, "good"])
    else pairs.push([card, cell, "bad"])
  }
  for (const key of step.outMove) pairs.push([`[data-key="${key}"]`, `[data-out="${key}"]`, "path"])

  useLayoutEffect(() => {
    const h = host.current
    if (!h) return
    const draw = () => {
      const next: { d: string; tone: string }[] = []
      for (const [s, t, tone] of pairs) {
        const a = h.querySelector(s)
        const b = h.querySelector(t)
        if (!a || !b) continue
        const ra = rel(a, h)
        const rb = rel(b, h)
        const down = rb.y > ra.y
        const x1 = ra.x + ra.w / 2
        const y1 = down ? ra.y + ra.h : ra.y
        const x2 = rb.x + rb.w / 2
        const y2 = down ? rb.y : rb.y + rb.h
        const my = (y1 + y2) / 2
        next.push({ d: `M ${x1} ${y1} C ${x1} ${my}, ${x2} ${my}, ${x2} ${y2}`, tone })
      }
      setArrows(next)
    }
    draw()
    if (forward && !reduce) {
      for (const [s, t, tone] of pairs) {
        const a = h.querySelector(s)
        const b = h.querySelector(t)
        if (!a || !b) continue
        const ra = rel(a, h)
        const rb = rel(b, h)
        const token = document.createElement("div")
        token.textContent = (a.getAttribute("data-token") ?? a.textContent ?? "").trim()
        token.className = `pointer-events-none absolute z-20 flex items-center justify-center rounded-md font-mono text-sm font-bold text-white shadow-lg ${tone === "bad" ? "bg-red-500" : tone === "path" ? "bg-accent-500" : "bg-emerald-600"}`
        Object.assign(token.style, { left: `${ra.x + ra.w / 2 - 16}px`, top: `${ra.y + ra.h / 2 - 16}px`, width: "32px", height: "32px" })
        h.appendChild(token)
        const dx = rb.x + rb.w / 2 - (ra.x + ra.w / 2)
        const dy = rb.y + rb.h / 2 - (ra.y + ra.h / 2)
        token
          .animate(
            [
              { transform: "translate(0,0) scale(1)", opacity: 1 },
              { transform: `translate(${dx * 0.5}px, ${dy * 0.5 - 30}px) scale(1.15)`, opacity: 1, offset: 0.5 },
              { transform: `translate(${dx}px, ${dy}px) scale(0.9)`, opacity: 0.2 },
            ],
            { duration: 550, easing: "cubic-bezier(.4,0,.2,1)" },
          )
          .finished.then(() => token.remove(), () => token.remove())
      }
    }
    const ro = new ResizeObserver(draw)
    ro.observe(h)
    return () => ro.disconnect()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [index, run])

  const inWindow = (i: number) =>
    kind === "count" ? true : step.bracket ? i >= step.bracket[0] && i <= step.bracket[1] : false
  const slots = kind === "window" ? Math.max(run.k, step.map.length) : step.map.length
  const ordered = step.ranked ? step.ranked.map((k) => step.map.find((m) => m.key === k)!) : step.map
  const span = (a: number, b: number) => ({ left: a * (CELL + GAP), width: (b - a + 1) * (CELL + GAP) - GAP })

  return (
    <div ref={host} className="relative flex min-w-fit flex-col gap-6">
      <svg className="pointer-events-none absolute inset-0 z-10 h-full w-full overflow-visible">
        <defs>
          {["good", "bad", "path"].map((t) => (
            <marker key={t} id={`ah-${t}`} viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
              <path d="M0 0 L10 5 L0 10z" className={t === "good" ? "fill-emerald-500" : t === "bad" ? "fill-red-500" : "fill-accent-500"} />
            </marker>
          ))}
        </defs>
        {arrows.map((a, i) => (
          <path key={i} d={a.d} fill="none" strokeWidth={1.75} strokeDasharray="4 3" markerEnd={`url(#ah-${a.tone})`}
            className={a.tone === "good" ? "stroke-emerald-500/70" : a.tone === "bad" ? "stroke-red-500/70" : "stroke-accent-500/80"} />
        ))}
      </svg>

      {/* the array */}
      <section>
        <div className="mb-1 font-mono text-xs text-muted-foreground">{names.array}</div>
        <div className="relative" style={{ paddingTop: kind === "window" ? 22 : 0 }}>
          {kind === "window" && step.bracket && !step.done && (
            <div
              className={`absolute top-0 flex h-4 justify-center rounded-t-md border-x-2 border-t-2 text-[10px] font-semibold leading-none transition-all duration-300 ${step.overflow ? "border-red-500 text-red-500" : "border-accent-500 text-accent-500"}`}
              style={span(step.bracket[0], step.bracket[1])}
            >
              <span className="-mt-3 bg-card px-1">window{step.overflow ? ` · ${step.map.length} genres > k` : ""}</span>
            </div>
          )}
          <div className="flex" style={{ gap: GAP }}>
            {run.values.map((v, i) => {
              const cur = step.cursor === i
              const out = step.move?.dir === "out" && step.move.index === i
              const done = step.done && kind === "window" && step.bestRange && i >= step.bestRange[0] && i <= step.bestRange[1]
              const unread = kind === "count" ? step.cursor === null ? !step.done && step.ranked === null : i > step.cursor : step.cursor === null ? !step.done : i > step.cursor
              return (
                <div
                  key={i}
                  data-cell={i}
                  data-token={v}
                  className={[
                    "flex items-center justify-center rounded-md border-2 font-mono text-base font-semibold transition-all duration-300",
                    done ? "border-accent-500 bg-accent-500 text-white" : "",
                    cur && !done ? "border-accent-500 bg-accent-500/10" : "",
                    out ? "border-red-500 text-red-500 line-through" : "",
                    !cur && !out && !done ? "border-border" : "",
                    !inWindow(i) && !out && !done ? "opacity-35" : "",
                    unread ? "border-dashed opacity-45" : "",
                  ].join(" ")}
                  style={{ width: CELL, height: CELL }}
                >
                  {v}
                </div>
              )
            })}
          </div>
          <div className="relative mt-1 h-9 font-mono text-[10px] text-muted-foreground">
            {run.values.map((_, i) => (
              <span key={i} className="absolute text-center" style={{ left: i * (CELL + GAP), width: CELL }}>{i}</span>
            ))}
            {step.cursor !== null && (
              <span className="absolute top-3 text-center font-semibold text-accent-500 transition-all duration-300" style={{ left: step.cursor * (CELL + GAP), width: CELL }}>
                ▲<br />{names.cursor}
              </span>
            )}
            {kind === "window" && step.left !== null && step.cursor !== null && (
              <span className="absolute top-3 text-center font-semibold text-sky-500 transition-all duration-300" style={{ left: step.left * (CELL + GAP) - (step.left === step.cursor ? 14 : 0), width: CELL }}>
                ▲<br />left
              </span>
            )}
          </div>
          {kind === "window" && step.bestRange && (
            <div className="relative mt-2 h-6">
              <div
                className={`absolute flex h-3 items-end justify-center rounded-b-md border-x-2 border-b-2 border-dashed transition-all duration-300 ${step.bestNew || step.done ? "border-emerald-500" : "border-muted-foreground/50"}`}
                style={span(step.bestRange[0], step.bestRange[1])}
              >
                <span className={`-mb-4 bg-card px-1 text-[10px] font-semibold ${step.bestNew || step.done ? "text-emerald-600" : "text-muted-foreground"}`}>
                  best = {step.best}{step.bestNew ? " ★" : ""}
                </span>
              </div>
            </div>
          )}
        </div>
      </section>

      {/* the map */}
      <section>
        <div className="mb-1 font-mono text-xs text-muted-foreground">
          {names.map} = {kind === "window" ? "Counter" : ""}{"{"}
          {kind === "window" && <span className="ml-2 font-sans">holds at most k = {run.k} genres</span>}
        </div>
        <div className="flex flex-wrap gap-2 rounded-lg border border-dashed border-border p-2" style={{ minHeight: 84 }}>
          {Array.from({ length: Math.max(slots, ordered.length) }).map((_, s) => {
            const e = ordered[s]
            const overSlot = kind === "window" && s >= run.k
            if (!e) {
              return (
                <div key={`slot-${s}`} className="flex w-20 items-center justify-center rounded-lg border-2 border-dashed border-border/70 text-[10px] text-muted-foreground/60">
                  free slot
                </div>
              )
            }
            const hot = step.hot === e.key
            const gone = hot && step.hotKind === "del"
            const rank = step.ranked ? step.ranked.indexOf(e.key) : -1
            const top = step.ranked && rank < run.k
            return (
              <div
                key={e.key}
                data-key={e.key}
                data-token={kind === "count" ? e.key : e.key}
                className={[
                  "relative w-20 rounded-lg border-2 bg-background p-1.5 transition-all duration-300",
                  overSlot || (step.overflow && hot && step.hotKind === "add") ? "border-red-500 bg-red-500/10" : "",
                  hot && !gone && !overSlot && (step.hotKind === "add" || step.hotKind === "inc") ? "border-emerald-500 bg-emerald-500/10" : "",
                  hot && step.hotKind === "dec" ? "border-amber-500 bg-amber-500/10" : "",
                  gone ? "border-red-500 opacity-40" : "",
                  top ? "border-accent-500" : "",
                  step.ranked && !top ? "opacity-40" : "",
                  !hot && !overSlot && !step.ranked ? "border-border" : "",
                ].join(" ")}
              >
                {rank >= 0 && <span className="absolute -top-2.5 right-1 rounded-full bg-foreground px-1.5 text-[10px] font-bold text-background">#{rank + 1}</span>}
                <div className={`text-center font-mono text-sm font-bold ${gone ? "line-through" : ""}`}>{kind === "count" ? `#${e.key}` : `'${e.key}'`}</div>
                <div className="mt-1 flex min-h-[14px] flex-wrap justify-center gap-0.5">
                  {Array.from({ length: Math.min(e.count, 8) }).map((_, p) => (
                    <span key={p} className={`h-2.5 w-2.5 rounded-full ${hot && p === e.count - 1 && step.hotKind !== "dec" ? "bg-emerald-500" : "bg-foreground/60"}`} />
                  ))}
                  {hot && step.hotKind === "dec" && <span className="h-2.5 w-2.5 rounded-full border border-dashed border-red-500" />}
                  {gone && <span className="h-2.5 w-2.5 rounded-full border border-dashed border-red-500" />}
                </div>
                <div className="text-center font-mono text-xs text-muted-foreground">{e.count}</div>
                {gone && <div className="text-center text-[10px] font-semibold text-red-500">deleted</div>}
              </div>
            )
          })}
        </div>
        <div className="font-mono text-xs text-muted-foreground">{"}"}</div>
      </section>

      {/* the output */}
      <section className="flex items-center gap-3">
        <div className="font-mono text-xs text-muted-foreground">{kind === "count" ? `${names.out} (top k = ${run.k})` : "return best"}</div>
        {kind === "count" ? (
          <div className="flex min-h-[44px] min-w-[120px] gap-1.5 rounded-lg border-2 border-foreground/30 bg-background p-1.5">
            {step.output.map((o) => (
              <span key={o} data-out={o} className="flex h-8 items-center rounded-md bg-accent-500 px-2 font-mono text-sm font-bold text-white">#{o}</span>
            ))}
            {step.ranked &&
              step.output.length === 0 &&
              step.ranked.slice(0, run.k).map((o) => (
                <span key={o} data-out={o} className="flex h-8 items-center rounded-md border-2 border-dashed border-accent-500/50 px-2 font-mono text-sm text-accent-500/60">#{o}?</span>
              ))}
          </div>
        ) : (
          <div className={`flex h-11 min-w-[44px] items-center justify-center rounded-lg border-2 px-3 font-mono text-lg font-bold ${step.done ? "border-accent-500 bg-accent-500 text-white" : step.bestNew ? "border-emerald-500 text-emerald-600" : "border-foreground/30"}`}>
            {step.best}
          </div>
        )}
      </section>
    </div>
  )
}

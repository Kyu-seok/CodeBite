// PROTOTYPE (throwaway): the Walkthrough tab with ?variant=A|B|C on top-espresso-machines and
// unique-genre-window. Shared shell (runs, stepper, caption); each variant draws the stage its own way.
import { useEffect, useMemo, useRef, useState } from "react"
import { useTranslation } from "react-i18next"
import { getWalkthrough } from "@/api/problems"
import { textOf, type Walkthrough as WalkthroughData } from "@/components/walkthrough/walkthrough.js"
import PrototypeSwitcher from "@/components/PrototypeSwitcher"
import { walkthroughLang } from "../walkthroughTab"
import { buildRun, KIND, type Kind, type Lang, type RunModel, type Step } from "./model"
import VariantShapes from "./VariantShapes"
import VariantFlow from "./VariantFlow"
import VariantMemory from "./VariantMemory"

export const PROTOTYPE_VARIANTS = [
  { key: "A", name: "Shapes + moving token" },
  { key: "B", name: "Flow ledger" },
  { key: "C", name: "Code + memory" },
]

export function isPrototypeSlug(slug: string) {
  return slug in KIND
}

export interface StageProps {
  kind: Kind
  run: RunModel
  step: Step
  index: number
  forward: boolean
  lang: Lang
}

export default function PrototypeWalkthrough({ slug, variant }: { slug: string; variant: string }) {
  const { i18n } = useTranslation("problem")
  const lang = walkthroughLang(i18n.resolvedLanguage ?? i18n.language) === "ko" ? "ko" : "en"
  const [data, setData] = useState<WalkthroughData | null>(null)
  const [runIndex, setRunIndex] = useState(0)
  const [pos, setPos] = useState({ index: 0, forward: true })
  const playerRef = useRef<HTMLDivElement>(null)
  const kind = KIND[slug]

  useEffect(() => {
    getWalkthrough(slug).then((res) => setData(res.data))
  }, [slug])

  const runs = useMemo(
    () => (data ? data.runs.map((r) => buildRun(kind, textOf(r.label, lang), String(r.input))) : []),
    [data, kind, lang],
  )
  const run = runs[runIndex]
  const go = (to: number) => {
    if (!run) return
    const next = Math.max(0, Math.min(run.steps.length - 1, to))
    setPos((p) => ({ index: next, forward: next === p.index + 1 }))
  }

  useEffect(() => {
    playerRef.current?.focus()
  }, [data])

  if (!data || !run) return <div className="p-4 text-sm text-muted-foreground">Loading prototype…</div>
  const step = run.steps[pos.index]
  const Stage = variant === "B" ? VariantFlow : variant === "C" ? VariantMemory : VariantShapes

  return (
    <div className="p-4">
      <h2 className="text-lg font-semibold">{textOf(data.title, lang)}</h2>
      <p className="mb-3 text-sm text-muted-foreground">{textOf(data.approach, lang)}</p>
      <div
        ref={playerRef}
        tabIndex={0}
        data-proto-player
        className="rounded-xl border border-border bg-card outline-none focus-visible:ring-2 focus-visible:ring-accent-500"
        onKeyDown={(e) => {
          if (e.key === "ArrowRight") { e.preventDefault(); e.stopPropagation(); go(pos.index + 1) }
          if (e.key === "ArrowLeft") { e.preventDefault(); e.stopPropagation(); go(pos.index - 1) }
        }}
      >
        <div className="flex flex-wrap items-center gap-1.5 border-b border-border px-3 py-2">
          {runs.map((r, i) => (
            <button
              key={i}
              onClick={() => { setRunIndex(i); setPos({ index: 0, forward: false }) }}
              className={`rounded-full border px-3 py-0.5 text-xs ${i === runIndex ? "border-foreground font-semibold" : "border-border text-muted-foreground"}`}
            >
              {r.label}
            </button>
          ))}
          <code className="ml-auto break-all text-xs text-muted-foreground">{run.input}</code>
        </div>
        <div className="overflow-x-auto px-3 py-4">
          <Stage kind={kind} run={run} step={step} index={pos.index} forward={pos.forward} lang={lang} />
        </div>
        <div className="border-t border-border px-3 py-2">
          <p className="min-h-[3rem] text-sm leading-relaxed">{lang === "ko" ? step.ko : step.en}</p>
          <div className="mt-2 flex items-center gap-2">
            <button className="rounded border border-border px-2 py-0.5 text-sm" onClick={() => go(0)}>⏮</button>
            <button className="rounded border border-border px-2 py-0.5 text-sm" onClick={() => go(pos.index - 1)}>←</button>
            <button className="rounded border border-border px-2 py-0.5 text-sm" onClick={() => go(pos.index + 1)}>→</button>
            <input
              type="range" min={0} max={run.steps.length - 1} value={pos.index}
              onChange={(e) => setPos({ index: Number(e.target.value), forward: false })}
              className="flex-1 accent-accent-500"
            />
            <span className="text-xs tabular-nums text-muted-foreground">{pos.index + 1} / {run.steps.length}</span>
          </div>
        </div>
      </div>
      <PrototypeSwitcher variants={PROTOTYPE_VARIANTS} />
    </div>
  )
}

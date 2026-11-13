// PROTOTYPE (throwaway): floating variant switcher for ?variant= prototypes. Dev builds only.
import { useEffect } from "react"
import { useSearchParams } from "react-router-dom"

export default function PrototypeSwitcher({ variants }: { variants: { key: string; name: string }[] }) {
  const [params, setParams] = useSearchParams()
  const current = params.get("variant") ?? variants[0].key
  const i = Math.max(0, variants.findIndex((v) => v.key === current))
  const to = (d: number) => {
    const next = variants[(i + d + variants.length) % variants.length].key
    const p = new URLSearchParams(params)
    p.set("variant", next)
    setParams(p, { replace: true })
  }

  useEffect(() => {
    const onKey = (e: KeyboardEvent) => {
      const el = document.activeElement as HTMLElement | null
      if (el?.closest("input, textarea, [contenteditable], [data-proto-player], .monaco-editor")) return
      if (e.key === "ArrowLeft") to(-1)
      if (e.key === "ArrowRight") to(1)
    }
    window.addEventListener("keydown", onKey)
    return () => window.removeEventListener("keydown", onKey)
  })

  if (!import.meta.env.DEV) return null
  return (
    <div className="fixed bottom-4 left-1/2 z-50 flex -translate-x-1/2 items-center gap-3 rounded-full bg-black px-4 py-2 text-sm text-white shadow-2xl ring-2 ring-fuchsia-500">
      <button onClick={() => to(-1)} aria-label="previous variant">◀</button>
      <span className="font-mono">
        {variants[i].key} <span className="opacity-70">({variants[i].name})</span>
      </span>
      <button onClick={() => to(1)} aria-label="next variant">▶</button>
    </div>
  )
}

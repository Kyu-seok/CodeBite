// PROTOTYPE variant B: a flow ledger. Every element read leaves a token in its key's bucket, wired back
// to the cell it came from, so a count is visibly "these elements". Wires accumulate over the run (past
// faint, this step bold and drawn in); a dropped element's token is pulled back out. For a window, a
// timeline under the buckets lists every window the run passed through, the best one marked.
import type { StageProps } from "./PrototypeWalkthrough"
import { NAMES, type Move } from "./model"

const C = 34
const G = 6
const TOK_W = 30
const TOK_H = 16

export default function VariantFlow({ kind, run, step, index }: StageProps) {
  const names = NAMES[kind]
  const n = run.values.length
  const arrW = n * (C + G) - G

  // every key ever seen in this run, first-seen order, so buckets never jump around
  const keys: string[] = []
  for (const m of step.history) if (!keys.includes(m.key)) keys.push(m.key)
  const maxStack = Math.max(1, ...run.steps.flatMap((s) => s.map.map((m) => m.count)))

  // tokens currently in each bucket: the source indexes, replayed from history
  const tokens = new Map<string, number[]>(keys.map((k) => [k, []]))
  const replay = (h: Move[]) => {
    for (const m of h) {
      const list = tokens.get(m.key)!
      if (m.dir === "in") list.push(m.index)
      else list.splice(list.indexOf(m.index), 1)
    }
  }
  const current = step.move
  // an out move: the leaving token stays in place this step, drawn in red
  replay(step.history.slice(0, current ? -1 : undefined))
  const leaving = current?.dir === "out" ? current : null
  if (current?.dir === "in") replay([current])

  const bw = 44
  const allKeys = new Set(run.values).size
  const bucketsW = Math.max(1, keys.length) * (bw + 18) - 18
  const fullBucketsW = allKeys * (bw + 18) - 18
  const W = Math.max(arrW, fullBucketsW + 190) + 16
  const arrX = (W - arrW) / 2
  const bX = Math.max(8, (W - fullBucketsW - 120) / 2)
  const arrY = 26
  const bTop = arrY + C + 70
  const bH = maxStack * (TOK_H + 3) + 8
  const bBase = bTop + bH
  const cellX = (i: number) => arrX + i * (C + G)
  const bucketX = (k: string) => bX + keys.indexOf(k) * (bw + 18)
  const tokPos = (k: string, slot: number) => ({ x: bucketX(k) + (bw - TOK_W) / 2, y: bBase - 4 - (slot + 1) * (TOK_H + 3) })
  const outY = bBase + 62
  const tlTop = kind === "window" ? bBase + 46 : outY + 40
  const rows = kind === "window" ? step.windows.length : 0
  const H = kind === "window" ? tlTop + 20 + Math.max(1, rows) * 12 + 8 : outY + 40

  const wire = (i: number, k: string, slot: number) => {
    const p = tokPos(k, slot)
    const x1 = cellX(i) + C / 2
    const y1 = arrY + C
    const x2 = p.x + TOK_W / 2
    const y2 = p.y
    const my = (y1 + bTop) / 2 + 10
    return `M ${x1} ${y1} C ${x1} ${my}, ${x2} ${my}, ${x2} ${y2}`
  }

  const inWin = (i: number) => (kind === "count" ? true : step.bracket ? i >= step.bracket[0] && i <= step.bracket[1] : false)

  return (
    <svg key={index} viewBox={`0 0 ${W} ${H}`} width={W} className="block max-w-none text-foreground">
      <style>{`
        @keyframes proto-draw { from { stroke-dashoffset: 1 } to { stroke-dashoffset: 0 } }
        @keyframes proto-pop { from { transform: scale(0.2); opacity: 0 } to { transform: scale(1); opacity: 1 } }
        .proto-draw { stroke-dasharray: 1; animation: proto-draw .5s ease-out both }
        .proto-pop { transform-box: fill-box; transform-origin: center; animation: proto-pop .35s .35s ease-out both }
        @media (prefers-reduced-motion: reduce) { .proto-draw, .proto-pop { animation: none } }
      `}</style>
      <text x={arrX} y={8} className="fill-muted-foreground font-mono" fontSize={10}>{names.array}</text>

      {/* window band behind the array */}
      {kind === "window" && step.bracket && (
        <rect x={cellX(step.bracket[0]) - 3} y={arrY - 3} width={(step.bracket[1] - step.bracket[0] + 1) * (C + G) - G + 6} height={C + 6} rx={7}
          className={step.done ? "fill-accent-500/25" : step.overflow ? "fill-red-500/20" : "fill-accent-500/15"} />
      )}

      {/* wires for tokens still in buckets */}
      {keys.flatMap((k) =>
        tokens.get(k)!.map((i, slot) => {
          const now = current?.dir === "in" && current.index === i
          const out = leaving?.index === i
          return (
            <path key={`w-${k}-${i}`} d={wire(i, k, slot)} fill="none" pathLength={1}
              strokeDasharray={out ? "0.03 0.02" : undefined}
              className={now ? "proto-draw stroke-emerald-500" : out ? "stroke-red-500" : "stroke-foreground/20"} strokeWidth={now || out ? 2 : 1} />
          )
        }),
      )}

      {/* the array */}
      {run.values.map((v, i) => {
        const cur = step.cursor === i
        const out = leaving?.index === i
        const read = step.history.some((m) => m.index === i)
        return (
          <g key={i} opacity={!read ? 0.35 : !inWin(i) && !out ? 0.4 : 1}>
            <rect x={cellX(i)} y={arrY} width={C} height={C} rx={5}
              className={out ? "fill-red-500/15 stroke-red-500" : cur ? "fill-emerald-500/15 stroke-emerald-500" : "fill-background stroke-foreground/50"}
              strokeWidth={cur || out ? 2 : 1.25} strokeDasharray={!read ? "3 2" : undefined} />
            <text x={cellX(i) + C / 2} y={arrY + C / 2 + 5} textAnchor="middle" className={`font-mono ${out ? "fill-red-500" : "fill-foreground"}`} fontSize={14} fontWeight={600}
              textDecoration={out ? "line-through" : undefined}>{v}</text>
            <text x={cellX(i) + C / 2} y={arrY - 5} textAnchor="middle" className="fill-muted-foreground font-mono" fontSize={8}>{i}</text>
          </g>
        )
      })}

      {/* buckets */}
      <text x={bX + fullBucketsW + 8} y={bTop + 28} className="fill-muted-foreground font-mono" fontSize={10}>{names.map}</text>
      <text x={bX + fullBucketsW + 8} y={bTop + 41} className="fill-muted-foreground" fontSize={9}>one token per</text>
      <text x={bX + fullBucketsW + 8} y={bTop + 52} className="fill-muted-foreground" fontSize={9}>element counted</text>
      {keys.map((k) => {
        const list = tokens.get(k)!
        const entry = step.map.find((m) => m.key === k)
        const gone = !entry || entry.count === 0
        const rank = step.ranked ? step.ranked.indexOf(k) : -1
        const top = rank >= 0 && rank < run.k
        const x = bucketX(k)
        return (
          <g key={k} opacity={gone && !leaving ? 0.35 : step.ranked && !top ? 0.45 : 1}>
            <path d={`M ${x} ${bTop} L ${x} ${bBase} L ${x + bw} ${bBase} L ${x + bw} ${bTop}`} fill="none"
              className={top ? "stroke-accent-500" : step.overflow && step.hot === k ? "stroke-red-500" : "stroke-foreground/50"} strokeWidth={top ? 2.5 : 1.5}
              strokeDasharray={gone ? "4 3" : undefined} />
            {list.map((i, slot) => {
              const p = tokPos(k, slot)
              const now = current?.dir === "in" && current.index === i
              const out = leaving?.index === i
              return (
                <g key={i} className={now ? "proto-pop" : ""}>
                  <rect x={p.x} y={p.y} width={TOK_W} height={TOK_H} rx={3} strokeDasharray={out ? "3 2" : undefined}
                    className={out ? "fill-red-500/10 stroke-red-500" : now ? "fill-emerald-500" : top ? "fill-accent-500" : "fill-foreground/70"} />
                  <text x={p.x + TOK_W / 2} y={p.y + TOK_H - 4} textAnchor="middle" className={`font-mono ${out ? "fill-red-500" : "fill-background"}`} fontSize={9}>[{i}]</text>
                </g>
              )
            })}
            <text x={x + bw / 2} y={bBase + 13} textAnchor="middle" className="fill-foreground font-mono" fontSize={12} fontWeight={700}>
              {kind === "count" ? `#${k}` : `'${k}'`}
            </text>
            <text x={x + bw / 2} y={bBase + 25} textAnchor="middle" className="fill-muted-foreground font-mono" fontSize={9}>
              {gone ? "deleted" : `= ${entry!.count}`}
            </text>
            {rank >= 0 && (
              <text x={x + bw / 2} y={bBase + 38} textAnchor="middle" className="fill-accent-500 font-mono" fontSize={10} fontWeight={700}>rank {rank + 1}</text>
            )}
          </g>
        )
      })}
      {kind === "window" && (
        <text x={bX + bucketsW + 8} y={bTop + 12} className={step.overflow ? "fill-red-500" : "fill-muted-foreground"} fontSize={10}>
          {step.map.filter((m) => m.count > 0).length} / k = {run.k}
        </text>
      )}

      {/* output (count) */}
      {kind === "count" && (
        <g>
          <text x={bX} y={outY + 4} className="fill-muted-foreground font-mono" fontSize={10}>{names.out}:</text>
          {step.output.map((o, j) => (
            <g key={o} className="proto-pop">
              <rect x={bX + 72 + j * 44} y={outY - 10} width={38} height={22} rx={4} className="fill-accent-500" />
              <text x={bX + 72 + j * 44 + 19} y={outY + 5} textAnchor="middle" className="fill-white font-mono" fontSize={12} fontWeight={700}>#{o}</text>
            </g>
          ))}
          {step.output.map((o, j) => (
            <path key={`ow-${o}`} pathLength={1} className="proto-draw stroke-accent-500" fill="none" strokeWidth={1.5}
              d={`M ${bucketX(o) + bw / 2} ${bBase + 42} L ${bX + 72 + j * 44 + 19} ${outY - 10}`} />
          ))}
        </g>
      )}

      {/* timeline of windows (window) */}
      {kind === "window" && (
        <g>
          <text x={arrX} y={tlTop + 8} className="fill-muted-foreground" fontSize={10}>windows the run passed through (each a candidate)</text>
          {step.windows.map(([a, b], j) => {
            const isBest = step.bestRange && a === step.bestRange[0] && b === step.bestRange[1]
            const last = j === step.windows.length - 1
            return (
              <g key={j}>
                <rect x={cellX(a) + 2} y={tlTop + 16 + j * 12} width={(b - a + 1) * (C + G) - G - 4} height={8} rx={4}
                  className={isBest ? "fill-emerald-500" : last ? "fill-accent-500/70" : "fill-foreground/25"} />
                {isBest && (
                  <text x={cellX(b) + C + 2} y={tlTop + 23 + j * 12} className="fill-emerald-600" fontSize={9} fontWeight={700}>best {b - a + 1}</text>
                )}
              </g>
            )
          })}
        </g>
      )}
    </svg>
  )
}

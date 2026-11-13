// PROTOTYPE (throwaway, branch prototype/walkthrough-structure-views): what should a Walkthrough look
// like when it draws data structures and moves? This file re-runs the two pilot problems' approaches
// in TypeScript and emits steps; the three variants only draw them.

export type Lang = "en" | "ko"
export type Kind = "count" | "window"

export interface Move {
  /** array index the value comes from or goes back to */
  index: number
  key: string
  /** in: array → map (+1). out: map → array (−1) */
  dir: "in" | "out"
}

export interface Step {
  en: string
  ko: string
  /** 1-based line in `code` */
  line: number
  cursor: number | null
  left: number | null
  /** the window [left, right], or null when there is none */
  bracket: [number, number] | null
  best: number
  bestRange: [number, number] | null
  bestNew: boolean
  map: { key: string; count: number }[]
  hot: string | null
  hotKind: "add" | "inc" | "dec" | "del" | null
  move: Move | null
  /** every move so far, oldest first, `move` last */
  history: Move[]
  /** windows the run has passed through (window problem) */
  windows: [number, number][]
  overflow: boolean
  ranked: string[] | null
  output: string[]
  outMove: string[]
  done: boolean
  answer: string | null
  /** variable values for the memory view */
  vars: { name: string; value: string; points?: number | null; changed?: boolean }[]
}

export interface RunModel {
  label: string
  input: string
  values: string[]
  k: number
  steps: Step[]
}

export const CODE: Record<Kind, string[]> = {
  count: [
    "def busiestMachines(checkIns, k):",
    "    uses = {}",
    "    for i, machine in enumerate(checkIns):",
    "        uses[machine] = uses.get(machine, 0) + 1",
    "    ranked = sorted(uses, key=lambda m: -uses[m])",
    "    return ranked[:k]",
  ],
  window: [
    "def k_distinct_window(queue, k):",
    "    window = Counter()",
    "    best = left = 0",
    "    for right, tag in enumerate(queue):",
    "        window[tag] += 1",
    "        while len(window) > k:",
    "            window[queue[left]] -= 1",
    "            if window[queue[left]] == 0:",
    "                del window[queue[left]]",
    "            left += 1",
    "        best = max(best, right - left + 1)",
    "    return best",
  ],
}

export const KIND: Record<string, Kind> = {
  "top-espresso-machines": "count",
  "unique-genre-window": "window",
}

export const NAMES: Record<Kind, { array: string; map: string; cursor: string; out: string }> = {
  count: { array: "checkIns", map: "uses", cursor: "i", out: "whiteboard" },
  window: { array: "queue", map: "window", cursor: "right", out: "best" },
}

function parseInput(kind: Kind, input: string): { values: string[]; k: number } {
  const k = Number(/k\s*=\s*(-?\d+)/.exec(input)?.[1] ?? 0)
  if (kind === "count") {
    const list = /\[([^\]]*)\]/.exec(input)?.[1] ?? ""
    return { values: list.split(",").map((s) => s.trim()).filter(Boolean), k }
  }
  const q = /"([^"]*)"/.exec(input)?.[1] ?? ""
  return { values: q.split(""), k }
}

type Base = Omit<Step, "en" | "ko" | "line">

function blank(): Base {
  return {
    cursor: null, left: null, bracket: null, best: 0, bestRange: null, bestNew: false,
    map: [], hot: null, hotKind: null, move: null, history: [], windows: [], overflow: false,
    ranked: null, output: [], outMove: [], done: false, answer: null, vars: [],
  }
}

function countRun(values: string[], k: number): Step[] {
  const steps: Step[] = []
  const map: { key: string; count: number }[] = []
  const history: Move[] = []
  const n = values.length
  steps.push({
    ...blank(), line: 2,
    vars: [{ name: "k", value: String(k) }, { name: "i", value: "–" }],
    en: `Walk the ${n} check-ins once, tallying each machine in the map uses; then take the ${k} busiest.`,
    ko: `체크인 ${n}개를 한 번 훑으며 머신마다 사용 횟수를 맵 uses에 셉니다. 그다음 가장 많이 쓰인 ${k}대를 고릅니다.`,
  })
  values.forEach((m, i) => {
    let e = map.find((x) => x.key === m)
    const isNew = !e
    if (!e) { e = { key: m, count: 0 }; map.push(e) }
    e.count += 1
    const move: Move = { index: i, key: m, dir: "in" }
    history.push(move)
    steps.push({
      ...blank(), line: 4, cursor: i, map: map.map((x) => ({ ...x })), hot: m, hotKind: isNew ? "add" : "inc",
      move, history: [...history],
      vars: [{ name: "k", value: String(k) }, { name: "i", value: String(i), points: i, changed: true }, { name: "machine", value: m, changed: true }],
      en: isNew
        ? `checkIns[${i}] = ${m}: machine ${m} isn't in the map yet, so it goes in with 1.`
        : `checkIns[${i}] = ${m}: machine ${m} is already in the map, its count goes ${e.count - 1} → ${e.count}.`,
      ko: isNew
        ? `checkIns[${i}] = ${m}: 맵에 없는 머신이라 사용 횟수 1로 들어갑니다.`
        : `checkIns[${i}] = ${m}: 이미 맵에 있는 머신입니다. 사용 횟수: ${e.count - 1} → ${e.count}.`,
    })
  })
  // most_common keeps first-seen order among ties, as a stable sort does
  const ranked = [...map].sort((a, b) => b.count - a.count).map((x) => x.key)
  const list = ranked.map((key) => `${key} (${map.find((x) => x.key === key)!.count})`).join(", ")
  const finalMap = map.map((x) => ({ ...x }))
  steps.push({
    ...blank(), line: 5, map: finalMap, ranked, history: [...history],
    vars: [{ name: "k", value: String(k) }, { name: "ranked", value: `[${ranked.join(", ")}]`, changed: true }],
    en: `Every check-in is counted. Ranked by uses: ${list}.`,
    ko: `체크인을 모두 셌습니다. 사용 횟수 순으로 놓으면 ${list}입니다.`,
  })
  const out = ranked.slice(0, k)
  const ans = `[${out.join(",")}]`
  steps.push({
    ...blank(), line: 6, map: finalMap, ranked, output: out, outMove: out, done: true, answer: ans, history: [...history],
    vars: [{ name: "k", value: String(k) }, { name: "ranked", value: `[${ranked.join(", ")}]` }],
    en: `The first ${k} go on the whiteboard: answer ${ans}.`,
    ko: `앞의 ${k}대를 화이트보드에 적습니다. 답: ${ans}`,
  })
  return steps
}

function windowRun(values: string[], k: number): Step[] {
  const steps: Step[] = []
  const map: { key: string; count: number }[] = []
  const history: Move[] = []
  const windows: [number, number][] = []
  let best = 0
  let bestRange: [number, number] | null = null
  let left = 0
  const n = values.length
  const snap = () => map.map((x) => ({ ...x }))
  const vars = (right: number | null, changed: string[]) => [
    { name: "k", value: String(k) },
    { name: "left", value: right === null ? "0" : String(left), points: right === null ? null : left, changed: changed.includes("left") },
    { name: "right", value: right === null ? "–" : String(right), points: right, changed: changed.includes("right") },
    { name: "best", value: String(best), changed: changed.includes("best") },
  ]
  steps.push({
    ...blank(), line: 3, vars: vars(null, []),
    en: `${n} tags, at most k = ${k} genres in the window. The window starts empty.`,
    ko: `태그 ${n}개, 구간에는 장르가 최대 k = ${k}개까지 들어갑니다. 구간은 비어 있는 채로 시작합니다.`,
  })
  values.forEach((t, right) => {
    let e = map.find((x) => x.key === t)
    const isNew = !e
    if (!e) { e = { key: t, count: 0 }; map.push(e) }
    e.count += 1
    const move: Move = { index: right, key: t, dir: "in" }
    history.push(move)
    const overflow = map.length > k
    const settle = () => {
      const len = right - left + 1
      const beat = len > best
      if (beat) { best = len; bestRange = [left, right] }
      windows.push([left, right])
      return { len, beat }
    }
    if (!overflow) {
      const { len, beat } = settle()
      steps.push({
        ...blank(), line: 11, cursor: right, left, bracket: [left, right], best, bestRange, bestNew: beat,
        map: snap(), hot: t, hotKind: isNew ? "add" : "inc", move, history: [...history], windows: [...windows],
        vars: vars(right, beat ? ["right", "best"] : ["right"]),
        en: `queue[${right}] = '${t}' joins: ${map.length} genre${map.length > 1 ? "s" : ""}, within k. Window length ${len}${beat ? ", a new best" : `, best stays ${best}`}.`,
        ko: `queue[${right}] = '${t}' 추가: 장르 ${map.length}개로 k 이하입니다. 구간 길이 ${len}${beat ? ", 최장 기록 갱신" : `, best는 그대로 ${best}`}.`,
      })
      return
    }
    steps.push({
      ...blank(), line: 6, cursor: right, left, bracket: [left, right], best, bestRange,
      map: snap(), hot: t, hotKind: "add", move, history: [...history], windows: [...windows], overflow: true,
      vars: vars(right, ["right"]),
      en: `queue[${right}] = '${t}' joins: ${map.length} genres, more than k = ${k}. Drop tags from the left.`,
      ko: `queue[${right}] = '${t}' 추가: 장르가 ${map.length}개로 k = ${k}보다 많습니다. 왼쪽부터 뺍니다.`,
    })
    while (map.length > k) {
      const lt = values[left]
      const le = map.find((x) => x.key === lt)!
      le.count -= 1
      const gone = le.count === 0
      if (gone) map.splice(map.indexOf(le), 1)
      const out: Move = { index: left, key: lt, dir: "out" }
      history.push(out)
      const dropped = left
      left += 1
      const still = map.length > k
      const shown = gone ? [...snap(), { key: lt, count: 0 }] : snap()
      let tailEn = ""
      let tailKo = ""
      let beat = false
      if (!still) {
        const s = settle()
        beat = s.beat
        tailEn = ` Back to ${k} genres: window length ${s.len}, best ${best}.`
        tailKo = ` 장르가 다시 ${k}개: 구간 길이 ${s.len}, best ${best}.`
      }
      steps.push({
        ...blank(), line: still ? 10 : 11, cursor: right, left, bracket: [left, right], best, bestRange, bestNew: beat,
        map: shown, hot: lt, hotKind: gone ? "del" : "dec", move: out, history: [...history], windows: [...windows],
        overflow: still, vars: vars(right, ["left"]),
        en: `queue[${dropped}] = '${lt}' leaves: count of '${lt}' ${le.count + 1} → ${le.count}${gone ? `, so '${lt}' leaves the map` : ""}.${tailEn}`,
        ko: `queue[${dropped}] = '${lt}' 제거: '${lt}' 개수 ${le.count + 1} → ${le.count}${gone ? `, 맵에서 '${lt}' 삭제` : ""}.${tailKo}`,
      })
    }
  })
  const [a, b] = bestRange ?? [0, -1]
  steps.push({
    ...blank(), line: 12, left: null, bracket: bestRange, best, bestRange, map: snap(), history: [...history],
    windows: [...windows], done: true, answer: String(best), vars: vars(null, []),
    en: `Done. The longest window was queue[${a}..${b}], length ${best}: answer ${best}.`,
    ko: `끝. 가장 긴 구간은 queue[${a}..${b}], 길이 ${best}입니다. 답: ${best}`,
  })
  return steps
}

export function buildRun(kind: Kind, label: string, input: string): RunModel {
  const { values, k } = parseInput(kind, input)
  return { label, input, values, k, steps: kind === "count" ? countRun(values, k) : windowRun(values, k) }
}

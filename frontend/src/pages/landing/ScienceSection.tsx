import { Card, CardContent } from "@/components/ui/Card"

/* ── Mini SVG Charts ── */

function PlateauChart() {
  const bars = [
    { year: 1, height: 70 },
    { year: 2, height: 90 },
    { year: 3, height: 96 },
    { year: 4, height: 98 },
    { year: 5, height: 99 },
  ]

  return (
    <svg viewBox="0 0 200 110" className="w-full" fill="none">
      {/* Bars */}
      {bars.map((bar, i) => (
        <g key={bar.year}>
          <rect
            x={15 + i * 38}
            y={100 - bar.height}
            width="24"
            height={bar.height}
            rx="3"
            className={
              i < 2
                ? "fill-accent-500/80"
                : "fill-muted-foreground/20"
            }
          />
          <text
            x={27 + i * 38}
            y="108"
            className="fill-muted-foreground text-[8px]"
            textAnchor="middle"
          >
            Yr {bar.year}
          </text>
        </g>
      ))}

      {/* Plateau line */}
      <line
        x1="90"
        y1="6"
        x2="200"
        y2="3"
        className="stroke-destructive/50"
        strokeWidth="1"
        strokeDasharray="4 3"
      />
      <text x="200" y="10" className="fill-destructive/70 text-[7px]" textAnchor="end">
        plateau
      </text>
    </svg>
  )
}

function ForgettingCurveChart() {
  return (
    <svg viewBox="0 0 200 110" className="w-full" fill="none">
      {/* No review — steep decay */}
      <path
        d="M 10 15 C 30 40, 50 70, 80 85 C 110 95, 140 98, 190 100"
        className="stroke-muted-foreground/40"
        strokeWidth="2"
        strokeDasharray="4 3"
      />

      {/* With spaced repetition — sawtooth */}
      <path
        d="M 10 15 C 20 30, 30 50, 45 58 L 45 20 C 55 32, 65 48, 80 52 L 80 22 C 90 32, 100 42, 120 48 L 120 25 C 130 32, 145 40, 160 44 L 160 28 C 170 33, 180 37, 190 40"
        className="stroke-accent-500"
        strokeWidth="2"
      />

      {/* Labels */}
      <text x="190" y="98" className="fill-muted-foreground/60 text-[7px]" textAnchor="end">
        No review
      </text>
      <text x="190" y="38" className="fill-accent-500 text-[7px]" textAnchor="end">
        Spaced review
      </text>

      {/* Axis */}
      <text x="100" y="108" className="fill-muted-foreground text-[7px]" textAnchor="middle">
        Days after learning
      </text>
    </svg>
  )
}

function FeedbackChart() {
  return (
    <svg viewBox="0 0 200 110" className="w-full" fill="none">
      {/* Without feedback — gradual steps */}
      <path
        d="M 10 95 L 40 95 L 40 82 L 70 82 L 70 72 L 100 72 L 100 65 L 130 65 L 130 60 L 160 60 L 160 57 L 190 57"
        className="stroke-muted-foreground/40"
        strokeWidth="2"
        strokeDasharray="4 3"
      />

      {/* With feedback — steep steps */}
      <path
        d="M 10 95 L 40 95 L 40 72 L 70 72 L 70 52 L 100 52 L 100 36 L 130 36 L 130 24 L 160 24 L 160 15 L 190 15"
        className="stroke-accent-500"
        strokeWidth="2"
      />

      {/* Labels */}
      <text x="190" y="55" className="fill-muted-foreground/60 text-[7px]" textAnchor="end">
        Without feedback
      </text>
      <text x="190" y="12" className="fill-accent-500 text-[7px]" textAnchor="end">
        With feedback
      </text>

      {/* Axis */}
      <text x="100" y="108" className="fill-muted-foreground text-[7px]" textAnchor="middle">
        Practice sessions
      </text>
    </svg>
  )
}

/* ── Section Data ── */

const insights = [
  {
    stat: "Most developers plateau after 1–2 years",
    chart: PlateauChart,
    description:
      "Ericsson found that experience alone doesn't equal expertise. Without deliberate challenge, skills stagnate. CodeBite keeps you at your growth edge.",
    source: "Peak, Chapter 1",
  },
  {
    stat: "You forget 70% within 24 hours",
    chart: ForgettingCurveChart,
    description:
      "Without review, knowledge fades fast. Our spaced repetition engine resurfaces problems at optimal intervals — turning short-term solving into long-term mastery.",
    source: "Ebbinghaus, 1885 / Peak, Chapter 4",
  },
  {
    stat: "3.5× faster improvement with immediate feedback",
    chart: FeedbackChart,
    description:
      "Ericsson's research shows that immediate, targeted feedback is the single biggest accelerator of skill development. Every submission gives you instant, detailed results.",
    source: "Peak, Chapter 3",
  },
]

/* ── Component ── */

export function ScienceSection() {
  return (
    <section id="features" className="py-20 lg:py-28">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="mb-14 text-center">
          <h2 className="text-3xl font-bold tracking-tight text-foreground">
            The Science Behind CodeBite
          </h2>
          <p className="mt-3 max-w-2xl mx-auto text-muted-foreground">
            Every feature is grounded in decades of research on how humans
            actually develop expertise.
          </p>
        </div>

        <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
          {insights.map((insight, i) => (
            <Card
              key={insight.stat}
              className="animate-fade-up overflow-hidden border border-border transition-all duration-300 hover:-translate-y-0.5 hover:border-accent-500/50 hover:shadow-md"
              style={{ animationDelay: `${i * 150}ms` }}
            >
              <CardContent className="p-6">
                <p className="text-xl font-bold text-accent-500">
                  {insight.stat}
                </p>

                <div className="my-4 rounded-lg bg-muted/50 p-3">
                  <insight.chart />
                </div>

                <p className="text-sm leading-relaxed text-muted-foreground">
                  {insight.description}
                </p>

                <p className="mt-3 text-[11px] italic text-muted-foreground/60">
                  {insight.source}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  )
}

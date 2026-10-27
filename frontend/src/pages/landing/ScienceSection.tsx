import { useTranslation } from "react-i18next"
import { Card, CardContent } from "@/components/ui/Card"

/* ── Mini SVG Charts ── */

function PlateauChart({ label }: { label: string }) {
  const { t } = useTranslation("landing")
  const bars = [
    { year: 1, height: 70 },
    { year: 2, height: 90 },
    { year: 3, height: 96 },
    { year: 4, height: 98 },
    { year: 5, height: 99 },
  ]

  return (
    <svg viewBox="0 0 200 122" className="w-full" fill="none" role="img" aria-label={label}>
      {/* Bars */}
      {bars.map((bar, i) => (
        <g key={bar.year}>
          <rect
            x={15 + i * 38}
            y={100 - bar.height * 0.82}
            width="24"
            height={bar.height * 0.82}
            rx="3"
            className={
              i < 2
                ? "fill-accent-500/80"
                : "fill-muted-foreground/20"
            }
          />
          <text
            x={27 + i * 38}
            y="115"
            className="fill-muted-foreground text-[11px]"
            textAnchor="middle"
          >
            {t("science.year", { n: bar.year })}
          </text>
        </g>
      ))}

      {/* Plateau line */}
      <line
        x1="90"
        y1="21"
        x2="200"
        y2="18"
        className="stroke-muted-foreground/60"
        strokeWidth="1"
        strokeDasharray="4 3"
      />
      <text x="200" y="12" className="fill-muted-foreground text-[11px]" textAnchor="end">
        {t("science.plateau.label")}
      </text>
    </svg>
  )
}

function ForgettingCurveChart({ label }: { label: string }) {
  const { t } = useTranslation("landing")
  return (
    <svg viewBox="0 0 200 122" className="w-full" fill="none" role="img" aria-label={label}>
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
      <text x="190" y="89" className="fill-muted-foreground text-[11px]" textAnchor="end">
        {t("science.forgetting.noReview")}
      </text>
      <text x="190" y="14" className="fill-accent-700 dark:fill-accent-400 text-[11px]" textAnchor="end">
        {t("science.forgetting.spacedReview")}
      </text>

      {/* Axis */}
      <text x="100" y="117" className="fill-muted-foreground text-[11px]" textAnchor="middle">
        {t("science.forgetting.daysAfter")}
      </text>
    </svg>
  )
}

function FeedbackChart({ label }: { label: string }) {
  const { t } = useTranslation("landing")
  return (
    <svg viewBox="0 0 200 122" className="w-full" fill="none" role="img" aria-label={label}>
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
      <text x="190" y="84" className="fill-muted-foreground text-[11px]" textAnchor="end">
        {t("science.feedback.withoutFeedback")}
      </text>
      <text x="190" y="10" className="fill-accent-700 dark:fill-accent-400 text-[11px]" textAnchor="end">
        {t("science.feedback.withFeedback")}
      </text>

      {/* Axis */}
      <text x="100" y="117" className="fill-muted-foreground text-[11px]" textAnchor="middle">
        {t("science.feedback.sessions")}
      </text>
    </svg>
  )
}

/* ── Component ── */

export function ScienceSection() {
  const { t } = useTranslation("landing")

  const insights = [
    {
      key: "plateau",
      stat: t("science.plateau.title"),
      chart: PlateauChart,
      description: t("science.plateau.description"),
      source: t("science.plateau.source"),
    },
    {
      key: "forgetting",
      stat: t("science.forgetting.title"),
      chart: ForgettingCurveChart,
      description: t("science.forgetting.description"),
      source: t("science.forgetting.source"),
    },
    {
      key: "feedback",
      stat: t("science.feedback.title"),
      chart: FeedbackChart,
      description: t("science.feedback.description"),
      source: t("science.feedback.source"),
    },
  ]

  return (
    <section id="features" className="py-20 lg:py-28">
      <div className="mx-auto max-w-6xl px-4 sm:px-6">
        <div className="mb-14 text-center">
          <h2 className="text-3xl font-bold tracking-tight text-foreground">
            {t("science.title")}
          </h2>
          <p className="mt-3 max-w-2xl mx-auto text-muted-foreground">
            {t("science.subtitle")}
          </p>
        </div>

        {/* Three across only from lg: at md the charts would shrink their labels below 12px. */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
          {insights.map((insight, i) => (
            <Card
              key={insight.key}
              className="animate-fade-up overflow-hidden border border-border"
              style={{ animationDelay: `${i * 150}ms` }}
            >
              <CardContent className="p-6">
                <h3 className="text-xl font-bold text-accent-700 dark:text-accent-400">
                  {insight.stat}
                </h3>

                <div className="mx-auto my-4 max-w-sm rounded-lg bg-muted/50 p-3 lg:max-w-none">
                  <insight.chart label={t("science.chartLabel", { title: insight.stat })} />
                </div>

                <p className="text-sm leading-relaxed text-muted-foreground">
                  {insight.description}
                </p>

                <p className="mt-3 text-xs italic text-muted-foreground">
                  {insight.source}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
        <p className="mt-6 text-center text-xs text-muted-foreground">{t("science.illustrative")}</p>
      </div>
    </section>
  )
}

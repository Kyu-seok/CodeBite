import { useTranslation } from "react-i18next"
import { Button } from "@/components/ui/Button"
import { useStartTutorial } from "@/hooks/useTutorial"
import { Badge } from "@/components/ui/Badge"

function GrowthChart() {
  const { t } = useTranslation("landing")
  return (
    <svg role="img" aria-label={t("hero.chart.summary")}
      viewBox="0 0 420 220"
      className="w-full max-w-lg"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
    >
      {/* Grid lines */}
      {[40, 80, 120, 160].map((y) => (
        <line
          key={y}
          x1="40"
          y1={y}
          x2="400"
          y2={y}
          className="stroke-border"
          strokeWidth="0.5"
        />
      ))}

      {/* Axes */}
      <line x1="40" y1="20" x2="40" y2="190" className="stroke-muted-foreground/40" strokeWidth="1" />
      <line x1="40" y1="190" x2="400" y2="190" className="stroke-muted-foreground/40" strokeWidth="1" />

      {/* Random Practice curve — plateaus */}
      <path
        d="M 40 185 C 80 170, 120 140, 160 120 C 200 105, 240 98, 280 95 C 320 93, 360 92, 400 92"
        className="stroke-muted-foreground/60"
        strokeWidth="2"
        strokeDasharray="6 4"
        fill="none"
      />

      {/* Deliberate Practice curve — keeps climbing */}
      <path
        d="M 40 185 C 80 165, 120 130, 160 105 C 200 80, 240 60, 280 45 C 320 35, 360 28, 400 24"
        className="animate-draw stroke-accent-500"
        strokeWidth="2.5"
        fill="none"
        style={{ animationDelay: "0.3s" }}
      />

      {/* Labels */}
      <text x="395" y="108" className="fill-muted-foreground text-[12px]" textAnchor="end">
        {t("hero.chart.random")}
      </text>
      <text x="395" y="16" className="fill-accent-700 dark:fill-accent-400 text-[12px] font-medium" textAnchor="end">
        {t("hero.chart.deliberate")}
      </text>

      {/* Axis labels */}
      <text x="220" y="210" className="fill-muted-foreground text-[12px]" textAnchor="middle">
        {t("hero.chart.time")}
      </text>
      <text
        x="12"
        y="105"
        className="fill-muted-foreground text-[12px]"
        textAnchor="middle"
        transform="rotate(-90, 12, 105)"
      >
        {t("hero.chart.skill")}
      </text>
    </svg>
  )
}

export function HeroSection() {
  const { t } = useTranslation("landing")
  // The main call to action starts the Tutorial on the Tutorial Problem.
  const startTutorial = useStartTutorial()
  return (
    <section className="relative overflow-hidden">
      <div className="absolute inset-0 bg-gradient-to-b from-accent-50/50 via-accent-50/20 to-transparent dark:from-accent-950/20 dark:via-accent-950/10 dark:to-transparent" />

      <div className="relative mx-auto max-w-5xl px-4 py-20 sm:px-6 lg:py-28">
        <div className="grid items-center gap-12 lg:grid-cols-2 lg:gap-16">
          {/* Left — Copy */}
          <div className="text-center lg:text-left">
            <div className="animate-fade-up">
              <Badge variant="accent" className="mb-6 text-accent-800 dark:text-accent-400">
                {t("hero.badge")}
              </Badge>
            </div>

            <h1
              className="animate-fade-up text-4xl font-bold tracking-tight text-foreground sm:text-5xl"
              style={{ animationDelay: "100ms" }}
            >
              {t("hero.headingPrefix")}{" "}
              <span className="text-accent-700 dark:text-accent-400">{t("hero.headingHighlight")}</span>
            </h1>

            <p
              className="animate-fade-up mt-6 max-w-xl text-lg leading-relaxed text-muted-foreground"
              style={{ animationDelay: "200ms" }}
            >
              {t("hero.description")}
            </p>

            <div
              className="animate-fade-up mt-8 flex flex-col items-center gap-3 sm:flex-row lg:items-start"
              style={{ animationDelay: "300ms" }}
            >
              <Button variant="accent" size="lg" onClick={startTutorial}>
                {t("hero.solveFirstProblem")}
              </Button>
              <Button
                variant="outline"
                size="lg"
                onClick={() =>
                  document
                    .getElementById("method")
                    ?.scrollIntoView({
                      behavior: matchMedia("(prefers-reduced-motion: reduce)").matches ? "auto" : "smooth",
                    })
                }
              >
                {t("hero.seeMethod")}
              </Button>
            </div>
          </div>

          {/* Right — Chart */}
          <div
            className="animate-fade-up flex justify-center"
            style={{ animationDelay: "400ms" }}
          >
            <div className="w-full rounded-xl border border-border bg-card p-4 shadow-sm sm:p-6">
              <p className="mb-3 text-xs font-medium uppercase tracking-wider text-muted-foreground">
                {t("hero.chartLabel")}
              </p>
              <GrowthChart />
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

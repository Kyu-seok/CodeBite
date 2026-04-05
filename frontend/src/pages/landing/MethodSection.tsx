import { useTranslation } from "react-i18next"
import { Card, CardContent } from "@/components/ui/Card"

function XIcon() {
  return (
    <svg
      width="16"
      height="16"
      viewBox="0 0 16 16"
      fill="none"
      className="shrink-0"
    >
      <circle cx="8" cy="8" r="8" className="fill-destructive/15" />
      <path
        d="M5.5 5.5l5 5M10.5 5.5l-5 5"
        className="stroke-destructive"
        strokeWidth="1.5"
        strokeLinecap="round"
      />
    </svg>
  )
}

function CheckIcon() {
  return (
    <svg
      width="16"
      height="16"
      viewBox="0 0 16 16"
      fill="none"
      className="shrink-0"
    >
      <circle cx="8" cy="8" r="8" className="fill-accent-500/15" />
      <path
        d="M5 8.5l2 2 4-4.5"
        className="stroke-accent-500"
        strokeWidth="1.5"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
    </svg>
  )
}

export function MethodSection() {
  const { t } = useTranslation("landing")
  const naivePoints = t("method.naivePoints", { returnObjects: true }) as string[]
  const codebitePoints = t("method.codebitePoints", { returnObjects: true }) as string[]
  return (
    <section id="method" className="py-20 lg:py-28 bg-muted/30">
      <div className="mx-auto max-w-5xl px-4 sm:px-6">
        <div className="mb-14 text-center">
          <h2 className="text-3xl font-bold tracking-tight text-foreground">
            {t("method.title")}
          </h2>
          <p className="mt-3 max-w-2xl mx-auto text-muted-foreground">
            {t("method.subtitle")}
          </p>
        </div>

        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          {/* Anti-pattern */}
          <Card className="animate-fade-up border-border/50">
            <CardContent className="p-6">
              <p className="mb-5 text-lg font-semibold text-muted-foreground">
                {t("method.naive")}
              </p>
              <ul className="space-y-3">
                {naivePoints.map((item) => (
                  <li
                    key={item}
                    className="flex items-start gap-3 text-sm text-muted-foreground/70"
                  >
                    <XIcon />
                    <span className="line-through decoration-muted-foreground/30">
                      {item}
                    </span>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>

          {/* Deliberate practice */}
          <Card className="animate-fade-up border-accent-500/30 shadow-md" style={{ animationDelay: "150ms" }}>
            <CardContent className="p-6">
              <p className="mb-5 text-lg font-semibold text-accent-500">
                {t("method.codebite")}
              </p>
              <ul className="space-y-3">
                {codebitePoints.map((item) => (
                  <li
                    key={item}
                    className="flex items-start gap-3 text-sm text-foreground"
                  >
                    <CheckIcon />
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  )
}

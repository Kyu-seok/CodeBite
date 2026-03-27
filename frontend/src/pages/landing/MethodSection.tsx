import { Card, CardContent } from "@/components/ui/Card"

const antiPatterns = [
  "Pick random problems from a list",
  "Solve easy ones to feel productive",
  "Never revisit solved problems",
  "No structure, no feedback loop",
  "Hit a plateau and give up",
]

const deliberatePatterns = [
  "Follow a structured difficulty progression",
  "Work at the edge of your ability",
  "Get immediate feedback on every attempt",
  "Revisit problems with spaced repetition",
  "Continuously target weak areas",
]

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
  return (
    <section id="method" className="py-20 lg:py-28 bg-muted/30">
      <div className="mx-auto max-w-5xl px-4 sm:px-6">
        <div className="mb-14 text-center">
          <h2 className="text-3xl font-bold tracking-tight text-foreground">
            Two Ways to Practice
          </h2>
          <p className="mt-3 max-w-2xl mx-auto text-muted-foreground">
            Most people default to the left. Experts choose the right.
          </p>
        </div>

        <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
          {/* Anti-pattern */}
          <Card className="animate-fade-up border-border/50">
            <CardContent className="p-6">
              <p className="mb-5 text-lg font-semibold text-muted-foreground">
                How most people practice
              </p>
              <ul className="space-y-3">
                {antiPatterns.map((item) => (
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
                The CodeBite Method
              </p>
              <ul className="space-y-3">
                {deliberatePatterns.map((item) => (
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

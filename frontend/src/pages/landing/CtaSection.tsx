import { Link } from "react-router-dom"
import { buttonVariants } from "@/components/ui/Button"

export function CtaSection() {
  return (
    <section className="py-20 lg:py-28">
      <div className="mx-auto max-w-3xl px-4 text-center sm:px-6">
        <p className="mx-auto max-w-2xl text-sm leading-relaxed text-muted-foreground italic">
          "Ericsson's research across chess, music, and medicine found that{" "}
          <strong className="text-foreground not-italic">
            deliberate practice is the #1 predictor of elite performance
          </strong>
          {" "}— not talent, not years of experience."
        </p>
        <p className="mt-1 text-[11px] text-muted-foreground/50">
          — Peak: Secrets from the New Science of Expertise
        </p>

        <h2 className="mt-10 text-3xl font-bold tracking-tight text-foreground">
          Stop passive learning.
          <br />
          Start deliberate practice.
        </h2>
        <p className="mt-4 text-muted-foreground">
          Join developers building real problem-solving skills.
        </p>
        <div className="mt-8">
          <Link
            to="/problems"
            className={buttonVariants({ variant: "accent", size: "lg" })}
          >
            Start Solving
          </Link>
        </div>
      </div>
    </section>
  )
}

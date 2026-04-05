import { useTranslation } from "react-i18next"
import { Link } from "react-router-dom"
import { buttonVariants } from "@/components/ui/Button"

export function CtaSection() {
  const { t } = useTranslation("landing")
  return (
    <section className="py-20 lg:py-28">
      <div className="mx-auto max-w-3xl px-4 text-center sm:px-6">
        <p className="mx-auto max-w-2xl text-sm leading-relaxed text-muted-foreground italic">
          "{t("cta.quote").split(t("cta.quoteHighlight"))[0]}
          <strong className="text-foreground not-italic">
            {t("cta.quoteHighlight")}
          </strong>
          {t("cta.quote").split(t("cta.quoteHighlight"))[1]}"
        </p>
        <p className="mt-1 text-[11px] text-muted-foreground/50">
          {t("cta.source")}
        </p>

        <h2 className="mt-10 text-3xl font-bold tracking-tight text-foreground">
          {t("cta.heading")}
        </h2>
        <p className="mt-4 text-muted-foreground">
          {t("cta.subtitle")}
        </p>
        <div className="mt-8">
          <Link
            to="/problems"
            className={buttonVariants({ variant: "accent", size: "lg" })}
          >
            {t("cta.startSolving")}
          </Link>
        </div>
      </div>
    </section>
  )
}

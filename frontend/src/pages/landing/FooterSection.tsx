import { useTranslation } from "react-i18next"
import { Link } from "react-router-dom"

export function FooterSection() {
  const { t } = useTranslation("landing")
  return (
    <footer className="border-t border-border py-8">
      <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 px-4 sm:flex-row sm:px-6">
        <p className="text-sm text-muted-foreground">
          {t("footer.copyright", { year: new Date().getFullYear() })}
        </p>
        <div className="flex items-center gap-6 text-sm text-muted-foreground">
          <Link
            to="/problems"
            className="transition-colors hover:text-foreground"
          >
            {t("footer.problems")}
          </Link>
          <a
            href="https://github.com"
            target="_blank"
            rel="noopener noreferrer"
            className="transition-colors hover:text-foreground"
          >
            {t("footer.github")}
          </a>
        </div>
      </div>
    </footer>
  )
}

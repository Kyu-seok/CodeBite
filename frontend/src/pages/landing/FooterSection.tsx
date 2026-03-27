import { Link } from "react-router-dom"

export function FooterSection() {
  return (
    <footer className="border-t border-border py-8">
      <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 px-4 sm:flex-row sm:px-6">
        <p className="text-sm text-muted-foreground">
          &copy; {new Date().getFullYear()} CodeBite
        </p>
        <div className="flex items-center gap-6 text-sm text-muted-foreground">
          <Link
            to="/problems"
            className="transition-colors hover:text-foreground"
          >
            Problems
          </Link>
          <a
            href="https://github.com"
            target="_blank"
            rel="noopener noreferrer"
            className="transition-colors hover:text-foreground"
          >
            GitHub
          </a>
        </div>
      </div>
    </footer>
  )
}

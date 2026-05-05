import { cn } from "@/lib/utils"

const LANGUAGE_LABELS: Record<string, string> = {
  java: "Java",
  python: "Python",
  javascript: "JavaScript",
  cpp: "C++",
}

const LANGUAGE_COLORS: Record<string, string> = {
  java: "bg-warning-100 text-warning-700 dark:bg-warning-950 dark:text-warning-400",
  python: "bg-success-100 text-success-700 dark:bg-success-950 dark:text-success-400",
  javascript: "bg-accent-100 text-accent-700 dark:bg-accent-950 dark:text-accent-400",
  cpp: "bg-secondary text-secondary-foreground",
}

export const SUPPORTED_LANGUAGES = Object.keys(LANGUAGE_LABELS)

export function languageLabel(code: string) {
  return LANGUAGE_LABELS[code] ?? code
}

interface LanguagePillProps {
  code: string
  className?: string
}

export function LanguagePill({ code, className }: LanguagePillProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-md px-2 py-0.5 text-xs font-medium",
        LANGUAGE_COLORS[code] ?? "bg-secondary text-secondary-foreground",
        className,
      )}>
      {languageLabel(code)}
    </span>
  )
}

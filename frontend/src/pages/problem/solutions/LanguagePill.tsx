import { cn } from "@/lib/utils"
import { languageLabel } from "../submissionDisplay"

interface LanguagePillProps {
  code: string
  className?: string
}

// One neutral pill for every language: green, amber and red mean judging outcomes only.
export function LanguagePill({ code, className }: LanguagePillProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-md bg-secondary px-2 py-0.5 text-xs font-medium text-secondary-foreground",
        className,
      )}>
      {languageLabel(code)}
    </span>
  )
}

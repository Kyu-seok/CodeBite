import { forwardRef, type ComponentProps } from "react"
import { useTranslation } from "react-i18next"
import { cn } from "@/lib/utils"

function Pagination({ className, ...props }: ComponentProps<"nav">) {
  const { t } = useTranslation("common")
  return (
    <nav
      aria-label={t("pagination.label")}
      className={cn("mx-auto flex w-full justify-center", className)}
      {...props}
    />
  )
}

function PaginationContent({ className, ...props }: ComponentProps<"ul">) {
  return (
    <ul
      className={cn("flex flex-row items-center gap-1", className)}
      {...props}
    />
  )
}

function PaginationItem({ className, ...props }: ComponentProps<"li">) {
  return <li className={cn("", className)} {...props} />
}

interface PaginationButtonProps extends ComponentProps<"button"> {
  isActive?: boolean
}

const PaginationButton = forwardRef<HTMLButtonElement, PaginationButtonProps>(
  ({ className, isActive, ...props }, ref) => (
    <button
      ref={ref}
      type="button"
      aria-current={isActive ? "page" : undefined}
      className={cn(
        "inline-flex h-8 min-w-8 items-center justify-center rounded-md px-2.5 text-sm font-medium transition-colors",
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
        "disabled:pointer-events-none disabled:opacity-50",
        isActive
          ? // Readable Ember: the wash carries the colour, the 800 step the text (400 on night).
            "bg-accent-500/15 text-accent-800 dark:bg-accent-500/20 dark:text-accent-400"
          : "hover:bg-secondary text-muted-foreground hover:text-foreground",
        className,
      )}
      {...props}
    />
  ),
)
PaginationButton.displayName = "PaginationButton"

function PaginationPrevious({ className, ...props }: ComponentProps<typeof PaginationButton>) {
  const { t } = useTranslation("common")
  return (
    <PaginationButton className={cn("gap-1 pl-2", className)} {...props}>
      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
        <path d="m15 18-6-6 6-6" />
      </svg>
      <span>{t("button.previous")}</span>
    </PaginationButton>
  )
}

function PaginationNext({ className, ...props }: ComponentProps<typeof PaginationButton>) {
  const { t } = useTranslation("common")
  return (
    <PaginationButton className={cn("gap-1 pr-2", className)} {...props}>
      <span>{t("button.next")}</span>
      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
        <path d="m9 18 6-6-6-6" />
      </svg>
    </PaginationButton>
  )
}

function PaginationEllipsis({ className, ...props }: ComponentProps<"span">) {
  return (
    <span
      aria-hidden
      className={cn("flex h-8 w-8 items-center justify-center text-muted-foreground", className)}
      {...props}
    >
      &hellip;
    </span>
  )
}

export {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationButton,
  PaginationPrevious,
  PaginationNext,
  PaginationEllipsis,
}

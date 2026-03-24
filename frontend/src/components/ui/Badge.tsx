import { type HTMLAttributes } from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center rounded-md border px-2 py-0.5 text-xs font-medium transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  {
    variants: {
      variant: {
        default:
          "border-transparent bg-primary-800 text-primary-50 dark:bg-primary-50 dark:text-primary-800",
        secondary:
          "border-transparent bg-secondary text-secondary-foreground",
        outline:
          "border-border text-foreground",
        destructive:
          "border-transparent bg-error-100 text-error-700 dark:bg-error-950 dark:text-error-400",
        success:
          "border-transparent bg-success-100 text-success-700 dark:bg-success-950 dark:text-success-400",
        warning:
          "border-transparent bg-warning-100 text-warning-700 dark:bg-warning-950 dark:text-warning-400",
        accent:
          "border-transparent bg-accent-100 text-accent-700 dark:bg-accent-950 dark:text-accent-400",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

interface BadgeProps
  extends HTMLAttributes<HTMLSpanElement>,
    VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <span className={cn(badgeVariants({ variant, className }))} {...props} />
  )
}

export { Badge, badgeVariants }
export type { BadgeProps }

import { forwardRef, type HTMLAttributes } from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const pageLayoutVariants = cva("w-full", {
  variants: {
    variant: {
      /** Standard page with scrollable content and padding */
      default: "py-6",
      /** Full-height workspace that fills viewport below the navbar (no scroll on body) */
      workspace: "h-[calc(100vh-3.5rem)] overflow-hidden",
    },
  },
  defaultVariants: {
    variant: "default",
  },
})

interface PageLayoutProps
  extends HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof pageLayoutVariants> {}

const PageLayout = forwardRef<HTMLDivElement, PageLayoutProps>(
  ({ className, variant, ...props }, ref) => (
    <div
      ref={ref}
      className={cn(pageLayoutVariants({ variant, className }))}
      {...props}
    />
  )
)
PageLayout.displayName = "PageLayout"

export { PageLayout }
export type { PageLayoutProps }

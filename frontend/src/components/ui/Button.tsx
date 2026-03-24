import { forwardRef, type ButtonHTMLAttributes } from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default:
          "bg-primary-800 text-primary-50 hover:bg-primary-700 dark:bg-primary-50 dark:text-primary-800 dark:hover:bg-primary-200",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-neutral-200 dark:hover:bg-neutral-700",
        outline:
          "border border-border bg-transparent hover:bg-secondary hover:text-secondary-foreground",
        ghost:
          "hover:bg-secondary hover:text-secondary-foreground",
        destructive:
          "bg-error-500 text-white hover:bg-error-600 dark:bg-error-400 dark:text-error-950 dark:hover:bg-error-500",
        accent:
          "bg-accent-500 text-white hover:bg-accent-600 dark:hover:bg-accent-400",
        link:
          "text-accent-500 underline-offset-4 hover:underline",
      },
      size: {
        sm: "h-8 rounded-md px-3 text-xs",
        md: "h-9 rounded-md px-4 text-sm",
        lg: "h-10 rounded-lg px-6 text-sm",
        icon: "h-9 w-9 rounded-md",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "md",
    },
  }
)

interface ButtonProps
  extends ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <button
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
export type { ButtonProps }

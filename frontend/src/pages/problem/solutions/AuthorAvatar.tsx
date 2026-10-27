import { cn } from "@/lib/utils"

/** Author avatar beside a visible username, so the image itself is decorative. */
export function AuthorAvatar({
  avatarUrl,
  username,
  className,
}: {
  avatarUrl: string | null
  username: string
  className?: string
}) {
  if (avatarUrl) {
    return <img src={avatarUrl} alt="" className={cn("h-6 w-6 shrink-0 rounded-full", className)} />
  }
  return (
    <span
      aria-hidden="true"
      className={cn(
        "flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-accent-700 text-xs font-bold text-white",
        className,
      )}>
      {username.charAt(0).toUpperCase()}
    </span>
  )
}

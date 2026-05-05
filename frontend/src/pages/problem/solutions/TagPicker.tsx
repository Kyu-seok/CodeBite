import { useEffect, useState } from "react"
import { useTranslation } from "react-i18next"
import { X } from "lucide-react"
import { Button } from "@/components/ui/Button"
import { Badge } from "@/components/ui/Badge"
import client from "@/api/client"

interface TagOption {
  name: string
  slug: string
}

interface TagPickerProps {
  selected: string[]
  onChange: (next: string[]) => void
  max?: number
}

export function TagPicker({ selected, onChange, max = 5 }: TagPickerProps) {
  const { t } = useTranslation("problem")
  const [all, setAll] = useState<TagOption[]>([])
  const [filter, setFilter] = useState("")
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    let cancelled = false
    client
      .get<TagOption[]>("/tags")
      .then((res) => {
        if (!cancelled) {
          setAll(res.data)
          setLoaded(true)
        }
      })
      .catch(() => {
        if (!cancelled) setLoaded(true)
      })
    return () => {
      cancelled = true
    }
  }, [])

  const remove = (slug: string) => onChange(selected.filter((s) => s !== slug))

  const add = (slug: string) => {
    if (selected.includes(slug) || selected.length >= max) return
    onChange([...selected, slug])
  }

  const selectedNames = selected
    .map((slug) => all.find((t) => t.slug === slug))
    .filter((t): t is TagOption => Boolean(t))

  const visible = all
    .filter((t) => !selected.includes(t.slug))
    .filter(
      (t) =>
        !filter ||
        t.name.toLowerCase().includes(filter.toLowerCase()) ||
        t.slug.toLowerCase().includes(filter.toLowerCase()),
    )
    .slice(0, 12)

  return (
    <div>
      <div className="flex flex-wrap items-center gap-1.5 min-h-[1.5rem]">
        {selectedNames.map((tag) => (
          <Badge key={tag.slug} variant="secondary" className="gap-1">
            {tag.name}
            <button
              type="button"
              onClick={() => remove(tag.slug)}
              aria-label={`Remove ${tag.name}`}
              className="hover:text-destructive">
              <X className="h-3 w-3" />
            </button>
          </Badge>
        ))}
        {selected.length === 0 && (
          <span className="text-xs text-muted-foreground">
            {t("solutions.editor.tagsEmpty")}
          </span>
        )}
      </div>
      <div className="mt-2">
        <input
          type="text"
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          placeholder={t("solutions.editor.tagsSearch")}
          disabled={selected.length >= max}
          className="w-full rounded-md border border-border bg-background px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-ring disabled:opacity-50"
        />
        {loaded && visible.length > 0 && (
          <div className="mt-1 flex flex-wrap gap-1">
            {visible.map((tag) => (
              <Button
                key={tag.slug}
                type="button"
                variant="outline"
                size="sm"
                onClick={() => add(tag.slug)}
                disabled={selected.length >= max}>
                + {tag.name}
              </Button>
            ))}
          </div>
        )}
      </div>
      <p className="mt-1 text-xs text-muted-foreground">
        {selected.length}/{max}
      </p>
    </div>
  )
}

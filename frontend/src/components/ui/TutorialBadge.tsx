import { useTranslation } from "react-i18next"
import { Badge } from "@/components/ui/Badge"

/** The "Tutorial" label for the Tutorial Problem, shown wherever the backend marks a problem `tutorial`. */
export default function TutorialBadge() {
  const { t } = useTranslation("common")
  return <Badge variant="accent">{t("tutorialBadge")}</Badge>
}

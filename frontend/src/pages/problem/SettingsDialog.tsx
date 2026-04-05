import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogClose,
} from "@/components/ui/Dialog";
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from "@/components/ui/Select";
import { Switch } from "@/components/ui/Switch";
import { Button } from "@/components/ui/Button";
import { Tooltip, TooltipTrigger, TooltipContent } from "@/components/ui/Tooltip";
import { Settings } from "lucide-react";
import { useTranslation } from "react-i18next";
import { useEditorSettings } from "@/context/EditorSettingsContext";

const FONT_SIZES = [12, 14, 16, 18, 20];
const TAB_SIZES = [2, 4, 8];

export function SettingsDialog() {
  const { t } = useTranslation("problem");
  const { t: tc } = useTranslation("common");
  const { settings, updateSettings } = useEditorSettings();

  return (
    <Dialog>
      <Tooltip>
        <TooltipTrigger>
          <DialogTrigger asChild>
            <Button variant="ghost" size="icon" className="h-7 w-7">
              <Settings className="h-3.5 w-3.5" />
            </Button>
          </DialogTrigger>
        </TooltipTrigger>
        <TooltipContent>{t("settings.title")}</TooltipContent>
      </Tooltip>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle className="text-center">{t("settings.editorSettings")}</DialogTitle>
        </DialogHeader>

        <div className="mt-4 space-y-6">
          {/* Font Size */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">{t("settings.fontSize")}</p>
              <p className="text-xs text-muted-foreground">
                {t("settings.fontSizeDescription")}
              </p>
            </div>
            <Select
              value={String(settings.fontSize)}
              onValueChange={(v) => updateSettings({ fontSize: Number(v) })}
            >
              <SelectTrigger className="w-[120px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {FONT_SIZES.map((size) => (
                  <SelectItem key={size} value={String(size)}>
                    {size}px
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Tab Size */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">{t("settings.tabSize")}</p>
              <p className="text-xs text-muted-foreground">
                {t("settings.tabSizeDescription")}
              </p>
            </div>
            <Select
              value={String(settings.tabSize)}
              onValueChange={(v) => updateSettings({ tabSize: Number(v) })}
            >
              <SelectTrigger className="w-[120px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {TAB_SIZES.map((size) => (
                  <SelectItem key={size} value={String(size)}>
                    {t("settings.spaces", { n: size })}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Editor Key Bindings */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">{t("settings.keyBindings")}</p>
              <p className="text-xs text-muted-foreground">
                {t("settings.keyBindingsDescription")}
              </p>
            </div>
            <Select
              value={settings.keyBindings}
              onValueChange={(v) =>
                updateSettings({ keyBindings: v as "normal" | "vim" | "emacs" })
              }
            >
              <SelectTrigger className="w-[120px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="normal">{t("settings.normal")}</SelectItem>
                <SelectItem value="vim">Vim</SelectItem>
                <SelectItem value="emacs">Emacs</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* IntelliSense */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">{t("settings.intelliSense")}</p>
              <p className="text-xs text-muted-foreground">
                {t("settings.intelliSenseDescription")}
              </p>
            </div>
            <Switch
              checked={settings.intelliSense}
              onCheckedChange={(v) => updateSettings({ intelliSense: v })}
            />
          </div>
        </div>

        <DialogFooter className="mt-6">
          <DialogClose asChild>
            <Button variant="outline">{tc("button.close")}</Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

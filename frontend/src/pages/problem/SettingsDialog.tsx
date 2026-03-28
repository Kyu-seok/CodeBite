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
import { useEditorSettings } from "@/context/EditorSettingsContext";

const FONT_SIZES = [12, 14, 16, 18, 20];
const TAB_SIZES = [2, 4, 8];

export function SettingsDialog() {
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
        <TooltipContent>Settings</TooltipContent>
      </Tooltip>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle className="text-center">Editor Settings</DialogTitle>
        </DialogHeader>

        <div className="mt-4 space-y-6">
          {/* Font Size */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">Font Size</p>
              <p className="text-xs text-muted-foreground">
                Choose the font size of the editor.
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
              <p className="text-sm font-medium">Tab Size</p>
              <p className="text-xs text-muted-foreground">
                Update the default tab size of the editor.
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
                    {size} Spaces
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Editor Key Bindings */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">Editor Key Bindings</p>
              <p className="text-xs text-muted-foreground">
                Switch to Vim key bindings.
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
                <SelectItem value="normal">Normal</SelectItem>
                <SelectItem value="vim">Vim</SelectItem>
                <SelectItem value="emacs">Emacs</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* IntelliSense */}
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium">IntelliSense</p>
              <p className="text-xs text-muted-foreground">
                Type-aware completions, signature help, and error highlighting.
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
            <Button variant="outline">Close</Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

import { createContext, useContext, useRef, useState, type ReactNode } from "react";
import { updateEditorSettings as saveToBackend } from "@/api/user";

export interface EditorSettings {
  fontSize: number;
  tabSize: number;
  keyBindings: "normal" | "vim" | "emacs";
  intelliSense: boolean;
}

interface EditorSettingsContextType {
  settings: EditorSettings;
  updateSettings: (patch: Partial<EditorSettings>) => void;
  initFromUser: (editorSettings: string | null) => void;
}

const STORAGE_KEY = "editor-settings";

const DEFAULTS: EditorSettings = {
  fontSize: 14,
  tabSize: 4,
  keyBindings: "normal",
  intelliSense: true,
};

function loadSettings(): EditorSettings {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) return { ...DEFAULTS, ...JSON.parse(stored) };
  } catch {
    // ignore
  }
  return DEFAULTS;
}

function parseSettings(json: string | null): EditorSettings | null {
  if (!json) return null;
  try {
    return { ...DEFAULTS, ...JSON.parse(json) };
  } catch {
    return null;
  }
}

const EditorSettingsContext = createContext<EditorSettingsContextType | undefined>(undefined);

export function EditorSettingsProvider({ children }: { children: ReactNode }) {
  const [settings, setSettings] = useState<EditorSettings>(loadSettings);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const isAuthenticatedRef = useRef(false);

  const syncToBackend = (next: EditorSettings) => {
    if (!isAuthenticatedRef.current) return;
    if (debounceRef.current) clearTimeout(debounceRef.current);
    debounceRef.current = setTimeout(() => {
      saveToBackend(JSON.stringify(next)).catch(() => {});
    }, 1000);
  };

  const updateSettings = (patch: Partial<EditorSettings>) => {
    setSettings((prev) => {
      const next = { ...prev, ...patch };
      localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
      syncToBackend(next);
      return next;
    });
  };

  const initFromUser = (editorSettings: string | null) => {
    isAuthenticatedRef.current = true;
    const parsed = parseSettings(editorSettings);
    if (parsed) {
      setSettings(parsed);
      localStorage.setItem(STORAGE_KEY, JSON.stringify(parsed));
    }
  };

  return (
    <EditorSettingsContext.Provider value={{ settings, updateSettings, initFromUser }}>
      {children}
    </EditorSettingsContext.Provider>
  );
}

export function useEditorSettings() {
  const context = useContext(EditorSettingsContext);
  if (!context) throw new Error("useEditorSettings must be used within EditorSettingsProvider");
  return context;
}

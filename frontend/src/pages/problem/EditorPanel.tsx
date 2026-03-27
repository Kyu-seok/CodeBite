import { useRef, useEffect, useState } from 'react';
import Editor from '@monaco-editor/react';
import type { editor as monacoEditor } from 'monaco-editor';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/Tabs';
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectGroup,
  SelectLabel,
  SelectItem,
} from '@/components/ui/Select';
import { Button } from '@/components/ui/Button';
import Spinner from '@/components/ui/Spinner';
import { useTheme } from '@/context/ThemeContext';
import { useEditorSettings } from '@/context/EditorSettingsContext';
import { SettingsDialog } from './SettingsDialog';
import {
  StickyNote,
  Bug,
  RotateCcw,
  Columns2,
} from 'lucide-react';

function CodeIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round">
      <polyline points="16 18 22 12 16 6" />
      <polyline points="8 6 2 12 8 18" />
    </svg>
  );
}

const LANGUAGE_MAP: Record<string, string> = {
  java: 'java',
  python: 'python',
  javascript: 'javascript',
  cpp: 'cpp',
  c: 'c',
};

const LANGUAGE_LABELS: Record<string, string> = {
  java: 'Java',
  python: 'Python',
  javascript: 'JavaScript',
  cpp: 'C++',
  c: 'C',
};

interface EditorPanelProps {
  languages: string[];
  activeLanguage: string;
  code: string;
  onLanguageChange: (lang: string) => void;
  onCodeChange: (value: string | undefined) => void;
  onResetCode?: () => void;
  onResetLayout?: () => void;
}

export function EditorPanel({
  languages,
  activeLanguage,
  code,
  onLanguageChange,
  onCodeChange,
  onResetCode,
  onResetLayout,
}: EditorPanelProps) {
  const { theme } = useTheme();
  const { settings } = useEditorSettings();
  const editorRef = useRef<monacoEditor.IStandaloneCodeEditor | null>(null);
  const modeRef = useRef<{ dispose: () => void } | null>(null);
  const statusBarRef = useRef<HTMLDivElement | null>(null);
  const [editorMounted, setEditorMounted] = useState(false);

  const handleMount = (editor: monacoEditor.IStandaloneCodeEditor) => {
    editorRef.current = editor;
    setEditorMounted(true);
  };

  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) return;

    modeRef.current?.dispose();
    modeRef.current = null;

    if (settings.keyBindings === 'vim') {
      import('monaco-vim').then(({ initVimMode }) => {
        if (editorRef.current === editor) {
          modeRef.current = initVimMode(editor, statusBarRef.current);
        }
      });
    } else if (settings.keyBindings === 'emacs') {
      import('monaco-emacs').then(({ EmacsExtension }) => {
        if (editorRef.current === editor) {
          const ext = new EmacsExtension(editor);
          ext.start();
          modeRef.current = ext;
        }
      });
    }

    return () => {
      modeRef.current?.dispose();
      modeRef.current = null;
    };
  }, [settings.keyBindings, editorMounted]);

  return (
    <div className="flex h-full flex-col">
      <Tabs defaultValue="code" className="flex h-full flex-col">
        <div className="flex items-center justify-between border-b border-border bg-muted">
          <div className="flex items-center gap-1">
            <TabsList>
              <TabsTrigger value="code" className="gap-1.5 cursor-default">
                <CodeIcon />
                Code
              </TabsTrigger>
            </TabsList>
            <Select value={activeLanguage} onValueChange={onLanguageChange}>
              <SelectTrigger className="w-[130px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectLabel>Languages</SelectLabel>
                  {languages.map((lang) => (
                    <SelectItem key={lang} value={lang}>
                      {LANGUAGE_LABELS[lang] || lang}
                    </SelectItem>
                  ))}
                </SelectGroup>
              </SelectContent>
            </Select>
          </div>
          <div className="flex items-center">
            <Button variant="ghost" size="icon" className="h-7 w-7" title="Notes">
              <StickyNote className="h-3.5 w-3.5" />
            </Button>
            <Button variant="ghost" size="icon" className="h-7 w-7" title="Report Bug">
              <Bug className="h-3.5 w-3.5" />
            </Button>
            <Button variant="ghost" size="icon" className="h-7 w-7" title="Reset Code" onClick={onResetCode}>
              <RotateCcw className="h-3.5 w-3.5" />
            </Button>
            <Button variant="ghost" size="icon" className="h-7 w-7" title="Reset Layout" onClick={onResetLayout}>
              <Columns2 className="h-3.5 w-3.5" />
            </Button>
            <SettingsDialog />
          </div>
        </div>

        <TabsContent value="code" className="mt-0 min-h-0 flex-1">
          <Editor
            height="100%"
            language={LANGUAGE_MAP[activeLanguage] || activeLanguage}
            value={code}
            onChange={onCodeChange}
            onMount={handleMount}
            theme={theme === 'dark' ? 'vs-dark' : 'light'}
            loading={<Spinner />}
            options={{
              minimap: { enabled: false },
              fontSize: settings.fontSize,
              tabSize: settings.tabSize,
              detectIndentation: false,
              scrollBeyondLastLine: false,
              padding: { top: 12 },
              quickSuggestions: settings.intelliSense,
              suggestOnTriggerCharacters: settings.intelliSense,
              parameterHints: { enabled: settings.intelliSense },
            }}
          />
        </TabsContent>
        {settings.keyBindings === 'vim' && (
          <div
            ref={statusBarRef}
            className="border-t border-border bg-muted px-3 py-0.5 text-xs font-mono text-muted-foreground"
          />
        )}
      </Tabs>
    </div>
  );
}

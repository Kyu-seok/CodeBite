import { useRef, useEffect, useState } from 'react';
import Editor from '@monaco-editor/react';
import type { editor as monacoEditor } from 'monaco-editor';
import { KeyMod, KeyCode } from 'monaco-editor';
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
import { Tooltip, TooltipTrigger, TooltipContent } from '@/components/ui/Tooltip';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
} from '@/components/ui/Dialog';
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

const BUG_CATEGORIES = [
  'Wrong test case',
  'Wrong expected output',
  'Description unclear',
  'Starter code issue',
  'Other',
];

function BugReportDialog({
  open,
  onClose,
}: {
  open: boolean;
  onClose: () => void;
}) {
  const [category, setCategory] = useState(BUG_CATEGORIES[0]);
  const [description, setDescription] = useState('');
  const [submitted, setSubmitted] = useState(false);

  useEffect(() => {
    if (open) {
      setCategory(BUG_CATEGORIES[0]);
      setDescription('');
      setSubmitted(false);
    }
  }, [open]);

  const handleSubmit = () => {
    // TODO: send bug report to backend
    setSubmitted(true);
    setTimeout(() => onClose(), 1500);
  };

  return (
    <Dialog open={open} onOpenChange={(isOpen) => { if (!isOpen) onClose(); }}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>Report a Bug</DialogTitle>
          <DialogDescription>
            Help us improve by reporting issues with this problem.
          </DialogDescription>
        </DialogHeader>
        {submitted ? (
          <div className="py-6 text-center">
            <div className="mx-auto mb-2 flex h-10 w-10 items-center justify-center rounded-full bg-success-500/10">
              <svg className="h-5 w-5 text-success-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20 6 9 17l-5-5" />
              </svg>
            </div>
            <p className="text-sm font-medium text-foreground">Thanks for your report!</p>
            <p className="mt-1 text-xs text-muted-foreground">We'll look into it.</p>
          </div>
        ) : (
          <>
            <div className="mt-2 space-y-4">
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">
                  Category
                </label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value)}
                  className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                >
                  {BUG_CATEGORIES.map((c) => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">
                  Description
                </label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  maxLength={1000}
                  rows={4}
                  placeholder="Describe the issue..."
                  className="w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                />
              </div>
            </div>
            <div className="mt-4 flex justify-end gap-2">
              <Button variant="outline" size="sm" onClick={onClose}>
                Cancel
              </Button>
              <Button
                size="sm"
                onClick={handleSubmit}
                disabled={!description.trim()}
              >
                Submit Report
              </Button>
            </div>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

interface EditorPanelProps {
  languages: string[];
  activeLanguage: string;
  code: string;
  onLanguageChange: (lang: string) => void;
  onCodeChange: (value: string | undefined) => void;
  onResetCode?: () => void;
  onResetLayout?: () => void;
  onRun?: () => void;
  onSubmit?: () => void;
}

export function EditorPanel({
  languages,
  activeLanguage,
  code,
  onLanguageChange,
  onCodeChange,
  onResetCode,
  onResetLayout,
  onRun,
  onSubmit,
}: EditorPanelProps) {
  const { theme } = useTheme();
  const { settings } = useEditorSettings();
  const editorRef = useRef<monacoEditor.IStandaloneCodeEditor | null>(null);
  const modeRef = useRef<{ dispose: () => void } | null>(null);
  const statusBarRef = useRef<HTMLDivElement | null>(null);
  const [editorMounted, setEditorMounted] = useState(false);
  const [bugReportOpen, setBugReportOpen] = useState(false);

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

  // Register Run/Submit keyboard shortcuts in Monaco
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) return;

    // Cmd/Ctrl + ' → Run
    editor.addAction({
      id: 'codebite-run',
      label: 'Run Code',
      keybindings: [KeyMod.CtrlCmd | KeyCode.Quote],
      run: () => onRun?.(),
    });

    // Cmd/Ctrl + Enter → Submit
    editor.addAction({
      id: 'codebite-submit',
      label: 'Submit Code',
      keybindings: [KeyMod.CtrlCmd | KeyCode.Enter],
      run: () => onSubmit?.(),
    });
  }, [editorMounted, onRun, onSubmit]);

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
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7">
                  <StickyNote className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Notes</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => setBugReportOpen(true)}>
                  <Bug className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Report Bug</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onResetCode}>
                  <RotateCcw className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Reset Code</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onResetLayout}>
                  <Columns2 className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Reset Layout</TooltipContent>
            </Tooltip>
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
      <BugReportDialog open={bugReportOpen} onClose={() => setBugReportOpen(false)} />
    </div>
  );
}

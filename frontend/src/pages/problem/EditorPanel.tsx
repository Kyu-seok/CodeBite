import { useRef, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import Editor from '@monaco-editor/react';
import { KeyMod, KeyCode, Range as MonacoRange, editor as monacoEditor } from 'monaco-editor';
import type { CodeError } from '@/types/submission';
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

const BUG_CATEGORY_KEYS = [
  'wrongTestCase',
  'wrongExpectedOutput',
  'descriptionUnclear',
  'starterCodeIssue',
  'other',
] as const;

type BugCategoryKey = typeof BUG_CATEGORY_KEYS[number];

function BugReportDialog({
  open,
  onClose,
}: {
  open: boolean;
  onClose: () => void;
}) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  const [category, setCategory] = useState<BugCategoryKey>(BUG_CATEGORY_KEYS[0]);
  const [description, setDescription] = useState('');
  const [submitted, setSubmitted] = useState(false);

  useEffect(() => {
    if (open) {
      setCategory(BUG_CATEGORY_KEYS[0]);
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
          <DialogTitle>{t('bugReport.title')}</DialogTitle>
          <DialogDescription>
            {t('bugReport.description')}
          </DialogDescription>
        </DialogHeader>
        {submitted ? (
          <div className="py-6 text-center">
            <div className="mx-auto mb-2 flex h-10 w-10 items-center justify-center rounded-full bg-success-500/10">
              <svg className="h-5 w-5 text-success-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M20 6 9 17l-5-5" />
              </svg>
            </div>
            <p className="text-sm font-medium text-foreground">{t('bugReport.thanks')}</p>
            <p className="mt-1 text-xs text-muted-foreground">{t('bugReport.willLookInto')}</p>
          </div>
        ) : (
          <>
            <div className="mt-2 space-y-4">
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">
                  {t('bugReport.category')}
                </label>
                <select
                  value={category}
                  onChange={(e) => setCategory(e.target.value as BugCategoryKey)}
                  className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                >
                  {BUG_CATEGORY_KEYS.map((c) => (
                    <option key={c} value={c}>{t(`bugReport.${c}`)}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="mb-1.5 block text-sm font-medium text-foreground">
                  {t('bugReport.descriptionLabel')}
                </label>
                <textarea
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  maxLength={1000}
                  rows={4}
                  placeholder={t('bugReport.placeholder')}
                  className="w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                />
              </div>
            </div>
            <div className="mt-4 flex justify-end gap-2">
              <Button variant="outline" size="sm" onClick={onClose}>
                {tc('button.cancel')}
              </Button>
              <Button
                size="sm"
                onClick={handleSubmit}
                disabled={!description.trim()}
              >
                {t('bugReport.submit')}
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
  errors?: CodeError[];
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
  errors,
  onLanguageChange,
  onCodeChange,
  onResetCode,
  onResetLayout,
  onRun,
  onSubmit,
}: EditorPanelProps) {
  const { t } = useTranslation('problem');
  const { theme } = useTheme();
  const { settings } = useEditorSettings();
  const editorRef = useRef<monacoEditor.IStandaloneCodeEditor | null>(null);
  const decorationsRef = useRef<string[]>([]);
  const modeRef = useRef<{ dispose: () => void } | null>(null);
  const statusBarRef = useRef<HTMLDivElement | null>(null);
  const onRunRef = useRef(onRun);
  const onSubmitRef = useRef(onSubmit);
  onRunRef.current = onRun;
  onSubmitRef.current = onSubmit;
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

  // Register Run/Submit keyboard shortcuts in Monaco.
  // Handlers are read through refs so prop identity changes don't
  // re-run this effect on every keystroke.
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) return;

    const runAction = editor.addAction({
      id: 'codebite-run',
      label: 'Run Code',
      keybindings: [KeyMod.CtrlCmd | KeyCode.Quote],
      run: () => onRunRef.current?.(),
    });

    const submitAction = editor.addAction({
      id: 'codebite-submit',
      label: 'Submit Code',
      keybindings: [KeyMod.CtrlCmd | KeyCode.Enter],
      run: () => onSubmitRef.current?.(),
    });

    return () => {
      runAction.dispose();
      submitAction.dispose();
    };
  }, [editorMounted]);

  // Paint Judge0 errors as red wavy underlines via deltaDecorations.
  // Decorations are rendered unconditionally by Monaco's view layer, unlike
  // setModelMarkers which is gated on the language service's worker state.
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor) return;
    const model = editor.getModel();
    if (!model) return;

    const decos = (errors ?? [])
      .filter((e) => e.inUserCode && e.line != null)
      .map((e) => {
        const line = e.line!;
        const lineContent = model.getLineContent(line);
        const lineLen = lineContent.length;
        const firstNonWs = lineContent.search(/\S/);
        // Underline from first non-whitespace char to end of line when the
        // column is unknown (Java/Python parsers capture only line). Otherwise
        // honor the column from the parser.
        const startCol = e.column ?? (firstNonWs >= 0 ? firstNonWs + 1 : 1);
        const endCol = e.endColumn ?? lineLen + 1;
        const isWarning = e.severity === 'WARNING';
        return {
          range: new MonacoRange(
            line,
            startCol,
            e.endLine ?? line,
            endCol,
          ),
          options: {
            inlineClassName: isWarning
              ? 'cb-editor-warning-squiggly'
              : 'cb-editor-error-squiggly',
            hoverMessage: { value: e.message },
            minimap: {
              position: monacoEditor.MinimapPosition.Inline,
              color: isWarning ? '#f59e0b' : '#ef4444',
            },
            overviewRuler: {
              position: monacoEditor.OverviewRulerLane.Right,
              color: isWarning ? '#f59e0b' : '#ef4444',
            },
          },
        };
      });

    decorationsRef.current = editor.deltaDecorations(decorationsRef.current, decos);

    let changeSub: { dispose: () => void } | null = null;
    if (decos.length > 0) {
      changeSub = model.onDidChangeContent(() => {
        decorationsRef.current = editor.deltaDecorations(decorationsRef.current, []);
        changeSub?.dispose();
        changeSub = null;
      });
    }

    return () => {
      changeSub?.dispose();
      decorationsRef.current = editor.deltaDecorations(decorationsRef.current, []);
    };
  }, [errors, activeLanguage, editorMounted]);

  return (
    <div className="flex h-full flex-col">
      <Tabs defaultValue="code" className="flex h-full flex-col">
        <div className="flex items-center justify-between border-b border-border bg-muted">
          <div className="flex items-center gap-1">
            <TabsList>
              <TabsTrigger value="code" className="gap-1.5 cursor-default">
                <CodeIcon />
                {t('editor.code')}
              </TabsTrigger>
            </TabsList>
            <Select value={activeLanguage} onValueChange={onLanguageChange}>
              <SelectTrigger className="w-[130px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectGroup>
                  <SelectLabel>{t('editor.languages')}</SelectLabel>
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
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => setBugReportOpen(true)}>
                  <Bug className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>{t('editor.reportBug')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onResetCode}>
                  <RotateCcw className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>{t('editor.resetCode')}</TooltipContent>
            </Tooltip>
            <Tooltip>
              <TooltipTrigger>
                <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onResetLayout}>
                  <Columns2 className="h-3.5 w-3.5" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>{t('editor.resetLayout')}</TooltipContent>
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

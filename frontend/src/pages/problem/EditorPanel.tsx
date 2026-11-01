import { useRef, useEffect, useState, type ReactNode } from 'react';
import { useTranslation } from 'react-i18next';
import Editor from '@monaco-editor/react';
import { KeyMod, KeyCode, Range as MonacoRange, editor as monacoEditor } from 'monaco-editor';
import type { CodeError } from '@/types/submission';
import type { LineRange } from '@/onboarding';
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
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
} from '@/components/ui/DropdownMenu';
import Spinner from '@/components/ui/Spinner';
import { useTheme } from '@/context/ThemeContext';
import { useEditorSettings } from '@/context/EditorSettingsContext';
import { SettingsDialog } from './SettingsDialog';
import { ProblemReportDialog } from './ProblemReportDialog';
import { MONACO_LANGUAGE, languageLabel } from './submissionDisplay';
import {
  Bug,
  RotateCcw,
  Columns2,
  PanelBottomOpen,
  PanelBottomClose,
  Maximize2,
  Minimize2,
  Ellipsis,
} from 'lucide-react';

/** An icon-only toolbar button: its tooltip and accessible name are the same label. */
function ToolbarButton({
  label,
  onClick,
  children,
}: {
  label: string;
  onClick?: () => void;
  children: ReactNode;
}) {
  return (
    <Tooltip>
      <TooltipTrigger>
        <Button variant="ghost" size="icon" className="h-7 w-7" onClick={onClick} aria-label={label}>
          {children}
        </Button>
      </TooltipTrigger>
      <TooltipContent>{label}</TooltipContent>
    </Tooltip>
  );
}

function ToolbarDivider() {
  return <div aria-hidden className="mx-1 h-4 w-px bg-muted-foreground/30" />;
}

interface EditorPanelProps {
  problemSlug: string;
  languages: string[];
  activeLanguage: string;
  code: string;
  errors?: CodeError[];
  /** Lines (1-based, inclusive) the Tutorial marks as where the answer goes; null for none. */
  markedLines?: LineRange | null;
  onLanguageChange: (lang: string) => void;
  onCodeChange: (value: string | undefined) => void;
  onResetCode?: () => void;
  onResetLayout?: () => void;
  onRun?: () => void;
  onSubmit?: () => void;
  onToggleTests?: () => void;
  onMaximize?: () => void;
  testsCollapsed?: boolean;
  isMaximized?: boolean;
}

export function EditorPanel({
  problemSlug,
  languages,
  activeLanguage,
  code,
  errors,
  markedLines,
  onLanguageChange,
  onCodeChange,
  onResetCode,
  onResetLayout,
  onRun,
  onSubmit,
  onToggleTests,
  onMaximize,
  testsCollapsed,
  isMaximized,
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
  const [reportOpen, setReportOpen] = useState(false);
  const moreActionsRef = useRef<HTMLButtonElement | null>(null);

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
      label: t('editor.runCode'),
      keybindings: [KeyMod.CtrlCmd | KeyCode.Quote],
      run: () => onRunRef.current?.(),
    });

    const submitAction = editor.addAction({
      id: 'codebite-submit',
      label: t('editor.submitCode'),
      keybindings: [KeyMod.CtrlCmd | KeyCode.Enter],
      run: () => onSubmitRef.current?.(),
    });

    return () => {
      runAction.dispose();
      submitAction.dispose();
    };
    // Re-registered on locale change so the command palette follows it.
  }, [editorMounted, t]);

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

  // The Tutorial's step 2 marks where the answer goes: a tinted band over those lines.
  const markStart = markedLines?.start;
  const markEnd = markedLines?.end;
  useEffect(() => {
    const editor = editorRef.current;
    if (!editor || markStart == null || markEnd == null) return;
    const marks = editor.createDecorationsCollection([
      {
        range: new MonacoRange(markStart, 1, markEnd, 1),
        options: { isWholeLine: true, className: 'cb-editor-tutorial-line' },
      },
    ]);
    editor.revealLinesInCenterIfOutsideViewport(markStart, markEnd);
    return () => marks.clear();
  }, [markStart, markEnd, editorMounted]);

  return (
    <div className="flex h-full flex-col">
      <div className="flex h-9 items-center justify-between gap-2 border-b border-border bg-muted px-1">
        <Select value={activeLanguage} onValueChange={onLanguageChange}>
          <SelectTrigger className="w-[130px]" aria-label={t('editor.languages')}>
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectLabel>{t('editor.languages')}</SelectLabel>
              {languages.map((lang) => (
                <SelectItem key={lang} value={lang}>
                  {languageLabel(lang)}
                </SelectItem>
              ))}
            </SelectGroup>
          </SelectContent>
        </Select>
        {/* Three groups: the code, the panes, then preferences and the rarely used actions. */}
        <div className="flex items-center">
          <ToolbarButton label={t('editor.resetCode')} onClick={onResetCode}>
            <RotateCcw className="h-3.5 w-3.5" />
          </ToolbarButton>
          <ToolbarDivider />
          <ToolbarButton
            label={t(testsCollapsed ? 'workspace.showTests' : 'workspace.hideTests')}
            onClick={onToggleTests}>
            {testsCollapsed
              ? <PanelBottomOpen className="h-3.5 w-3.5" />
              : <PanelBottomClose className="h-3.5 w-3.5" />}
          </ToolbarButton>
          <ToolbarButton
            label={t(isMaximized ? 'workspace.exitFullScreen' : 'workspace.fullScreen')}
            onClick={onMaximize}>
            {isMaximized ? <Minimize2 className="h-3.5 w-3.5" /> : <Maximize2 className="h-3.5 w-3.5" />}
          </ToolbarButton>
          <ToolbarDivider />
          <SettingsDialog />
          {/* Non-modal, so opening the bug report from it doesn't fight the menu over focus. */}
          <DropdownMenu modal={false}>
            <Tooltip>
              <TooltipTrigger>
                <DropdownMenuTrigger asChild>
                  <Button
                    ref={moreActionsRef}
                    variant="ghost"
                    size="icon"
                    className="h-7 w-7"
                    aria-label={t('editor.moreActions')}>
                    <Ellipsis className="h-3.5 w-3.5" />
                  </Button>
                </DropdownMenuTrigger>
              </TooltipTrigger>
              <TooltipContent>{t('editor.moreActions')}</TooltipContent>
            </Tooltip>
            <DropdownMenuContent align="end">
              <DropdownMenuItem onSelect={() => onResetLayout?.()}>
                <Columns2 className="h-3.5 w-3.5 text-muted-foreground" />
                {t('editor.resetLayout')}
              </DropdownMenuItem>
              <DropdownMenuItem onSelect={() => setReportOpen(true)}>
                <Bug className="h-3.5 w-3.5 text-muted-foreground" />
                {t('editor.reportProblem')}
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>

      <div className="min-h-0 flex-1">
        <Editor
          height="100%"
          language={MONACO_LANGUAGE[activeLanguage] || activeLanguage}
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
      </div>
      {settings.keyBindings === 'vim' && (
        <div
          ref={statusBarRef}
          className="border-t border-border bg-muted px-3 py-0.5 text-xs font-mono text-muted-foreground"
        />
      )}
      <ProblemReportDialog
        open={reportOpen}
        onClose={() => setReportOpen(false)}
        problemSlug={problemSlug}
        language={activeLanguage}
        returnFocusRef={moreActionsRef}
      />
    </div>
  );
}

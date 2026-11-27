import type * as MonacoApi from 'monaco-editor';
import { MEMBER_COMPLETION_LANGUAGES, insertText, memberCompletions, type MemberKind } from './memberCompletions';

type Monaco = typeof MonacoApi;

const registered = new WeakSet<Monaco>();

/**
 * Suggests a type's members after `.` (and `->` in C++) in every editor of this Monaco instance.
 * Pass it as the Editor's `beforeMount`: @monaco-editor/react loads its own Monaco, not the npm one.
 */
export function registerMemberCompletion(monaco: Monaco): void {
  if (registered.has(monaco)) return;
  registered.add(monaco);

  const { CompletionItemKind, CompletionItemInsertTextRule } = monaco.languages;
  const kinds: Record<MemberKind, MonacoApi.languages.CompletionItemKind> = {
    method: CompletionItemKind.Method,
    function: CompletionItemKind.Function,
    field: CompletionItemKind.Field,
    constant: CompletionItemKind.Constant,
  };

  for (const language of MEMBER_COMPLETION_LANGUAGES) {
    monaco.languages.registerCompletionItemProvider(language, {
      triggerCharacters: language === 'cpp' ? ['.', '>'] : ['.'],
      provideCompletionItems(model, position) {
        const lastLine = model.getLineCount();
        const members = memberCompletions(
          language,
          model.getValueInRange({
            startLineNumber: 1,
            startColumn: 1,
            endLineNumber: position.lineNumber,
            endColumn: position.column,
          }),
          model.getValueInRange({
            startLineNumber: position.lineNumber,
            startColumn: position.column,
            endLineNumber: lastLine,
            endColumn: model.getLineMaxColumn(lastLine),
          }),
        );
        if (!members) return { suggestions: [] };
        const word = model.getWordUntilPosition(position);
        const range = {
          startLineNumber: position.lineNumber,
          endLineNumber: position.lineNumber,
          startColumn: word.startColumn,
          endColumn: word.endColumn,
        };
        return {
          suggestions: members.map((member) => ({
            // Parameters inline, so overloads (`add(E e)`, `add(int index, E element)`) read apart.
            label: { label: member.name, detail: /\([^)]*\)/.exec(member.signature)?.[0] },
            kind: kinds[member.kind],
            detail: member.signature,
            documentation: member.doc,
            insertText: insertText(member),
            insertTextRules: CompletionItemInsertTextRule.InsertAsSnippet,
            range,
          })),
        };
      },
    });
  }
}

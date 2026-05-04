import { useTranslation } from 'react-i18next';
import { Plus, X } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import type { CustomTestCaseInput } from '@/types/submission';

interface CustomTestsEditorProps {
  customTests: CustomTestCaseInput[];
  onChange: (next: CustomTestCaseInput[]) => void;
  hintInput?: string;
  hintExpected?: string;
  maxCases?: number;
}

const TEXTAREA_CLASS =
  'mt-1 w-full resize-y rounded-md border border-border bg-background px-3 py-2 font-mono text-xs text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring';

export function CustomTestsEditor({
  customTests,
  onChange,
  hintInput,
  hintExpected,
  maxCases = 5,
}: CustomTestsEditorProps) {
  const { t } = useTranslation('problem');

  const addCase = () => {
    if (customTests.length >= maxCases) return;
    const seed =
      customTests.length === 0
        ? { input: hintInput ?? '', expectedOutput: hintExpected ?? '' }
        : { input: '', expectedOutput: '' };
    onChange([...customTests, seed]);
  };

  const removeCase = (idx: number) => {
    onChange(customTests.filter((_, i) => i !== idx));
  };

  const updateCase = (idx: number, patch: Partial<CustomTestCaseInput>) => {
    onChange(
      customTests.map((tc, i) => (i === idx ? { ...tc, ...patch } : tc)),
    );
  };

  const atMax = customTests.length >= maxCases;

  if (customTests.length === 0) {
    return (
      <div className="flex flex-col items-center gap-3 py-4">
        <p className="text-center text-xs text-muted-foreground">
          {t('test.customEmptyHelp', { max: maxCases })}
        </p>
        <Button variant="outline" size="sm" onClick={addCase}>
          <Plus className="h-3.5 w-3.5" />
          {t('test.addTestCase')}
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-2">
      {customTests.map((tc, i) => (
        <div key={i} className="rounded-lg border border-border bg-muted p-3 text-sm">
          <div className="mb-2 flex items-center justify-between">
            <span className="text-xs font-medium text-muted-foreground">
              {t('test.case', { n: i + 1 })}
            </span>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => removeCase(i)}
              aria-label={t('test.removeTestCase')}
              className="h-6 w-6 p-0">
              <X className="h-3.5 w-3.5" />
            </Button>
          </div>
          <label className="text-xs text-muted-foreground">
            {t('test.customInputLabel')}
          </label>
          <textarea
            value={tc.input}
            onChange={(e) => updateCase(i, { input: e.target.value })}
            maxLength={10000}
            rows={3}
            placeholder={hintInput}
            className={TEXTAREA_CLASS}
          />
          <label className="mt-2 block text-xs text-muted-foreground">
            {t('test.customExpectedLabel')}
          </label>
          <textarea
            value={tc.expectedOutput}
            onChange={(e) => updateCase(i, { expectedOutput: e.target.value })}
            maxLength={10000}
            rows={2}
            placeholder={hintExpected}
            className={TEXTAREA_CLASS}
          />
        </div>
      ))}
      <div className="flex items-center justify-between pt-1">
        <span className="text-xs text-muted-foreground">
          {customTests.length}/{maxCases}
        </span>
        <Button variant="outline" size="sm" onClick={addCase} disabled={atMax}>
          <Plus className="h-3.5 w-3.5" />
          {t('test.addTestCase')}
        </Button>
      </div>
    </div>
  );
}

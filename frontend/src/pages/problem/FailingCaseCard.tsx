import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Check, Copy, Eye, EyeOff, ListPlus, X } from 'lucide-react';
import { Badge } from '@/components/ui/Badge';
import { Button } from '@/components/ui/Button';
import type { CodeError, CustomTestCaseInput, FailingCase } from '@/types/submission';
import { MAX_CUSTOM_TESTS, type AddCustomTestOutcome } from './customTests';

interface FailingCaseCardProps {
  failingCase: FailingCase;
  /** The user's "Show failing test case" setting; off shows only the case number and errors. */
  showByDefault: boolean;
  /** Adds the case to the Test panel's custom test cases; absent outside the problem workspace. */
  onAddCustomTest?: (tc: CustomTestCaseInput) => AddCustomTestOutcome;
}

/**
 * A failed submission's Failing Case: its input, expected output and what the program printed,
 * or, for a crash or a timeout, what went wrong instead. Hidden behind a one-off Reveal when the
 * user has turned the setting off.
 */
export function FailingCaseCard({ failingCase, showByDefault, onAddCustomTest }: FailingCaseCardProps) {
  const { t } = useTranslation('problem');
  const [revealed, setRevealed] = useState(false);
  const [added, setAdded] = useState<AddCustomTestOutcome | null>(null);
  const visible = showByDefault || revealed;
  const { status, input, expectedOutput, actualOutput, errors, hidden } = failingCase;

  return (
    <section aria-labelledby="failing-case-heading">
      <div className="mb-2 flex items-center gap-2">
        <h3
          id="failing-case-heading"
          className="text-xs font-medium uppercase tracking-wider text-muted-foreground">
          {t('submissions.failingCase.heading')}
        </h3>
        <Badge variant={hidden ? 'outline' : 'secondary'} className="px-1.5 py-0 text-[11px]">
          {t(hidden ? 'submissions.failingCase.hidden' : 'submissions.failingCase.sample')}
        </Badge>
      </div>

      <div className="space-y-3 rounded-lg border border-border p-3">
        {visible ? (
          <>
            <CaseField label={t('submissions.failingCase.input')} value={input} />
            <CaseField label={t('submissions.expectedOutput')} value={expectedOutput} />
            {status === 'WRONG_ANSWER' && (
              <CaseField label={t('submissions.yourOutput')} value={actualOutput ?? ''} failed />
            )}
          </>
        ) : (
          <div className="flex items-start gap-2.5">
            <EyeOff aria-hidden="true" className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground" />
            <div className="text-sm">
              <p className="text-foreground">{t('submissions.failingCase.hiddenBySetting')}</p>
              <p className="mt-0.5 text-xs text-muted-foreground">
                {t('submissions.failingCase.hiddenBySettingHint')}
              </p>
            </div>
          </div>
        )}

        {status === 'TIME_LIMIT_EXCEEDED' && (
          <p className="text-xs text-warning-700 dark:text-warning-400">{t('submissions.failingCase.timedOut')}</p>
        )}
        {status === 'RUNTIME_ERROR' &&
          (errors.length > 0 ? (
            <Diagnostics errors={errors} />
          ) : (
            <p className="text-xs text-error-700 dark:text-error-400">{t('submissions.failingCase.crashed')}</p>
          ))}

        <div className="flex flex-wrap items-center gap-2 pt-0.5">
          {visible ? (
            onAddCustomTest && (
              <>
                <Button
                  variant="outline"
                  size="sm"
                  onClick={() => setAdded(onAddCustomTest({ input, expectedOutput }))}>
                  <ListPlus className="h-3.5 w-3.5" />
                  {t('submissions.failingCase.addAsCustom')}
                </Button>
                <span aria-live="polite" className="text-xs text-muted-foreground">
                  {added && t(`submissions.failingCase.addOutcome.${added}`, { max: MAX_CUSTOM_TESTS })}
                </span>
              </>
            )
          ) : (
            <Button variant="outline" size="sm" onClick={() => setRevealed(true)}>
              <Eye className="h-3.5 w-3.5" />
              {t('submissions.failingCase.reveal')}
            </Button>
          )}
        </div>
      </div>
    </section>
  );
}

/** The errors a program reported, on the user's own lines where they map onto them. */
export function Diagnostics({ errors }: { errors: CodeError[] }) {
  const { t } = useTranslation('problem');
  return (
    <ul className="max-h-48 space-y-1 overflow-auto rounded-md bg-error-100 px-2.5 py-2 font-mono text-xs text-error-700 dark:bg-error-950 dark:text-error-400">
      {errors.map((e, i) => (
        <li key={i} className="flex gap-2">
          {e.inUserCode && e.line != null && (
            <span className="shrink-0 tabular-nums opacity-80">{t('submissions.line', { n: e.line })}</span>
          )}
          <span className="whitespace-pre-wrap break-words">{e.message}</span>
        </li>
      ))}
    </ul>
  );
}

/** One labelled block of case text, scrollable past a few lines and copyable. */
function CaseField({ label, value, failed = false }: { label: string; value: string; failed?: boolean }) {
  const { t } = useTranslation('problem');
  const [copy, setCopy] = useState<'idle' | 'success' | 'error'>('idle');
  const timer = useRef<ReturnType<typeof setTimeout> | null>(null);
  useEffect(() => () => {
    if (timer.current) clearTimeout(timer.current);
  }, []);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(value);
      setCopy('success');
    } catch {
      setCopy('error');
    }
    if (timer.current) clearTimeout(timer.current);
    timer.current = setTimeout(() => setCopy('idle'), 1500);
  };

  const copyLabel =
    copy === 'success'
      ? t('submissions.copied')
      : copy === 'error'
        ? t('submissions.copyFailed')
        : t('submissions.failingCase.copyField', { field: label });

  return (
    <div>
      <div className="mb-1 flex items-center justify-between">
        <span className="text-xs font-medium text-muted-foreground">{label}</span>
        <Button variant="ghost" size="icon" className="h-6 w-6" onClick={handleCopy} aria-label={copyLabel} title={copyLabel}>
          {copy === 'success' ? (
            <Check className="h-3 w-3 text-success-600 dark:text-success-400" />
          ) : copy === 'error' ? (
            <X className="h-3 w-3 text-destructive" />
          ) : (
            <Copy className="h-3 w-3" />
          )}
        </Button>
      </div>
      <pre
        tabIndex={0}
        className={`max-h-40 overflow-auto whitespace-pre-wrap break-all rounded-md px-2.5 py-1.5 font-mono text-xs focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring ${
          failed
            ? 'bg-error-100 text-error-700 dark:bg-error-950 dark:text-error-400'
            : 'bg-muted text-foreground'
        }`}>
        {value === '' ? <span className="italic text-muted-foreground">{t('submissions.failingCase.empty')}</span> : value}
      </pre>
    </div>
  );
}

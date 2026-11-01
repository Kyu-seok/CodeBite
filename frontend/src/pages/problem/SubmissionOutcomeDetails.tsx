import { useId } from 'react';
import { useTranslation } from 'react-i18next';
import { CircleAlert } from 'lucide-react';
import { useEditorSettings } from '@/context/EditorSettingsContext';
import type { CustomTestCaseInput, FailingCase, SubmissionResponse } from '@/types/submission';
import type { AddCustomTestOutcome } from './customTests';
import { Diagnostics, FailingCaseCard } from './FailingCaseCard';
import { submissionOutcome } from './submissionOutcome';

/** " · case 7 of 42", after a failed submission's status. */
export function FailingCasePosition({ failingCase }: { failingCase: FailingCase }) {
  const { t } = useTranslation('problem');
  return (
    <span className="font-normal text-muted-foreground">
      {' · '}
      {t('submissions.failingCase.position', { n: failingCase.position, total: failingCase.total })}
    </span>
  );
}

/**
 * What a judged submission shows below its status line, the same in the Test panel's Output tab
 * and in a past submission: its Failing Case, the compiler's errors, an apology for a failure on
 * our side, or nothing when it was Accepted.
 */
export function SubmissionOutcomeDetails({
  submission,
  onAddCustomTest,
}: {
  submission: SubmissionResponse;
  onAddCustomTest?: (tc: CustomTestCaseInput) => AddCustomTestOutcome;
}) {
  const { t } = useTranslation('problem');
  const { settings } = useEditorSettings();
  const headingId = useId();
  const outcome = submissionOutcome(submission);

  switch (outcome.kind) {
    case 'failingCase':
      return (
        <FailingCaseCard
          key={submission.id}
          failingCase={outcome.failingCase}
          showByDefault={settings.showFailingCase}
          onAddCustomTest={onAddCustomTest}
          submission={submission}
        />
      );
    case 'compileErrors':
      return outcome.errors.length > 0 ? (
        <section aria-labelledby={headingId}>
          <h3 id={headingId} className="mb-2 text-xs font-medium uppercase tracking-wider text-muted-foreground">
            {t('submissions.compilerOutput')}
          </h3>
          <Diagnostics errors={outcome.errors} />
        </section>
      ) : null;
    case 'internalError':
      return (
        <div className="flex items-start gap-2.5 rounded-lg border border-border bg-muted/30 px-3 py-2.5 text-sm">
          <CircleAlert aria-hidden="true" className="mt-0.5 h-4 w-4 shrink-0 text-muted-foreground" />
          <div>
            <p className="text-foreground">{t('submissions.internalError')}</p>
            <p className="mt-0.5 text-xs text-muted-foreground">{t('submissions.internalErrorHint')}</p>
          </div>
        </div>
      );
    default:
      return null;
  }
}

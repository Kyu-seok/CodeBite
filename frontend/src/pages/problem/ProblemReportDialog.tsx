import { useEffect, useId, useState, type RefObject } from 'react';
import { useTranslation } from 'react-i18next';
import { ExternalLink } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from '@/components/ui/Dialog';
import { languageLabel } from './submissionDisplay';
import {
  REPORT_CATEGORIES,
  TEST_CASE_CATEGORY,
  attachedCase,
  canSendReport,
  problemReportUrl,
  type ReportCategory,
  type ReportedCase,
} from './problemReport';

/**
 * A Problem Report, made from the editor's menu or from a Failing Case. There is no report
 * endpoint, so it becomes a prefilled GitHub issue the user posts themselves; the dialog says so
 * instead of pretending the report was sent.
 */
export function ProblemReportDialog({
  open,
  onClose,
  problemSlug,
  language,
  reportedCase = null,
  returnFocusRef,
}: {
  open: boolean;
  onClose: () => void;
  problemSlug: string;
  language: string;
  /** The Failing Case the report is about; it starts on "Test case is wrong" and needs no words. */
  reportedCase?: ReportedCase | null;
  /** Set when opened from a menu item that is gone by close time: focus goes to the menu's trigger. */
  returnFocusRef?: RefObject<HTMLButtonElement | null>;
}) {
  const { t } = useTranslation('problem');
  const { t: tc } = useTranslation('common');
  const [category, setCategory] = useState<ReportCategory>(REPORT_CATEGORIES[0]);
  const [description, setDescription] = useState('');
  // The issue URL once opened; kept so a blocked popup still has a way through.
  const [issueUrl, setIssueUrl] = useState<string | null>(null);
  const fieldId = useId();
  const aboutTestCase = category === TEST_CASE_CATEGORY;
  const attached = attachedCase(category, reportedCase);

  useEffect(() => {
    if (open) {
      // eslint-disable-next-line react-hooks/set-state-in-effect -- The dialog stays mounted while closed; each opening starts a blank report.
      setCategory(REPORT_CATEGORIES[0]);
      setDescription('');
      setIssueUrl(null);
    }
  }, [open]);

  const handleSubmit = () => {
    const url = problemReportUrl({
      problemSlug,
      language: languageLabel(language),
      category,
      categoryLabel: t(`problemReport.${category}`, { lng: 'en' }),
      pageUrl: window.location.href,
      description,
      reportedCase: attached,
    });
    // With noopener, window.open returns null even on success, so a blocked popup can't be
    // detected; the confirmation always offers the link as well.
    window.open(url, '_blank', 'noopener,noreferrer');
    setIssueUrl(url);
  };

  return (
    <Dialog open={open} onOpenChange={(isOpen) => { if (!isOpen) onClose(); }}>
      <DialogContent
        className="max-w-md"
        onCloseAutoFocus={
          returnFocusRef
            ? (e) => {
                e.preventDefault();
                returnFocusRef.current?.focus();
              }
            : undefined
        }>
        <DialogHeader>
          <DialogTitle>{t('problemReport.title')}</DialogTitle>
          <DialogDescription>{t('problemReport.description')}</DialogDescription>
        </DialogHeader>
        {issueUrl ? (
          <div className="py-6 text-center" role="status">
            <p className="text-sm font-medium text-foreground">{t('problemReport.opened')}</p>
            <p className="mt-1 text-xs text-muted-foreground">{t('problemReport.openedHint')}</p>
            <a
              href={issueUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-3 inline-flex items-center gap-1 text-xs text-accent-700 underline-offset-4 hover:underline dark:text-accent-400">
              {t('problemReport.openManually')}
              <ExternalLink className="h-3 w-3" />
            </a>
            <div>
              <Button variant="outline" size="sm" className="mt-4" onClick={onClose}>
                {tc('button.close')}
              </Button>
            </div>
          </div>
        ) : (
          <>
            <div className="mt-2 space-y-4">
              <div>
                <label htmlFor={`${fieldId}-category`} className="mb-1.5 block text-sm font-medium text-foreground">
                  {t('problemReport.category')}
                </label>
                <select
                  id={`${fieldId}-category`}
                  value={category}
                  onChange={(e) => setCategory(e.target.value as ReportCategory)}
                  aria-describedby={aboutTestCase ? `${fieldId}-hint` : undefined}
                  className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                >
                  {REPORT_CATEGORIES.map((c) => (
                    <option key={c} value={c}>{t(`problemReport.${c}`)}</option>
                  ))}
                </select>
                {aboutTestCase && (
                  <p id={`${fieldId}-hint`} className="mt-1.5 text-xs text-muted-foreground">
                    {t('problemReport.wrongTestCaseHint')}
                  </p>
                )}
              </div>
              {attached && (
                <p className="rounded-md bg-muted px-2.5 py-2 text-xs text-muted-foreground">
                  {t(attached.failingCase.hidden ? 'problemReport.attachedHidden' : 'problemReport.attachedSample', {
                    n: attached.failingCase.position,
                    total: attached.failingCase.total,
                  })}
                </p>
              )}
              <div>
                <label htmlFor={`${fieldId}-description`} className="mb-1.5 block text-sm font-medium text-foreground">
                  {t(attached ? 'problemReport.descriptionLabelOptional' : 'problemReport.descriptionLabel')}
                </label>
                <textarea
                  id={`${fieldId}-description`}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  maxLength={1000}
                  rows={4}
                  placeholder={t(attached ? 'problemReport.placeholderCase' : 'problemReport.placeholder')}
                  className="w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                />
              </div>
              <p className="text-xs text-muted-foreground">{t('problemReport.githubNote')}</p>
            </div>
            <DialogFooter className="mt-4">
              <Button variant="outline" size="sm" onClick={onClose}>
                {tc('button.cancel')}
              </Button>
              <Button size="sm" onClick={handleSubmit} disabled={!canSendReport(description, attached)}>
                {t('problemReport.submit')}
                <ExternalLink className="h-3.5 w-3.5" />
              </Button>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

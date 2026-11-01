import { useEffect, useState, type RefObject } from 'react';
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
      categoryLabel: t(`bugReport.${category}`, { lng: 'en' }),
      pageUrl: window.location.href,
      description,
      reportedCase: category === 'wrongTestCase' ? reportedCase : null,
    });
    // With noopener, window.open returns null even on success, so a blocked popup can't be
    // detected; the confirmation always offers the link as well.
    window.open(url, '_blank', 'noopener,noreferrer');
    setIssueUrl(url);
  };

  const attached = category === 'wrongTestCase' ? reportedCase : null;

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
          <DialogTitle>{t('bugReport.title')}</DialogTitle>
          <DialogDescription>{t('bugReport.description')}</DialogDescription>
        </DialogHeader>
        {issueUrl ? (
          <div className="py-6 text-center" role="status">
            <p className="text-sm font-medium text-foreground">{t('bugReport.opened')}</p>
            <p className="mt-1 text-xs text-muted-foreground">{t('bugReport.openedHint')}</p>
            <a
              href={issueUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-3 inline-flex items-center gap-1 text-xs text-accent-700 underline-offset-4 hover:underline dark:text-accent-400">
              {t('bugReport.openManually')}
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
                <label htmlFor="bug-category" className="mb-1.5 block text-sm font-medium text-foreground">
                  {t('bugReport.category')}
                </label>
                <select
                  id="bug-category"
                  value={category}
                  onChange={(e) => setCategory(e.target.value as ReportCategory)}
                  aria-describedby={category === 'wrongTestCase' ? 'bug-category-hint' : undefined}
                  className="w-full rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                >
                  {REPORT_CATEGORIES.map((c) => (
                    <option key={c} value={c}>{t(`bugReport.${c}`)}</option>
                  ))}
                </select>
                {category === 'wrongTestCase' && (
                  <p id="bug-category-hint" className="mt-1.5 text-xs text-muted-foreground">
                    {t('bugReport.wrongTestCaseHint')}
                  </p>
                )}
              </div>
              {attached && (
                <p className="rounded-md bg-muted px-2.5 py-2 text-xs text-muted-foreground">
                  {t(attached.failingCase.hidden ? 'bugReport.attachedHidden' : 'bugReport.attachedSample', {
                    n: attached.failingCase.position,
                    total: attached.failingCase.total,
                  })}
                </p>
              )}
              <div>
                <label htmlFor="bug-description" className="mb-1.5 block text-sm font-medium text-foreground">
                  {t(attached ? 'bugReport.descriptionLabelOptional' : 'bugReport.descriptionLabel')}
                </label>
                <textarea
                  id="bug-description"
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  maxLength={1000}
                  rows={4}
                  placeholder={t(attached ? 'bugReport.placeholderCase' : 'bugReport.placeholder')}
                  className="w-full resize-none rounded-md border border-border bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                />
              </div>
              <p className="text-xs text-muted-foreground">{t('bugReport.githubNote')}</p>
            </div>
            <DialogFooter className="mt-4">
              <Button variant="outline" size="sm" onClick={onClose}>
                {tc('button.cancel')}
              </Button>
              <Button size="sm" onClick={handleSubmit} disabled={!canSendReport(description, attached)}>
                {t('bugReport.submit')}
                <ExternalLink className="h-3.5 w-3.5" />
              </Button>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

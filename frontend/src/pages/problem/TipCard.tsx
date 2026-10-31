import { useTranslation } from 'react-i18next';
import { Lightbulb } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import type { Tip } from '@/onboarding';

/** A Tip (GLOSSARY.md) next to the result it explains; `tipFor` decides which, this only shows it. */
export function TipCard({ tip, onDismiss }: { tip: Tip; onDismiss: (tip: Tip) => void }) {
  const { t } = useTranslation('problem');
  return (
    <aside
      aria-label={t('tips.label')}
      className="flex items-start gap-3 rounded-lg border border-border bg-card p-3 text-sm text-card-foreground">
      <Lightbulb className="mt-0.5 h-4 w-4 shrink-0 text-accent-700 dark:text-accent-400" aria-hidden />
      <div className="min-w-0 flex-1">
        <p className="font-semibold text-foreground">{t(`tips.${tip}.title`)}</p>
        <p className="mt-1 leading-relaxed text-muted-foreground">{t(`tips.${tip}.body`)}</p>
      </div>
      <Button
        variant="ghost"
        size="sm"
        className="shrink-0"
        onClick={() => onDismiss(tip)}
        aria-label={t('tips.dismissLabel')}>
        {t('tips.dismiss')}
      </Button>
    </aside>
  );
}

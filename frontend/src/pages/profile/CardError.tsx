import { useTranslation } from 'react-i18next';
import { Button } from '@/components/ui/Button';

/**
 * What a profile card shows when its request failed, in place of an empty state
 * that would claim there is nothing there.
 */
export function CardError({ message, onRetry }: { message?: string; onRetry?: () => void }) {
  const { t } = useTranslation('profile');
  return (
    <div role="alert" className="flex flex-col items-center justify-center gap-3 py-6 text-center">
      <p className="text-sm text-muted-foreground">{message ?? t('error.load')}</p>
      {onRetry && (
        <Button size="sm" variant="outline" onClick={onRetry}>
          {t('error.retry')}
        </Button>
      )}
    </div>
  );
}

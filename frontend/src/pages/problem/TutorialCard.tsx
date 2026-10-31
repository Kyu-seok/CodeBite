import { useTranslation } from 'react-i18next';
import { Check, PartyPopper } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { cn } from '@/lib/utils';
import { TUTORIAL_STEPS, type TutorialStepName } from '@/onboarding';

/**
 * The Tutorial's step card (GLOSSARY.md), docked at the top of the left panel: the six steps as a
 * checklist with the current one open. `tutorialStep` decides the step; this only shows it.
 */
export function TutorialCard({
  step,
  onNext,
  onSkip,
}: {
  step: TutorialStepName;
  /** Moves past a reading step (1 or 2). */
  onNext: () => void;
  /** Skips the Tutorial, or closes it after the celebration. */
  onSkip: () => void;
}) {
  const { t } = useTranslation('problem');
  const index = TUTORIAL_STEPS.indexOf(step);
  const reading = step === 'read' || step === 'function';
  const celebrating = step === 'accepted';

  return (
    <section
      aria-label={t('tutorial.label')}
      className="border-b border-border bg-card px-4 py-3 text-sm text-card-foreground">
      <div className="flex items-center justify-between gap-3">
        <p className="text-xs font-medium text-muted-foreground">
          {t('tutorial.progress', { step: index + 1, total: TUTORIAL_STEPS.length })}
        </p>
        {!celebrating && (
          <Button variant="ghost" size="sm" className="-mr-2 h-7" onClick={onSkip}>
            {t('tutorial.skip')}
          </Button>
        )}
      </div>
      <ol className="mt-2 flex flex-col gap-1.5">
        {TUTORIAL_STEPS.map((name, i) => {
          const done = i < index;
          const current = i === index;
          return (
            <li
              key={name}
              aria-current={current ? 'step' : undefined}
              className={cn(
                'flex items-start gap-2.5 rounded-md',
                current && 'bg-accent-500/10 px-2 py-2',
                !current && 'px-2',
              )}>
              <span
                aria-hidden
                className={cn(
                  'mt-px flex h-5 w-5 shrink-0 items-center justify-center rounded-full text-xs font-semibold',
                  done && 'bg-accent-700 text-white dark:bg-accent-400 dark:text-accent-950',
                  current && 'border-2 border-accent-700 text-accent-700 dark:border-accent-400 dark:text-accent-400',
                  !done && !current && 'border border-border text-muted-foreground',
                )}>
                {done ? <Check className="h-3 w-3" strokeWidth={3} /> : i + 1}
              </span>
              <div className="min-w-0 flex-1">
                <p
                  className={cn(
                    current ? 'font-semibold text-foreground' : 'text-muted-foreground',
                    done && 'line-through decoration-muted-foreground/50',
                  )}>
                  {current && celebrating && (
                    <PartyPopper className="mr-1.5 inline h-4 w-4 align-[-2px] text-accent-700 dark:text-accent-400" aria-hidden />
                  )}
                  {t(`tutorial.steps.${name}.title`)}
                  {done && <span className="sr-only"> ({t('tutorial.stepDone')})</span>}
                </p>
                {current && (
                  <>
                    <p className="mt-1 leading-relaxed text-muted-foreground">{t(`tutorial.steps.${name}.body`)}</p>
                    {(reading || celebrating) && (
                      <Button
                        variant={celebrating ? 'accent' : 'secondary'}
                        size="sm"
                        className="mt-2"
                        onClick={celebrating ? onSkip : onNext}>
                        {t(celebrating ? 'tutorial.done' : 'tutorial.next')}
                      </Button>
                    )}
                  </>
                )}
              </div>
            </li>
          );
        })}
      </ol>
    </section>
  );
}

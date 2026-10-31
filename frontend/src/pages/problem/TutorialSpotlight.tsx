import { useEffect, useId, useLayoutEffect, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';
import { autoUpdate, flip, offset, shift, useFloating, type Placement } from '@floating-ui/react-dom';
import { PartyPopper } from 'lucide-react';
import { Button } from '@/components/ui/Button';
import { cn } from '@/lib/utils';
import { TUTORIAL_STEPS, type Spotlight, type TourTarget } from '@/onboarding';

/** Room left around a spotlit element, in px. */
const PAD = 6;
const RADIUS = 10;

/** The element a target names: marked `data-tour` in the workspace, the first one on screen. */
function tourElement(target: TourTarget): HTMLElement | null {
  const all = document.querySelectorAll<HTMLElement>(`[data-tour="${target}"]`);
  for (const el of all) if (el.getClientRects().length > 0) return el;
  return null;
}

interface Box {
  x: number;
  y: number;
  w: number;
  h: number;
}

function boxOf(el: HTMLElement): Box | null {
  const r = el.getBoundingClientRect();
  if (r.width <= 0 || r.height <= 0) return null;
  return { x: r.left - PAD, y: r.top - PAD, w: r.width + PAD * 2, h: r.height + PAD * 2 };
}

const sameBoxes = (a: Box[], b: Box[]) =>
  a.length === b.length &&
  a.every((box, i) => box.x === b[i].x && box.y === b[i].y && box.w === b[i].w && box.h === b[i].h);

/**
 * Where each element on screen is, measured every frame while a step shows: panels are resized and
 * collapsed, the stacked layout scrolls and results grow, and the cut-outs must follow all of it.
 */
function useBoxes(targets: readonly TourTarget[]): { lit: Box[]; anchor: HTMLElement | null; layered: boolean } {
  const [lit, setLit] = useState<Box[]>([]);
  const [anchor, setAnchor] = useState<HTMLElement | null>(null);
  const [layered, setLayered] = useState(false);
  const key = targets.join(' ');
  useEffect(() => {
    let frame = 0;
    const measure = () => {
      const els = key.split(' ').map((t) => tourElement(t as TourTarget));
      const boxes = els.flatMap((el) => (el ? [boxOf(el)] : [])).filter((b): b is Box => b != null);
      setLit((prev) => (sameBoxes(prev, boxes) ? prev : boxes));
      // The anchor (always the first target) counts only once it has a size, so the coach mark
      // never points at nothing while a panel is still opening.
      const first = els[0];
      setAnchor(first && boxOf(first) ? first : null);
      setLayered(document.querySelector(OPEN_LAYER) != null);
      frame = requestAnimationFrame(measure);
    };
    measure();
    return () => cancelAnimationFrame(frame);
  }, [key]);
  return { lit, anchor, layered };
}

/**
 * A dialog or popup someone else opened (the Accepted modal, a confirmation, the language list).
 * They sit below the spotlight, which sits above the sticky header so the header is dimmed too; while
 * one is open the spotlight steps aside and comes back when it closes.
 */
const OPEN_LAYER =
  '[role="dialog"][data-state="open"], [role="alertdialog"][data-state="open"], [role="listbox"], [role="menu"]';

const FOCUSABLE =
  'a[href], button:not([disabled]), input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])';

/** Another dialog or popup on top (the Accepted modal, a confirmation, a language list): not ours to steer. */
function inForeignLayer(el: Element | null, own: Element | null): boolean {
  const layer = el?.closest('[role="dialog"], [role="alertdialog"], [role="listbox"], [role="menu"]');
  return layer != null && layer !== own;
}

/** Where the coach mark sits beside each target on a wide screen; floating-ui flips it when it doesn't fit. */
const PLACEMENT: Record<TourTarget, Placement> = {
  description: 'right-start',
  editor: 'left-start',
  run: 'top-end',
  submit: 'left-end',
  result: 'left-end',
};

/**
 * The Tutorial as a spotlight with a coach mark (docs/adr/0008). Everything outside the spotlit
 * elements is dimmed and takes no clicks; only Skip ends the Tutorial, never a click on the dimmed
 * page or Escape. Tab cycles through the coach mark and the spotlit elements. `spotlight` comes from
 * `tutorialSpotlight`; this only draws it.
 */
export function TutorialSpotlight({
  spotlight,
  desktop,
  onNext,
  onSkip,
}: {
  spotlight: Spotlight;
  /** Wide layout: the coach mark sits beside its target; narrow, it is a sheet at the bottom or top. */
  desktop: boolean;
  /** Moves past a reading step (1 or 2). */
  onNext: () => void;
  /** Skips the Tutorial, or closes it after the celebration. */
  onSkip: () => void;
}) {
  const { t } = useTranslation('problem');
  const titleId = useId();
  const maskId = `tutorial-spotlight-${useId().replace(/:/g, '')}`;
  const markRef = useRef<HTMLDivElement | null>(null);
  const targets = [spotlight.anchor, ...spotlight.lit.filter((target) => target !== spotlight.anchor)];
  const { lit, anchor, layered } = useBoxes(targets);
  const anchorBox = anchor && !layered ? boxOf(anchor) : null;
  const { refs, floatingStyles } = useFloating({
    elements: { reference: anchor },
    placement: PLACEMENT[spotlight.anchor],
    middleware: [offset(PAD + 10), flip({ padding: 12 }), shift({ padding: 12, crossAxis: true })],
    whileElementsMounted: autoUpdate,
  });

  const litElements = () =>
    spotlight.lit.map(tourElement).filter((el): el is HTMLElement => el != null);
  const inLit = (el: Element | null) => el != null && litElements().some((lit) => lit.contains(el));

  // A new step: bring a stacked layout's target into view, then hand the coach mark the focus unless
  // the user is working in a spotlit element (typing in the editor moves step 2 on; it must not
  // lose the caret).
  const shown = anchor != null && !layered;
  useLayoutEffect(() => {
    if (!shown) return;
    const el = tourElement(spotlight.anchor);
    if (!desktop && el) {
      const big = el.getBoundingClientRect().height > window.innerHeight / 2;
      const reduce = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      el.scrollIntoView({ block: big ? 'start' : 'center', behavior: reduce ? 'auto' : 'smooth' });
    }
    if (!inLit(document.activeElement) && !inForeignLayer(document.activeElement, markRef.current)) {
      markRef.current?.focus({ preventScroll: true });
    }
    // Once per step and copy, not on every measurement.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [spotlight.copy, shown, desktop]);

  // Tab stays among the coach mark and the spotlit elements; Escape returns to the coach mark from
  // anywhere else. The editor keeps its own Tab and Escape (indenting, closing suggestions, Vim).
  useEffect(() => {
    const onKeyDown = (e: KeyboardEvent) => {
      if (e.defaultPrevented) return;
      const mark = markRef.current;
      const active = document.activeElement;
      if (!mark || inForeignLayer(active, mark)) return;
      if (e.key === 'Escape') {
        if (!inLit(active)) mark.focus({ preventScroll: true });
        return;
      }
      if (e.key !== 'Tab') return;
      const stops = [mark, ...litElements()]
        .flatMap((root) => Array.from(root.querySelectorAll<HTMLElement>(FOCUSABLE)))
        .filter((el) => el.getClientRects().length > 0)
        .sort((a, b) => (a.compareDocumentPosition(b) & Node.DOCUMENT_POSITION_FOLLOWING ? -1 : 1));
      if (stops.length === 0) return;
      const at = active instanceof HTMLElement ? stops.indexOf(active) : -1;
      const next = at < 0 ? (e.shiftKey ? stops.length - 1 : 0) : (at + (e.shiftKey ? -1 : 1) + stops.length) % stops.length;
      e.preventDefault();
      stops[next].focus();
    };
    document.addEventListener('keydown', onKeyDown);
    return () => document.removeEventListener('keydown', onKeyDown);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [spotlight]);

  // A click on the dimmed page does nothing at all: it neither reaches the page nor skips. Decided
  // by the element pressed, not by where the cut-outs are, so a button inside a spotlit panel and
  // the seam between two touching panels behave alike. Touch scrolling is left alone.
  useEffect(() => {
    const block = (e: Event) => {
      const target = e.target instanceof Element ? e.target : null;
      const mark = markRef.current;
      if (!target || !mark || mark.contains(target) || inLit(target) || inForeignLayer(target, mark)) return;
      if (document.querySelector(OPEN_LAYER)) return;
      e.preventDefault();
      e.stopPropagation();
    };
    const kinds = ['pointerdown', 'mousedown', 'click', 'dblclick', 'auxclick', 'contextmenu'] as const;
    for (const kind of kinds) window.addEventListener(kind, block, true);
    return () => {
      for (const kind of kinds) window.removeEventListener(kind, block, true);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [spotlight]);

  // Nothing is dimmed until the target is on screen, so a missing target never leaves the page blocked.
  // The click blocker above stands down too: another layer is open, or nothing is shown.
  if (!anchorBox) return null;

  const index = TUTORIAL_STEPS.indexOf(spotlight.step);
  const progress = t('tutorial.progress', { step: index + 1, total: TUTORIAL_STEPS.length });
  const title = t(`tutorial.steps.${spotlight.copy}.title`);
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const celebrating = spotlight.copy === 'accepted';
  // A narrow screen's sheet docks at the bottom, or at the top when the target sits low (Run and
  // Submit end the stacked column, so no scroll lifts them above a bottom sheet).
  const dockTop = !desktop && anchorBox.y + anchorBox.h / 2 > vh * 0.55;

  const coachMark = (
    <div
      ref={(el) => {
        markRef.current = el;
        if (desktop) refs.setFloating(el);
      }}
      role="dialog"
      aria-modal="false"
      aria-labelledby={titleId}
      tabIndex={-1}
      style={desktop ? floatingStyles : undefined}
      className={cn(
        'z-[55] border border-border bg-card text-sm text-card-foreground shadow-xl outline-none focus-visible:ring-2 focus-visible:ring-ring',
        desktop
          ? 'w-80 rounded-xl p-4'
          : dockTop
            ? 'fixed inset-x-0 top-0 rounded-b-2xl px-4 pb-4 pt-[max(1rem,env(safe-area-inset-top))]'
            : 'fixed inset-x-0 bottom-0 rounded-t-2xl px-4 pb-[max(1rem,env(safe-area-inset-bottom))] pt-4',
      )}>
      <div className="flex items-center justify-between gap-3">
        <p className="text-xs font-medium text-muted-foreground">{progress}</p>
        {!celebrating && (
          <Button variant="ghost" size="sm" className="-mr-2 h-7" onClick={onSkip}>
            {t('tutorial.skip')}
          </Button>
        )}
      </div>
      <p id={titleId} className="mt-1 font-semibold text-foreground">
        {celebrating && (
          <PartyPopper className="mr-1.5 inline h-4 w-4 align-[-2px] text-accent-700 dark:text-accent-400" aria-hidden />
        )}
        {title}
      </p>
      <p className="mt-1 leading-relaxed text-muted-foreground">{t(`tutorial.steps.${spotlight.copy}.body`)}</p>
      {spotlight.action && (
        <div className="mt-3 flex justify-end">
          <Button
            variant={celebrating ? 'accent' : 'secondary'}
            size="sm"
            onClick={spotlight.action === 'done' ? onSkip : onNext}>
            {t(spotlight.action === 'done' ? 'tutorial.done' : 'tutorial.next')}
          </Button>
        </div>
      )}
    </div>
  );

  return createPortal(
    <>
      <svg className="pointer-events-none fixed inset-0 z-[55] h-full w-full" aria-hidden>
        <defs>
          {/* A mask, so cut-outs that overlap or nest (Submit inside the result) merge into one. */}
          <mask id={maskId}>
            <rect width={vw} height={vh} fill="white" />
            {lit.map((box, i) => (
              <rect key={i} x={box.x} y={box.y} width={box.w} height={box.h} rx={RADIUS} fill="black" />
            ))}
          </mask>
        </defs>
        <rect width={vw} height={vh} mask={`url(#${maskId})`} className="fill-black/55 dark:fill-black/70" />
      </svg>
      <div
        aria-hidden
        className="pointer-events-none fixed z-[55] rounded-[10px] ring-2 ring-accent-500 motion-safe:transition-all motion-safe:duration-300 dark:ring-accent-400"
        style={{ left: anchorBox.x, top: anchorBox.y, width: anchorBox.w, height: anchorBox.h }}
      />
      {coachMark}
      <p className="sr-only" aria-live="polite">
        {`${progress}: ${title}`}
      </p>
    </>,
    document.body,
  );
}

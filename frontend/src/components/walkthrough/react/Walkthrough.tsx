// Thin React wrapper: the player owns its DOM inside one div; React only mounts and unmounts it.
import { useEffect, useRef } from 'react';
import { mount, type MountOptions, type Walkthrough as WalkthroughData } from '../walkthrough.js';
import '../walkthrough.css';

export interface WalkthroughProps extends Omit<MountOptions, 'onChange'> {
  data: WalkthroughData;
  className?: string;
  onStep?: MountOptions['onChange'];
}

export function Walkthrough({ data, className, lang, theme, start, interval, hint, ui, onStep }: WalkthroughProps) {
  const root = useRef<HTMLDivElement>(null);
  const onStepRef = useRef(onStep);
  useEffect(() => { onStepRef.current = onStep; });
  useEffect(() => {
    if (!root.current) return;
    const player = mount(root.current, data, { lang, theme, start, interval, hint, ui, onChange: (r, f) => onStepRef.current?.(r, f) });
    return () => player.destroy();
    // start only applies to the first mount; a new data, lang or theme remounts at the start
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data, lang, theme, interval, hint, ui]);
  return <div ref={root} className={className} />;
}

/** A unit of time in the UI language's narrow form: "19h" / "19시간", "48m" / "48분". */
function unit(value: number, name: "hour" | "minute" | "second", locale: string): string {
  return new Intl.NumberFormat(locale, { style: "unit", unit: name, unitDisplay: "narrow" }).format(value);
}

/** Hours and minutes, e.g. "19h 48m"; minutes alone under an hour. */
export function formatDuration(seconds: number, locale: string): string {
  const hours = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  if (hours === 0) return unit(mins, "minute", locale);
  return mins > 0 ? `${unit(hours, "hour", locale)} ${unit(mins, "minute", locale)}` : unit(hours, "hour", locale);
}

/** Minutes and seconds for a single solve, e.g. "7m 27s"; seconds alone under a minute. */
export function formatSolveTime(seconds: number, locale: string): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return m > 0 ? `${unit(m, "minute", locale)} ${unit(s, "second", locale)}` : unit(s, "second", locale);
}

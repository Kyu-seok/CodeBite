/** How long ago, in the UI language: "3 hr. ago" / "3시간 전". */
export function timeAgo(iso: string, locale: string, justNow: string): string {
  const mins = Math.floor((Date.now() - new Date(iso).getTime()) / 60000);
  if (mins < 1) return justNow;
  const format = new Intl.RelativeTimeFormat(locale, { numeric: 'auto', style: 'short' });
  if (mins < 60) return format.format(-mins, 'minute');
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return format.format(-hrs, 'hour');
  return format.format(-Math.floor(hrs / 24), 'day');
}

/** A date in the UI language, e.g. "Oct 27, 2026" / "2026년 10월 27일". */
export function formatDate(iso: string, locale: string, withTime = false): string {
  return new Date(iso).toLocaleString(locale, {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    ...(withTime ? { hour: '2-digit', minute: '2-digit' } : {}),
  });
}

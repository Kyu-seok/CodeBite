import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { getReviewStats } from "@/api/reviews";

export function ReviewStreakPill() {
  const [streak, setStreak] = useState(0);
  const [longest, setLongest] = useState(0);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    getReviewStats()
      .then((res) => {
        setStreak(res.data.currentStreak);
        setLongest(res.data.longestStreak);
      })
      .catch(() => {})
      .finally(() => setLoaded(true));
  }, []);

  // Hide entirely until we know there's a streak — avoids a layout flash and
  // a misleading "0 day streak" pill before user has done anything.
  if (!loaded || streak === 0) return null;

  return (
    <Link
      to="/reviews"
      title={`Longest streak: ${longest}d`}
      className="inline-flex items-center gap-1.5 rounded-full border border-warning-500/40 bg-warning-500/10 px-3 py-1 text-xs font-medium text-warning-500 transition-colors hover:bg-warning-500/15"
    >
      <span aria-hidden>🔥</span>
      <span className="tabular-nums">{streak}d review streak</span>
    </Link>
  );
}

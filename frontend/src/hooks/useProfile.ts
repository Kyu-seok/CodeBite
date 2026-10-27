import { useCallback, useEffect, useState } from "react";
import {
  getProfileStats,
  getActivity,
  getTagProficiency,
} from "../api/profile";
import { STREAK_CHANGED_EVENT } from "../api/streak";
import type {
  ProfileStats,
  ActivityDay,
  TagProficiency,
} from "../types/profile";

/** A part of the profile whose request failed, so its card shows an error instead of empty data. */
export type ProfileSection = "stats" | "activity" | "tags";

export function useProfile() {
  const [stats, setStats] = useState<ProfileStats | null>(null);
  const [activity, setActivity] = useState<ActivityDay[]>([]);
  const [tagProficiency, setTagProficiency] = useState<TagProficiency[]>([]);
  const [failed, setFailed] = useState<ReadonlySet<ProfileSection>>(new Set());
  const [loading, setLoading] = useState(true);

  // Each request settles on its own: a failed tag request shouldn't take the whole page down.
  const fetchAll = useCallback(() => {
    Promise.allSettled([getProfileStats(), getActivity(), getTagProficiency()])
      .then(([s, a, t]) => {
        const next = new Set<ProfileSection>();
        if (s.status === "fulfilled") setStats(s.value.data);
        else next.add("stats");
        if (a.status === "fulfilled") setActivity(a.value.data);
        else next.add("activity");
        if (t.status === "fulfilled") setTagProficiency(t.value.data);
        else next.add("tags");
        setFailed(next);
      })
      .finally(() => setLoading(false));
  }, []);

  useEffect(fetchAll, [fetchAll]);

  const reload = useCallback(() => {
    setLoading(true);
    fetchAll();
  }, [fetchAll]);

  // A Repair changes the header's current and best Streak.
  useEffect(() => {
    const refreshStats = () => {
      getProfileStats().then((s) => setStats(s.data)).catch(() => {});
    };
    window.addEventListener(STREAK_CHANGED_EVENT, refreshStats);
    return () => window.removeEventListener(STREAK_CHANGED_EVENT, refreshStats);
  }, []);

  return { stats, activity, tagProficiency, failed, loading, reload };
}

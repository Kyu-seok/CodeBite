import { useEffect, useState } from "react";
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

export function useProfile() {
  const [stats, setStats] = useState<ProfileStats | null>(null);
  const [activity, setActivity] = useState<ActivityDay[]>([]);
  const [tagProficiency, setTagProficiency] = useState<TagProficiency[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    Promise.all([getProfileStats(), getActivity(), getTagProficiency()])
      .then(([s, a, t]) => {
        setStats(s.data);
        setActivity(a.data);
        setTagProficiency(t.data);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, []);

  // A Repair changes the header's current and best Streak.
  useEffect(() => {
    const refreshStats = () => {
      getProfileStats().then((s) => setStats(s.data)).catch(() => {});
    };
    window.addEventListener(STREAK_CHANGED_EVENT, refreshStats);
    return () => window.removeEventListener(STREAK_CHANGED_EVENT, refreshStats);
  }, []);

  return { stats, activity, tagProficiency, loading };
}

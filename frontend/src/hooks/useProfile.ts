import { useEffect, useState } from "react";
import {
  getProfileStats,
  getActivity,
  getTagProficiency,
} from "../api/profile";
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

  return { stats, activity, tagProficiency, loading };
}

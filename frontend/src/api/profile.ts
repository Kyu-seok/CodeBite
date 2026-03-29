import client from "./client";
import type {
  ProfileStats,
  ActivityDay,
  TagProficiency,
  RecentSubmission,
} from "../types/profile";

export function getProfileStats() {
  return client.get<ProfileStats>("/profile/stats");
}

export function getActivity(months = 12) {
  return client.get<ActivityDay[]>("/profile/activity", {
    params: { months },
  });
}

export function getTagProficiency() {
  return client.get<TagProficiency[]>("/profile/tag-proficiency");
}

export function getRecentSubmissions(page = 0, size = 10) {
  return client.get<{ content: RecentSubmission[]; totalPages: number }>(
    "/profile/recent-submissions",
    { params: { page, size } },
  );
}

import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { badgeDueWording, dueDateLabel, dueWording, lastReviewedWording } from "./dueWording";

const HOUR = 3_600_000;
const at = (iso: string) => new Date(iso).getTime();

describe("dueWording", () => {
  it("reads due now once the due time has passed but no whole day is overdue", () => {
    const now = at("2026-10-28T15:00:00Z");
    expect(dueWording("2026-10-28T14:00:00Z", 0, now, "en")).toEqual({ key: "dueReviews.dueNow" });
  });

  // Guards against 24-hour-block maths: Math.ceil((due - now) / DAY_MS) would say "tomorrow" here.
  it("reads today when the due time is later on the same UTC day", () => {
    const now = at("2026-10-28T01:00:00Z");
    expect(dueWording("2026-10-28T23:00:00Z", 0, now, "en")).toEqual({
      key: "dueReviews.due",
      when: "today",
    });
  });

  it("reads tomorrow when the due time falls on the next UTC day", () => {
    const now = at("2026-10-28T12:00:00Z");
    expect(dueWording("2026-10-29T12:00:00Z", 0, now, "en")).toEqual({
      key: "dueReviews.due",
      when: "tomorrow",
    });
  });

  // Guards against 24-hour-block maths: Math.floor((due - now) / DAY_MS) would say "tomorrow" here.
  it("reads in 2 days, not tomorrow, for something due 47 hours away two UTC days on", () => {
    const now = at("2026-10-28T23:00:00Z");
    const due = new Date(now + 47 * HOUR).toISOString(); // 2026-10-30T22:00Z
    expect(dueWording(due, 0, now, "en")).toEqual({ key: "dueReviews.due", when: "in 2 days" });
  });

  it("counts whole UTC days, not 24-hour blocks from now", () => {
    // Guards against 24-hour-block maths: two hours away but past UTC midnight, so
    // Math.floor((due - now) / DAY_MS) would say "today".
    const now = at("2026-10-28T23:00:00Z");
    expect(dueWording("2026-10-29T01:00:00Z", 0, now, "en")).toEqual({
      key: "dueReviews.due",
      when: "tomorrow",
    });
  });

  it("reads N days overdue when the server counts whole days overdue", () => {
    const now = at("2026-10-28T12:00:00Z");
    expect(dueWording("2026-10-25T09:00:00Z", 3, now, "en")).toEqual({
      key: "dueReviews.overdue",
      count: 3,
    });
  });
});

describe("badgeDueWording", () => {
  const DAY = 24 * HOUR;

  // The bug in #137: 24-hour blocks from now said "in 1 day" right after a 2-day rating.
  it.each([
    ["2026-10-28T00:30:00Z"],
    ["2026-10-28T12:00:00Z"],
    ["2026-10-28T23:30:00Z"],
  ])("reads in N days right after rating with interval N, at any hour (%s)", (ratedAt) => {
    const now = at(ratedAt);
    expect(badgeDueWording(new Date(now + 2 * DAY).toISOString(), 0, now)).toEqual({
      key: "review.badge.dueIn",
      count: 2,
    });
    expect(badgeDueWording(new Date(now + 7 * DAY).toISOString(), 0, now)).toEqual({
      key: "review.badge.dueIn",
      count: 7,
    });
    expect(badgeDueWording(new Date(now + DAY).toISOString(), 0, now)).toEqual({
      key: "review.badge.dueTomorrow",
    });
  });

  it("reads today, not due now, for a due time later on the same UTC day", () => {
    const now = at("2026-10-28T01:00:00Z");
    expect(badgeDueWording("2026-10-28T23:00:00Z", 0, now)).toEqual({ key: "review.badge.dueToday" });
  });

  it("reads due now only once the due time has passed", () => {
    const now = at("2026-10-28T15:00:00Z");
    expect(badgeDueWording("2026-10-28T15:00:00Z", 0, now)).toEqual({ key: "review.badge.dueNow" });
    expect(badgeDueWording("2026-10-27T23:00:00Z", 0, now)).toEqual({ key: "review.badge.dueNow" });
  });

  it("reads overdue by the server's whole-day count", () => {
    const now = at("2026-10-28T12:00:00Z");
    expect(badgeDueWording("2026-10-25T09:00:00Z", 3, now)).toEqual({
      key: "review.badge.overdue",
      count: 3,
    });
  });
});

describe("lastReviewedWording", () => {
  it("reads today for a review earlier on the same UTC day", () => {
    const now = at("2026-10-28T23:00:00Z");
    expect(lastReviewedWording("2026-10-28T00:10:00Z", now)).toEqual({ key: "review.badge.today" });
  });

  // Guards against 24-hour-block maths: two hours ago, so Math.floor would say "today".
  it("reads yesterday for a review at 23:00 UTC seen at 01:00 UTC the next day", () => {
    const now = at("2026-10-29T01:00:00Z");
    expect(lastReviewedWording("2026-10-28T23:00:00Z", now)).toEqual({ key: "review.badge.yesterday" });
  });

  it("reads N days ago by UTC calendar day", () => {
    const now = at("2026-10-29T01:00:00Z");
    expect(lastReviewedWording("2026-10-25T23:00:00Z", now)).toEqual({
      key: "review.badge.daysAgo",
      count: 4,
    });
  });

  it("reads months ago from 30 days on", () => {
    const now = at("2026-10-29T12:00:00Z");
    expect(lastReviewedWording("2026-09-29T12:00:00Z", now)).toEqual({
      key: "review.badge.monthsAgo",
      count: 1,
    });
    expect(lastReviewedWording("2026-08-29T12:00:00Z", now)).toEqual({
      key: "review.badge.monthsAgo",
      count: 2,
    });
  });
});

describe("dueDateLabel", () => {
  // Run as a browser in Korea would, so a label in the local zone fails here even when CI runs in UTC.
  beforeAll(() => {
    vi.stubEnv("TZ", "Asia/Seoul");
  });
  afterAll(() => {
    vi.unstubAllEnvs();
  });

  // In KST this moment is Nov 3, 02:57; the label must still name the UTC day the words count to.
  it("names the UTC calendar date of the due moment", () => {
    expect(dueDateLabel("2026-11-02T17:57:00Z", "en")).toBe("Mon, Nov 2");
    expect(dueDateLabel("2026-11-02T17:57:00Z", "ko")).toBe("11월 2일 (월)");
  });

  it("names the UTC date just before UTC midnight, whatever the browser's zone", () => {
    expect(dueDateLabel("2026-11-02T23:59:00Z", "en")).toBe("Mon, Nov 2");
  });
});

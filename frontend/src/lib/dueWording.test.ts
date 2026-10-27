import { describe, expect, it } from "vitest";
import { dueWording } from "./dueWording";

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

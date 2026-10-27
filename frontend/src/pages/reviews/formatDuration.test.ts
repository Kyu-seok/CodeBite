import { describe, expect, it } from "vitest";
import { formatDuration, formatSolveTime } from "./formatDuration";

const MINUTE = 60;
const HOUR = 3600;

describe("formatDuration (total solve time)", () => {
  it.each([
    ["zero", 0, "0m", "0분"],
    ["under a minute, rounded down", 45, "0m", "0분"],
    ["minutes alone under an hour", 48 * MINUTE + 59, "48m", "48분"],
    ["just under an hour", HOUR - 1, "59m", "59분"],
    ["exactly an hour, without 0 minutes", HOUR, "1h", "1시간"],
    ["hours and minutes over an hour", 19 * HOUR + 48 * MINUTE + 30, "19h 48m", "19시간 48분"],
    ["more than a day, still in hours", 25 * HOUR + MINUTE, "25h 1m", "25시간 1분"],
  ])("%s", (_case, seconds, en, ko) => {
    expect(formatDuration(seconds, "en")).toBe(en);
    expect(formatDuration(seconds, "ko")).toBe(ko);
  });
});

describe("formatSolveTime (a single solve)", () => {
  it.each([
    ["zero", 0, "0s", "0초"],
    ["seconds alone under a minute", 27, "27s", "27초"],
    ["exactly a minute, with 0 seconds", MINUTE, "1m 0s", "1분 0초"],
    ["minutes and seconds", 7 * MINUTE + 27, "7m 27s", "7분 27초"],
    ["over an hour, still in minutes", HOUR + 2 * MINUTE + 5, "62m 5s", "62분 5초"],
  ])("%s", (_case, seconds, en, ko) => {
    expect(formatSolveTime(seconds, "en")).toBe(en);
    expect(formatSolveTime(seconds, "ko")).toBe(ko);
  });
});

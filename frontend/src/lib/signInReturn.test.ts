import { describe, expect, it } from "vitest";
import {
  languageOnReturn,
  rememberReturn,
  returnTarget,
  submitReturnUrl,
  takeReturn,
  type ReturnStorage,
} from "./signInReturn";

function fakeStorage(): ReturnStorage {
  const items = new Map<string, string>();
  return {
    getItem: (key) => items.get(key) ?? null,
    setItem: (key, value) => void items.set(key, value),
    removeItem: (key) => void items.delete(key),
  };
}

describe("the way back from signing in at Submit", () => {
  it("comes back to the problem in the language the code was written in", () => {
    const url = submitReturnUrl("piggy-bank-total", "java");
    expect(url).toBe("/problems/piggy-bank-total?lang=java");
    expect(languageOnReturn(new URL(url, "http://x").search, ["python", "java"])).toBe("java");
  });

  it("names no language on a plain visit, or one the problem doesn't have", () => {
    expect(languageOnReturn("", ["python", "java"])).toBeNull();
    expect(languageOnReturn("?lang=cobol", ["python", "java"])).toBeNull();
  });
});

describe("the way back from signing in on any page", () => {
  it("comes back to the page with its query string", () => {
    const storage = fakeStorage();
    rememberReturn(returnTarget({ pathname: "/problems", search: "?tag=graph&difficulty=EASY" }), storage);
    expect(takeReturn(storage)).toBe("/problems?tag=graph&difficulty=EASY");
  });

  it("is followed once", () => {
    const storage = fakeStorage();
    rememberReturn("/reviews", storage);
    expect(takeReturn(storage)).toBe("/reviews");
    expect(takeReturn(storage)).toBeNull();
  });

  it("is nowhere when nothing was remembered", () => {
    expect(takeReturn(fakeStorage())).toBeNull();
  });
});

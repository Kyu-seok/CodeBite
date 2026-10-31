import { describe, expect, it } from "vitest";
import { languageOnReturn, submitReturnUrl } from "./signInReturn";

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

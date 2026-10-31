import { describe, expect, it } from "vitest";
import { markTipSeen, readSeenTips, type OnboardingStorage } from ".";

class MemoryStorage implements OnboardingStorage {
  items = new Map<string, string>();
  getItem(key: string) {
    return this.items.get(key) ?? null;
  }
  setItem(key: string, value: string) {
    this.items.set(key, value);
  }
}

const throwing: OnboardingStorage = {
  getItem: () => {
    throw new Error("storage disabled");
  },
  setItem: () => {
    throw new Error("storage disabled");
  },
};

describe("seen Tips", () => {
  it("remembers each dismissed Tip", () => {
    const storage = new MemoryStorage();
    markTipSeen(storage, "wrongAnswer");
    markTipSeen(storage, "firstAccepted");
    expect(readSeenTips(storage)).toEqual(new Set(["wrongAnswer", "firstAccepted"]));
  });

  it("has seen nothing in an empty storage", () => {
    expect(readSeenTips(new MemoryStorage())).toEqual(new Set());
  });

  it("has seen nothing when the storage throws, yet a dismissal holds for the session", () => {
    expect(readSeenTips(throwing)).toEqual(new Set());
    expect(markTipSeen(throwing, "compileError", new Set(["wrongAnswer"]))).toEqual(
      new Set(["wrongAnswer", "compileError"]),
    );
  });

  it("keeps what can be read from a garbled or foreign value", () => {
    const storage = new MemoryStorage();
    storage.items.set("onboarding-seen-tips", "{not json");
    expect(readSeenTips(storage)).toEqual(new Set());
    storage.items.set("onboarding-seen-tips", JSON.stringify({ wrongAnswer: true }));
    expect(readSeenTips(storage)).toEqual(new Set());
    storage.items.set("onboarding-seen-tips", JSON.stringify(["runtimeError", "aTipFromLater", 7]));
    expect(readSeenTips(storage)).toEqual(new Set(["runtimeError"]));
    markTipSeen(storage, "wrongAnswer");
    expect(readSeenTips(storage)).toEqual(new Set(["runtimeError", "wrongAnswer"]));
  });
});

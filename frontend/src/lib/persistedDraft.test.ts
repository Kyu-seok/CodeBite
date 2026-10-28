import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { DRAFT_DEBOUNCE_MS, createDraftWriter, readDraft, type DraftStorage } from "./persistedDraft";

class FakeStorage implements DraftStorage {
  items = new Map<string, string>();
  writes = 0;
  getItem(key: string) {
    return this.items.get(key) ?? null;
  }
  setItem(key: string, value: string) {
    this.writes += 1;
    this.items.set(key, value);
  }
}

const timers = {
  setTimeout: (fn: () => void, ms: number) => setTimeout(fn, ms),
  clearTimeout: (handle: unknown) => clearTimeout(handle as ReturnType<typeof setTimeout>),
};

describe("readDraft", () => {
  it("returns the stored draft", () => {
    const storage = new FakeStorage();
    storage.items.set("code-draft:two-sum", JSON.stringify({ python: "print(1)" }));
    expect(readDraft(storage, "code-draft:two-sum", {})).toEqual({ python: "print(1)" });
  });

  it("returns the initial value when nothing is stored", () => {
    expect(readDraft(new FakeStorage(), "code-draft:two-sum", { a: 1 })).toEqual({ a: 1 });
  });

  it("returns the initial value when the draft is unreadable", () => {
    const storage = new FakeStorage();
    storage.items.set("custom-tests:two-sum", "{not json");
    expect(readDraft(storage, "custom-tests:two-sum", [])).toEqual([]);
    const broken: DraftStorage = {
      getItem: () => {
        throw new Error("storage disabled");
      },
      setItem: () => {},
    };
    expect(readDraft(broken, "custom-tests:two-sum", [])).toEqual([]);
  });
});

describe("createDraftWriter", () => {
  let storage: FakeStorage;

  beforeEach(() => {
    vi.useFakeTimers();
    storage = new FakeStorage();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  it("writes the latest value once the debounce has passed", () => {
    const writer = createDraftWriter<string>(storage, "k", timers);
    writer.schedule("a");
    writer.schedule("ab");
    vi.advanceTimersByTime(DRAFT_DEBOUNCE_MS - 1);
    expect(storage.writes).toBe(0);
    vi.advanceTimersByTime(1);
    expect(storage.writes).toBe(1);
    expect(storage.items.get("k")).toBe(JSON.stringify("ab"));
  });

  it("restarts the debounce on every schedule", () => {
    const writer = createDraftWriter<string>(storage, "k", timers);
    writer.schedule("a");
    vi.advanceTimersByTime(DRAFT_DEBOUNCE_MS - 1);
    writer.schedule("ab");
    vi.advanceTimersByTime(DRAFT_DEBOUNCE_MS - 1);
    expect(storage.writes).toBe(0);
    vi.advanceTimersByTime(1);
    expect(storage.items.get("k")).toBe(JSON.stringify("ab"));
  });

  it("flush writes the latest value at once and drops the pending write", () => {
    const writer = createDraftWriter<string[]>(storage, "k", timers);
    writer.schedule(["x"]);
    writer.flush();
    expect(storage.items.get("k")).toBe(JSON.stringify(["x"]));
    expect(storage.writes).toBe(1);
    vi.advanceTimersByTime(DRAFT_DEBOUNCE_MS);
    expect(storage.writes).toBe(1);
    expect(vi.getTimerCount()).toBe(0);
  });

  it("flush with nothing scheduled writes nothing", () => {
    createDraftWriter<string>(storage, "k", timers).flush();
    expect(storage.writes).toBe(0);
  });

  it("swallows a storage that refuses the write", () => {
    const full: DraftStorage = {
      getItem: () => null,
      setItem: () => {
        throw new Error("QuotaExceededError");
      },
    };
    const writer = createDraftWriter<string>(full, "k", timers);
    writer.schedule("a");
    expect(() => vi.advanceTimersByTime(DRAFT_DEBOUNCE_MS)).not.toThrow();
    expect(() => writer.flush()).not.toThrow();
  });
});

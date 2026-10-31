import { describe, expect, it } from "vitest";
import {
  NOT_STARTED,
  milestoneToReport,
  tutorialMilestone,
  tutorialStep,
  type OnboardingStorage,
  type TutorialEvent,
  type TutorialState,
} from ".";

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

const at = (step: Extract<TutorialState, { status: "active" }>["step"]): TutorialState => ({ status: "active", step });

/** The milestone `event` reaches from `before`, moving the Tutorial as the app does. */
const reached = (before: TutorialState, event: TutorialEvent) => tutorialMilestone(before, event, tutorialStep(before, event));

describe("tutorialMilestone", () => {
  it("is started whenever the Tutorial is (re)started", () => {
    expect(reached(NOT_STARTED, { type: "replayed" })).toBe("started");
    expect(reached({ status: "finished" }, { type: "replayed" })).toBe("started");
    expect(reached(at("submit"), { type: "replayed" })).toBe("started");
  });

  it("is ran on a Run during the Tutorial, passing or failing", () => {
    expect(reached(at("run"), { type: "ran", passed: false })).toBe("ran");
    expect(reached(at("read"), { type: "ran", passed: true })).toBe("ran");
  });

  it("is submitted on a Submit during the Tutorial", () => {
    expect(reached(at("submit"), { type: "submitted" })).toBe("submitted");
    expect(reached(at("read"), { type: "submitted" })).toBe("submitted");
  });

  it("is accepted when the Tutorial reaches its celebration", () => {
    expect(reached(at("submit"), { type: "accepted" })).toBe("accepted");
  });

  it("is skipped when the Tutorial is closed before the celebration, not after it", () => {
    expect(reached(at("run"), { type: "skipped" })).toBe("skipped");
    expect(reached(at("accepted"), { type: "skipped" })).toBeNull();
  });

  it("is nothing for reading and editing", () => {
    expect(reached(at("read"), { type: "read" })).toBeNull();
    expect(reached(at("function"), { type: "edited" })).toBeNull();
  });

  it("is nothing once the Tutorial is not running, or after its celebration", () => {
    for (const before of [NOT_STARTED, { status: "skipped" } as const, { status: "finished" } as const]) {
      expect(reached(before, { type: "ran", passed: true })).toBeNull();
      expect(reached(before, { type: "submitted" })).toBeNull();
      expect(reached(before, { type: "accepted" })).toBeNull();
      expect(reached(before, { type: "skipped" })).toBeNull();
    }
    expect(reached(at("accepted"), { type: "ran", passed: true })).toBeNull();
    expect(reached(at("accepted"), { type: "submitted" })).toBeNull();
    expect(reached(at("accepted"), { type: "accepted" })).toBeNull();
  });
});

describe("milestoneToReport", () => {
  const report = (storage: OnboardingStorage, before: TutorialState, event: TutorialEvent) =>
    milestoneToReport(storage, before, event, tutorialStep(before, event));

  it("reports each milestone once per run of the Tutorial", () => {
    const storage = new MemoryStorage();
    expect(report(storage, NOT_STARTED, { type: "replayed" })).toBe("started");
    expect(report(storage, at("run"), { type: "ran", passed: false })).toBe("ran");
    expect(report(storage, at("readFailure"), { type: "ran", passed: true })).toBeNull();
    expect(report(storage, at("submit"), { type: "submitted" })).toBe("submitted");
    expect(report(storage, at("submit"), { type: "submitted" })).toBeNull();
    expect(report(storage, at("submit"), { type: "accepted" })).toBe("accepted");
  });

  it("reports them again once the Tutorial is restarted", () => {
    const storage = new MemoryStorage();
    report(storage, NOT_STARTED, { type: "replayed" });
    report(storage, at("submit"), { type: "submitted" });

    expect(report(storage, { status: "skipped" }, { type: "replayed" })).toBe("started");
    expect(report(storage, at("submit"), { type: "submitted" })).toBe("submitted");
  });

  it("keeps what it reported across page loads", () => {
    const storage = new MemoryStorage();
    report(storage, at("submit"), { type: "submitted" });

    expect(report(new MemoryStorage(), at("submit"), { type: "submitted" })).toBe("submitted");
    expect(report(storage, at("submit"), { type: "submitted" })).toBeNull();
  });

  it("still reports when storage throws", () => {
    expect(report(throwing, at("submit"), { type: "submitted" })).toBe("submitted");
  });
});

import { describe, expect, it } from "vitest";
import { advanceTutorial, NOT_STARTED, readTutorial, tutorialStep, type OnboardingStorage, type TutorialState } from ".";

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

describe("tutorialStep", () => {
  it("starts at step 1 when replayed", () => {
    expect(tutorialStep(NOT_STARTED, { type: "replayed" })).toEqual(at("read"));
  });

  it("moves past each reading step when the user has read it", () => {
    expect(tutorialStep(at("read"), { type: "read" })).toEqual(at("function"));
    expect(tutorialStep(at("function"), { type: "read" })).toEqual(at("run"));
  });

  it("shows the function step before anything else once the user edits, runs or submits at step 1", () => {
    expect(tutorialStep(at("read"), { type: "edited" })).toEqual(at("function"));
    expect(tutorialStep(at("read"), { type: "ran", passed: false })).toEqual(at("function"));
    expect(tutorialStep(at("read"), { type: "ran", passed: true })).toEqual(at("function"));
    expect(tutorialStep(at("read"), { type: "submitted" })).toEqual(at("function"));
  });

  it("goes to Run once the user edits the code at the function step", () => {
    expect(tutorialStep(at("function"), { type: "edited" })).toEqual(at("run"));
  });

  it("shows how to read a failure when a Run fails", () => {
    expect(tutorialStep(at("run"), { type: "ran", passed: false })).toEqual(at("readFailure"));
  });

  it("skips reading a failure when the first Run passes", () => {
    expect(tutorialStep(at("run"), { type: "ran", passed: true })).toEqual(at("submit"));
  });

  it("moves on to Submit once a Run after a failure passes, and stays while Runs keep failing", () => {
    expect(tutorialStep(at("readFailure"), { type: "ran", passed: false })).toEqual(at("readFailure"));
    expect(tutorialStep(at("readFailure"), { type: "ran", passed: true })).toEqual(at("submit"));
  });

  it("takes a Run made at the function step as the Run step", () => {
    expect(tutorialStep(at("function"), { type: "ran", passed: false })).toEqual(at("readFailure"));
    expect(tutorialStep(at("function"), { type: "ran", passed: true })).toEqual(at("submit"));
  });

  it("does not go back to an earlier step on a later Run", () => {
    expect(tutorialStep(at("submit"), { type: "ran", passed: false })).toEqual(at("submit"));
    expect(tutorialStep(at("accepted"), { type: "ran", passed: false })).toEqual(at("accepted"));
  });

  it("goes to Submit when the user submits, even before Running", () => {
    expect(tutorialStep(at("run"), { type: "submitted" })).toEqual(at("submit"));
    expect(tutorialStep(at("function"), { type: "submitted" })).toEqual(at("submit"));
    expect(tutorialStep(at("submit"), { type: "submitted" })).toEqual(at("submit"));
  });

  it("celebrates at step 6 when a submission is Accepted", () => {
    expect(tutorialStep(at("submit"), { type: "accepted" })).toEqual(at("accepted"));
    expect(tutorialStep(at("readFailure"), { type: "accepted" })).toEqual(at("accepted"));
  });

  it.each(["read", "function", "run", "readFailure", "submit"] as const)("ends when skipped at %s", (step) => {
    expect(tutorialStep(at(step), { type: "skipped" })).toEqual({ status: "skipped" });
  });

  it("is finished, not skipped, when closed after the celebration", () => {
    expect(tutorialStep(at("accepted"), { type: "skipped" })).toEqual({ status: "finished" });
  });

  it("ignores what the user does while it is not running", () => {
    for (const state of [NOT_STARTED, { status: "skipped" }, { status: "finished" }] as TutorialState[]) {
      for (const event of [
        { type: "read" },
        { type: "edited" },
        { type: "ran", passed: true },
        { type: "submitted" },
        { type: "accepted" },
        { type: "skipped" },
      ] as const) {
        expect(tutorialStep(state, event)).toEqual(state);
      }
    }
  });

  it("restarts at step 1 when replayed, whether skipped, finished or part way", () => {
    expect(tutorialStep({ status: "skipped" }, { type: "replayed" })).toEqual(at("read"));
    expect(tutorialStep({ status: "finished" }, { type: "replayed" })).toEqual(at("read"));
    expect(tutorialStep(at("submit"), { type: "replayed" })).toEqual(at("read"));
  });
});

describe("the Tutorial in storage", () => {
  it("has not started in an empty storage", () => {
    expect(readTutorial(new MemoryStorage())).toEqual(NOT_STARTED);
  });

  it("keeps each step it advances to, so a reload or a sign-in resumes there", () => {
    const storage = new MemoryStorage();
    expect(advanceTutorial(storage, { type: "replayed" })).toEqual(at("read"));
    expect(advanceTutorial(storage, { type: "edited" })).toEqual(at("function"));
    expect(readTutorial(storage)).toEqual(at("function"));
    advanceTutorial(storage, { type: "skipped" });
    expect(readTutorial(storage)).toEqual({ status: "skipped" });
  });

  it("still advances for the page when the storage throws, and reads as not started", () => {
    expect(readTutorial(throwing)).toEqual(NOT_STARTED);
    expect(advanceTutorial(throwing, { type: "edited" }, at("function"))).toEqual(at("run"));
  });

  it("advances from what the page holds when the storage could not keep it", () => {
    const storage = new MemoryStorage();
    expect(advanceTutorial(storage, { type: "read" }, at("read"))).toEqual(at("function"));
  });

  it.each(["{not json", JSON.stringify({ status: "active", step: "aStepFromLater" }), JSON.stringify({ status: "lost" }), "7"])(
    "reads an unreadable value %j as not started",
    (value) => {
      const storage = new MemoryStorage();
      storage.items.set("onboarding-tutorial", value);
      expect(readTutorial(storage)).toEqual(NOT_STARTED);
    },
  );
});

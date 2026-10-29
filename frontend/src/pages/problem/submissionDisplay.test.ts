import { describe, expect, it } from "vitest";
import { problemLanguages } from "./submissionDisplay";

describe("problemLanguages", () => {
  it("is the starter code's languages in label order, whatever order the server sent", () => {
    const starterCode = { python: "", cpp: "", java: "", javascript: "" };
    expect(problemLanguages(starterCode)).toEqual(["python", "java", "javascript", "cpp"]);
  });

  it("puts Python first, so the editor defaults to it", () => {
    expect(problemLanguages({ cpp: "", java: "", python: "" })[0]).toBe("python");
  });

  it("offers only the languages the problem has", () => {
    expect(problemLanguages({ cpp: "", python: "" })).toEqual(["python", "cpp"]);
  });

  it("keeps a code it has no label for, after the known ones", () => {
    expect(problemLanguages({ rust: "", java: "" })).toEqual(["java", "rust"]);  });

  it("is empty for a problem with no starter code", () => {
    expect(problemLanguages({})).toEqual([]);
  });
});

import { describe, expect, it } from "vitest";
import { draftChanged, type SolutionDraft } from "./draftChanged";

const saved: SolutionDraft = {
  title: "Two pointers, one pass",
  content: "Walk inward from both ends until the pointers meet.",
  languages: ["java", "python"],
  tagSlugs: ["array", "two-pointers"],
};

describe("draftChanged", () => {
  it("is not a change when nothing was touched", () => {
    expect(draftChanged(saved, { ...saved })).toBe(false);
  });

  it("is not a change when a language is turned off and on again", () => {
    const off = saved.languages.filter((l) => l !== "java");
    expect(draftChanged(saved, { ...saved, languages: [...off, "java"] })).toBe(false);
  });

  it("is not a change when a tag is turned off and on again", () => {
    const off = saved.tagSlugs.filter((s) => s !== "array");
    expect(draftChanged(saved, { ...saved, tagSlugs: [...off, "array"] })).toBe(false);
  });

  it("is not a change when languages and tags are reordered", () => {
    expect(
      draftChanged(saved, {
        ...saved,
        languages: ["python", "java"],
        tagSlugs: ["two-pointers", "array"],
      }),
    ).toBe(false);
  });

  it("is a change when the title differs", () => {
    expect(draftChanged(saved, { ...saved, title: "Two pointers" })).toBe(true);
  });

  it("is a change when the content differs", () => {
    expect(draftChanged(saved, { ...saved, content: saved.content + " " })).toBe(true);
  });

  it("is a change when a language is added", () => {
    expect(draftChanged(saved, { ...saved, languages: ["java", "python", "cpp"] })).toBe(true);
  });

  it("is a change when a language is removed", () => {
    expect(draftChanged(saved, { ...saved, languages: ["python"] })).toBe(true);
  });

  it("is a change when one language is swapped for another", () => {
    expect(draftChanged(saved, { ...saved, languages: ["java", "cpp"] })).toBe(true);
  });

  it("is a change when the tag set differs", () => {
    expect(draftChanged(saved, { ...saved, tagSlugs: ["array"] })).toBe(true);
    expect(draftChanged(saved, { ...saved, tagSlugs: ["array", "hash-map"] })).toBe(true);
  });

  it("does not mix up languages and tags", () => {
    const a: SolutionDraft = { title: "t", content: "c", languages: ["java"], tagSlugs: [] };
    const b: SolutionDraft = { title: "t", content: "c", languages: [], tagSlugs: ["java"] };
    expect(draftChanged(a, b)).toBe(true);
  });
});

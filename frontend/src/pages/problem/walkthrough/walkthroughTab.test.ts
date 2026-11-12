import { describe, expect, it } from "vitest"
import {
  leftTabs,
  shownLeftTab,
  walkthroughLang,
  textIn,
  NO_WALKTHROUGH_YET,
  forProblem,
  revealed,
  stepped,
} from "./walkthroughTab"

describe("which tabs the problem's left panel shows", () => {
  it("adds Walkthrough after Solutions when the problem has one", () => {
    expect(leftTabs(true)).toEqual(["description", "submissions", "solutions", "walkthrough"])
  })

  it("shows no Walkthrough tab for a problem without one", () => {
    expect(leftTabs(false)).toEqual(["description", "submissions", "solutions"])
  })

  it("falls back to the description when the chosen tab isn't shown", () => {
    expect(shownLeftTab("walkthrough", false)).toBe("description")
    expect(shownLeftTab("walkthrough", true)).toBe("walkthrough")
    expect(shownLeftTab("solutions", false)).toBe("solutions")
  })
})

describe("the Walkthrough's place on the page", () => {
  it("starts hidden behind the reveal, on the first run", () => {
    const view = forProblem(NO_WALKTHROUGH_YET, "rotting-donuts")
    expect(view).toEqual({ slug: "rotting-donuts", revealed: false, run: 0, frame: 0 })
  })

  it("keeps the reveal and the step for the same problem, as across a tab switch", () => {
    const shown = stepped(revealed(forProblem(NO_WALKTHROUGH_YET, "rotting-donuts")), 2, 1)
    expect(forProblem(shown, "rotting-donuts")).toEqual({ slug: "rotting-donuts", revealed: true, run: 2, frame: 1 })
  })

  it("starts over on another problem", () => {
    const shown = stepped(revealed(forProblem(NO_WALKTHROUGH_YET, "rotting-donuts")), 2, 1)
    expect(forProblem(shown, "cheapest-courier-route")).toEqual({
      slug: "cheapest-courier-route",
      revealed: false,
      run: 0,
      frame: 0,
    })
  })
})

describe("a Walkthrough's text in the UI language", () => {
  it("reads the UI language's base code", () => {
    expect(walkthroughLang("ko")).toBe("ko")
    expect(walkthroughLang("ko-KR")).toBe("ko")
    expect(walkthroughLang("en-US")).toBe("en")
    expect(walkthroughLang(undefined)).toBe("en")
  })

  it("shows the language's text, falling back to English per field", () => {
    expect(textIn({ en: "Example 1", ko: "예시 1" }, "ko")).toBe("예시 1")
    expect(textIn({ en: "Example 1" }, "ko")).toBe("Example 1")
    expect(textIn({ en: "Example 1", ko: "" }, "ko")).toBe("Example 1")
    expect(textIn("plain", "ko")).toBe("plain")
    expect(textIn(undefined, "en")).toBe("")
  })
})

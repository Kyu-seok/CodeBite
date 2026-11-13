// The Walkthrough tab's decisions, free of React (docs/adr/0011): which left-panel tabs a problem
// shows, where the learner is in its Walkthrough while they move between tabs, and which language a
// Walkthrough shows in.

export type LeftTab = "description" | "submissions" | "solutions" | "walkthrough"

/** The left panel's tabs in order, in the desktop tab bar and the folded strip alike. */
export function leftTabs(hasWalkthrough: boolean): LeftTab[] {
  const tabs: LeftTab[] = ["description", "submissions", "solutions"]
  return hasWalkthrough ? [...tabs, "walkthrough"] : tabs
}

/** The tab to show for the chosen one: the description when the chosen tab isn't one this problem has. */
export function shownLeftTab(chosen: string, hasWalkthrough: boolean): string {
  return chosen === "walkthrough" && !hasWalkthrough ? "description" : chosen
}

/**
 * Where the learner is in a problem's Walkthrough: revealed or still behind "Show how it's solved",
 * and the run and frame the player shows. Kept by the page, so it survives switching tabs; nothing
 * is kept across visits.
 */
export interface WalkthroughPlace {
  slug: string | null
  revealed: boolean
  run: number
  frame: number
}

export const NO_WALKTHROUGH_YET: WalkthroughPlace = { slug: null, revealed: false, run: 0, frame: 0 }

/** The place for `slug`: the same one while the learner stays on that problem, else the start. */
export function forProblem(place: WalkthroughPlace, slug: string): WalkthroughPlace {
  return place.slug === slug ? place : { slug, revealed: false, run: 0, frame: 0 }
}

export function revealed(place: WalkthroughPlace): WalkthroughPlace {
  return { ...place, revealed: true }
}

export function stepped(place: WalkthroughPlace, run: number, frame: number): WalkthroughPlace {
  return { ...place, run, frame }
}

/**
 * The language a Walkthrough shows in, from the UI language ("ko-KR" reads as "ko"). The page reads
 * its Text fields with the player's own `textOf`, so the title and the frames pick a language alike.
 */
export function walkthroughLang(uiLanguage: string | undefined): string {
  return (uiLanguage ?? "en").split("-")[0] || "en"
}

---
name: CodeBite
description: A deliberate-practice algorithm trainer; quiet slate UI with one ember-orange accent.
colors:
  ink-slate: "#27384c"
  ink-slate-hover: "#31445b"
  ink-slate-soft: "#f1f4f8"
  ember-orange: "#fe7403"
  ember-orange-deep: "#ea6502"
  ember-orange-wash: "#ffedd5"
  ember-orange-text: "#c25005"
  paper: "#ffffff"
  ink: "#18212d"
  graphite: "#6b7685"
  mist: "#f1f3f6"
  hairline: "#e8ebef"
  night-ground: "#0f1318"
  night-surface: "#1a1f27"
  night-raised: "#272e39"
  night-ink: "#f1f3f6"
  night-graphite: "#a1aab6"
  pass-green: "#22c55e"
  pass-green-wash: "#dcfce7"
  pass-green-text: "#15803d"
  caution-amber: "#f59e0b"
  caution-amber-wash: "#fef3c7"
  caution-amber-text: "#b45309"
  fail-red: "#ef4444"
  fail-red-wash: "#fee2e2"
  fail-red-text: "#b91c1c"
typography:
  display:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "3rem"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.025em"
  headline:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.875rem"
    fontWeight: 700
    lineHeight: 1.2
    letterSpacing: "-0.025em"
  title:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.5rem"
    fontWeight: 700
    lineHeight: 1.33
  title-sm:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "1.125rem"
    fontWeight: 600
    lineHeight: 1
    letterSpacing: "-0.025em"
  body:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
    lineHeight: 1.43
  label:
    fontFamily: "Inter, ui-sans-serif, system-ui, sans-serif"
    fontSize: "0.75rem"
    fontWeight: 500
    lineHeight: 1.33
  mono:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, monospace"
    fontSize: "0.75rem"
    fontWeight: 400
    lineHeight: 1.33
    fontFeature: "\"tnum\""
rounded:
  sm: "4px"
  md: "6px"
  lg: "8px"
  xl: "12px"
  full: "9999px"
spacing:
  "1": "4px"
  "2": "8px"
  "3": "12px"
  "4": "16px"
  "6": "24px"
  "8": "32px"
  "12": "48px"
components:
  button-primary:
    backgroundColor: "{colors.ink-slate}"
    textColor: "{colors.ink-slate-soft}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "0 16px"
    height: "36px"
  button-primary-hover:
    backgroundColor: "{colors.ink-slate-hover}"
  button-accent:
    backgroundColor: "{colors.ember-orange-text}"
    textColor: "{colors.paper}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "0 16px"
    height: "36px"
  button-accent-hover:
    backgroundColor: "#9a3f0c"
  button-secondary:
    backgroundColor: "{colors.mist}"
    textColor: "{colors.ink-slate}"
    rounded: "{rounded.md}"
    padding: "0 16px"
    height: "36px"
  button-outline:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    rounded: "{rounded.md}"
    padding: "0 16px"
    height: "36px"
  input:
    backgroundColor: "transparent"
    textColor: "{colors.ink}"
    typography: "{typography.body}"
    rounded: "{rounded.md}"
    padding: "0 12px"
    height: "36px"
  card:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.lg}"
    padding: "24px"
  badge-easy:
    backgroundColor: "{colors.pass-green-wash}"
    textColor: "{colors.pass-green-text}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    padding: "2px 8px"
  badge-medium:
    backgroundColor: "{colors.caution-amber-wash}"
    textColor: "{colors.caution-amber-text}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    padding: "2px 8px"
  badge-hard:
    backgroundColor: "{colors.fail-red-wash}"
    textColor: "{colors.fail-red-text}"
    typography: "{typography.label}"
    rounded: "{rounded.md}"
    padding: "2px 8px"
  chip-tag:
    backgroundColor: "{colors.mist}"
    textColor: "{colors.ink-slate}"
    typography: "{typography.label}"
    rounded: "{rounded.full}"
    padding: "2px 10px"
  chip-tag-selected:
    backgroundColor: "{colors.ember-orange-text}"
    textColor: "{colors.paper}"
  nav-link:
    textColor: "{colors.graphite}"
    typography: "{typography.body}"
  nav-link-hover:
    textColor: "{colors.ink}"
---

# Design System: CodeBite

## Overview

**Creative North Star: "The Training Log"**

CodeBite looks like a disciplined practice notebook. The page is quiet and ruled: white paper, slate ink, hairline borders, rows of problems laid out like log entries. Nothing performs for attention, because the learner comes back every day for a focused session and the interface has to stay out of the way of the code. The one warm colour, Ember Orange, marks effort: what you just did, what is selected, what comes next.

The mood is calm, focused and earnest. Density is high where the learner works (problem tables, the three-pane workspace, profile cards at 12–14px text) and opens up only on the landing page, which gets larger type and a soft orange-tinted hero. Dark mode is a full peer, not an afterthought: the same structure on a near-black slate ground, with the accent unchanged.

The system explicitly rejects gamified arcade UI: no neon, no XP bars, no loud badges scattered for their own sake. Habit mechanics (Streaks, Repairs, heatmaps) are shown as quiet records of practice, not as rewards that shout.

**Key Characteristics:**
- Slate-navy ink on white paper; one ember-orange accent.
- Hairline borders define surfaces; shadows only whisper.
- Compact controls (32–40px tall), 12–14px working text.
- Semantic green / amber / red reserved for judging outcomes and difficulty.
- Inter for UI, JetBrains Mono for code, timers and numbers.
- Korean and English render with equal care in the same type stack.

## Colors

A restrained slate-and-paper palette with a single ember accent and a strictly semantic outcome trio.

### Primary
- **Ink Slate** (#27384c): the voice of the interface. Primary buttons, default badges, headings' authority in the palette ramp. In dark mode the role inverts: primary buttons become Ink Slate Soft (#f1f4f8) with Ink Slate text.
- **Ink Slate Hover** (#31445b): hover state for primary buttons.

### Secondary
- **Ember Orange** (#fe7403): the single accent and the focus ring colour (`--ring`). Used for the landing CTA, links, the accent headline word, roadmap highlights and the logo. Same value in light and dark.
- **Ember Orange Deep** (#ea6502): hover for accent buttons.
- **Ember Orange Wash** (#ffedd5) and **Ember Orange Text** (#c25005): the accent badge pairing and soft highlight backgrounds (hero tint, eyebrow tags).

### Tertiary (semantic outcomes)
- **Pass Green** (#22c55e, wash #dcfce7, text #15803d): Accepted, Easy, solved checkmarks, solved-row tint.
- **Caution Amber** (#f59e0b, wash #fef3c7, text #b45309): Medium, Time Limit Exceeded, Compilation Error, editor warnings.
- **Fail Red** (#ef4444, wash #fee2e2, text #b91c1c): Hard, Wrong Answer, Runtime Error, destructive actions, editor error squiggles.

### Neutral
- **Paper** (#ffffff): page background, cards, popovers in light mode.
- **Ink** (#18212d): body text and foreground.
- **Graphite** (#6b7685): muted text, nav links at rest, placeholders, table headers.
- **Mist** (#f1f3f6): secondary buttons, tab tracks, inline code, chip backgrounds, table header rows.
- **Hairline** (#e8ebef): every border and input stroke, scrollbar thumbs.
- **Night Ground** (#0f1318), **Night Surface** (#1a1f27), **Night Raised** (#272e39), **Night Ink** (#f1f3f6), **Night Graphite** (#a1aab6): the dark-mode equivalents of Paper, card, Mist/Hairline, Ink and Graphite.

### Named Rules
**The One Ember Rule.** Ember Orange is the only decorative colour. If something needs emphasis and is not a judging outcome, it gets orange or nothing.

**The Outcome-Only Rule.** Green, amber and red mean judging outcome or difficulty. Never use them for decoration, branding or generic emphasis.

**The Wash-and-Text Rule.** Status badges pair a 100-step wash with a 700-step text in light mode (950 wash / 400 text in dark); never a saturated fill with white text.

**The Readable Ember Rule.** White on Ember Orange (#fe7403) measures 2.7:1, so text never sits on it or is set in it. Accent buttons fill with Ember Orange Text (#c25005, 4.7:1 with white; hover #9a3f0c), and orange text on paper uses the same #c25005 (#fb923c on night). Selected tag chips, the Random button and the active page number follow the same rule; the active sort column header uses #9a3f0c, since #c25005 reaches only 4.2:1 on the Mist header row. Bright Ember stays for the logo, focus ring and non-text marks.

## Typography

**Display Font:** Inter (with ui-sans-serif, system-ui)
**Body Font:** Inter
**Label/Mono Font:** JetBrains Mono (with ui-monospace, SFMono-Regular)

**Character:** A neutral, highly legible sans that sits evenly next to Hangul, paired with a coding mono for anything the learner reads as data: code, timers, runtimes.

### Hierarchy
- **Display** (700, 2.25rem → 3rem at `sm`, line-height 1, tracking -0.025em): landing hero headline only.
- **Headline** (700, 1.875rem, tracking -0.025em): landing section heads.
- **Title** (700, 1.5rem): page titles in the app (`문제`, admin pages, solution pages).
- **Title Small** (600, 1.125rem, line-height 1, tracking -0.025em): card titles.
- **Body** (400–500, 0.875rem, line-height 1.43): the working size for tables, nav, buttons, descriptions. Problem descriptions use Tailwind Typography `prose`.
- **Label** (500, 0.75rem): badges, chips, small buttons, metadata. Text-xs and text-sm together carry most of the app's text.
- **Mono** (400–500, 0.75rem, tabular numerals): timers, runtimes, memory, code in the editor and inline code.

### Named Rules
**The Working Size Rule.** In app surfaces, text lives at 12–14px. Larger sizes are reserved for page titles and the landing page.

**The Numbers Are Data Rule.** Durations, counts that tick and code use JetBrains Mono with tabular numerals.

## Layout

App pages sit in a centred container (`max-w-6xl`, 1152px for the nav; content often `max-w-5xl`) with 16px gutters on mobile and 24px from `sm` up. The sticky top nav is 56px tall on a blurred, 80%-opaque background with a bottom hairline. The problem workspace breaks out to full width with resizable, collapsible panels (description · editor · results). Dialogs cap at `max-w-lg`; auth and empty-state forms at `max-w-md`/`max-w-sm`.

Spacing follows Tailwind's 4px scale. Cards pad 24px; table rows and controls are tight (8–12px). Breakpoints are Tailwind defaults (`sm` 640, `md` 768, `lg` 1024, `xl` 1280); `sm` and `lg` do most of the work.

## Elevation & Depth

Border-first, shadows whisper. Surfaces are separated by Hairline borders and tonal steps (Paper → Mist), not by lift. Shadows are short and soft and used mainly for floating layers and the active tab pill; resting cards carry at most the default 1–3px shadow.

### Shadow Vocabulary
- **Whisper** (`box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05)`): active tab trigger, small raised chips.
- **Rest** (`box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)`): default Card.
- **Float** (`box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`): dropdowns, tooltips, hover lift.
- **Modal** (`box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)`): dialogs over a 50% black overlay.

### Named Rules
**The Hairline First Rule.** Reach for a Hairline border before a shadow. A shadow larger than Float belongs only to something that floats over the page.

## Shapes

Gently rounded, never pill-heavy except for chips. Controls and badges use 6px corners; cards, dialogs, tab tracks and large buttons 8px; feature panels 12px. Fully round shapes are reserved for tag chips, avatars, toggles, progress bars and status dots. Borders are 1px Hairline everywhere.

## Components

### Buttons
Compact and dependable.
- **Shape:** gently rounded (6px; 8px on `lg`).
- **Sizes:** sm 32px / 12px text, md 36px / 14px (default), lg 40px with 24px padding, icon 36×36.
- **Primary:** Ink Slate fill, Ink Slate Soft text; inverted in dark mode.
- **Accent:** Ember Orange Text (#c25005) fill, white text (4.7:1; hover #9a3f0c, 6.8:1). The fill holds 3.5:1 against Night Surface, so it reads as a button in dark mode too. For the one action that matters most on a view: the landing CTA, and Submit in the problem workspace.
- **Secondary:** Mist fill, Ink Slate text (10.8:1; Night Raised with Night Ink in dark, 12.3:1). The companion to an accent button: Run sits beside Submit as a secondary slate button, never as an orange outline.
- **Outline / Ghost:** transparent with a Hairline border; transparent with a 10% foreground wash on hover. Icon-only ghost buttons always carry an `aria-label` matching their tooltip.
- **Destructive / Link:** red-600 (#dc2626) fill, white text; Ember Orange Text (#c25005) link text, underline on hover.
- **Hover / Focus:** colour transitions only; focus-visible shows a 2px Ember Orange ring offset by 2px. Disabled drops to 50% opacity.
- **Revealed controls:** panel controls that fade in on hover (fold, collapse, maximize) also appear when anything in their header receives focus, and stay visible on touch screens (`hover: none`), so a keyboard user always sees the button and its ring.

**The One CTA Rule.** A view gets at most one accent button. Every other button on it, including saving a note, sharing a solution or Run, is primary slate, secondary or ghost. In the problem workspace that one button is Submit; resize handles and other controls stay neutral too. Ember there is left only for the focus ring, text links and non-interactive marks (logo, progress spinner, avatars).

### Chips
- **Style:** tag filters are full pills, Mist with a Hairline border and 12px medium text.
- **State:** hover tints toward orange (10% wash, #9a3f0c text; #fb923c on night); selected is a solid Ember Orange Text (#c25005) fill with white text, and carries `aria-pressed`.

### Badges
- **Style:** 6px corners, 12px medium text, wash background with a deep text colour.
- **Mapping:** Easy → Pass Green, Medium → Caution Amber, Hard → Fail Red. Accepted → green; Wrong Answer and Runtime Error → red; TLE and Compilation Error → amber; Pending → Mist; Internal Error → outline.

### Cards / Containers
- **Corner Style:** 8px.
- **Background:** Paper / Night Surface.
- **Shadow Strategy:** Rest at most (see Elevation).
- **Border:** 1px Hairline.
- **Internal Padding:** 24px header and content.

### Inputs / Fields
- **Style:** transparent fill, 1px Hairline stroke, 6px corners, 36px tall by default (32 / 40 variants).
- **Focus:** 2px Ember Orange ring, 1px offset.
- **Disabled:** 50% opacity, not-allowed cursor.

### Tabs
Segmented: a Mist track (36px, 8px corners, 4px inset) holding triggers; the active trigger lifts onto Paper with the Whisper shadow.

### Navigation
Sticky 56px bar, logo left, 14px Graphite links that turn Ink on hover, language toggle, theme toggle and avatar on the right. In the workspace it also carries a mono solve timer in a bordered segmented control.

### Problem Table (signature)
A bordered, 8px-cornered table with a Mist header row and Hairline row dividers. Solved rows get a faint Pass Green tint and a green check; the active sort column header turns orange (#9a3f0c; #fb923c on night) with a chevron, and each sortable header is a button with `aria-sort` on its cell. Below `sm` the acceptance column drops and cells tighten so titles keep their width. Above it sits a progress strip: solved count plus a thin segmented bar in green / amber / red per difficulty.

## Do's and Don'ts

### Do:
- **Do** use the semantic CSS variables (`--background`, `--foreground`, `--muted`, `--border`, `--ring`) or the named ramps, so dark mode follows automatically.
- **Do** keep Ember Orange for the single most important action (one accent button per view), the current selection, and focus.
- **Do** build app surfaces at 12–14px text with compact 32–36px controls.
- **Do** put durations, runtimes and code in JetBrains Mono with tabular numerals.
- **Do** check every new surface in Korean and English and in both themes.

### Don't:
- **Don't** introduce gamified arcade styling: neon, XP bars, loud badges as decoration, or celebration beyond the single confetti burst on an Accepted submission.
- **Don't** use green, amber or red for anything other than judging outcomes, difficulty or destructive actions.
- **Don't** add a second accent colour or a gradient-heavy surface.
- **Don't** put two orange buttons side by side (an orange outline counts): pair the accent with a secondary slate button, as Run does with Submit.
- **Don't** use shadows larger than Float on anything that doesn't float above the page.
- **Don't** hard-code raw Tailwind greys (`text-gray-900`, `text-gray-300`); `LoginPage` and `NotFoundPage` still do and break in dark mode.

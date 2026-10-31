# The Tutorial draws its own spotlight

The Tutorial is shown as a spotlight with coach marks: the page is dimmed except for the element a step is about, and a short coach mark next to it says what to do. We draw that spotlight ourselves instead of using a product tour library. A tour library is mostly a step engine with Next and Back buttons, and the Tutorial already has its step engine (`tutorialStep`), whose steps advance on what the user does (edits, Runs, Submits, an Accepted), not on Next. With a library we would turn off its engine and its buttons and keep only the overlay, which is the smallest part: a dimmed layer with a cut-out around the target's box, kept in place as panels resize, and a coach mark positioned with floating-ui and styled with our own Tailwind tokens.

## Considered Options

- **React Joyride.** The best known; it can be driven from outside by step index, but it styles with inline style objects rather than our tokens and has lagged behind React majors, and we run React 19.
- **Driver.js.** Small and framework-free, a good spotlight; its popovers are DOM it builds itself, outside React and our components. The fallback if the overlay ever grows beyond what we want to maintain.
- **Shepherd.js.** Licensed AGPL with a commercial licence on the side.

## Consequences

Outside clicks are blocked while a step shows, but neither a click on the dimmed page nor Escape skips the Tutorial; only the coach mark's Skip does, so no stray click ends a newcomer's first solve. A step names every element it lets the user use (reading a failure needs both the result and the editor). Swapping in a library later means mapping these action-driven, multi-target steps onto its Next-driven model, which is why the choice is recorded here. The spotlight sits above the sticky header, so the header is dimmed with the rest of the page, and it steps aside whenever another dialog or popup is open (the Accepted modal, a confirmation, the language list), coming back when that closes.

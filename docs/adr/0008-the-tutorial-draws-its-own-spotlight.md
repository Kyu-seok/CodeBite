# The Tutorial draws its own spotlight

The Tutorial is shown as a spotlight with coach marks: the page is dimmed except for the element a step is about, and a short coach mark next to it says what to do. We draw that spotlight ourselves instead of using a product tour library. A tour library is mostly a step engine with Next and Back buttons, and the Tutorial already has its step engine (`tutorialStep`), whose steps advance on what the user does (edits, Runs, Submits, an Accepted), not on Next. With a library we would turn off its engine and its buttons and keep only the overlay, which is the smallest part: a dimmed layer with a cut-out around the target's box, kept in place as panels resize, and a coach mark positioned with floating-ui and styled with our own Tailwind tokens.

## Considered Options

- **React Joyride.** The best known; it can be driven from outside by step index, but it styles with inline style objects rather than our tokens and has lagged behind React majors, and we run React 19.
- **Driver.js.** Small and framework-free, a good spotlight; its popovers are DOM it builds itself, outside React and our components. The fallback if the overlay ever grows beyond what we want to maintain.
- **Shepherd.js.** Licensed AGPL with a commercial licence on the side.

## Consequences

Outside clicks are blocked while a step shows, but neither a click on the dimmed page nor Escape skips the Tutorial; only the coach mark's Skip does, so no stray click ends a newcomer's first solve. A step names every element it lets the user use (reading a failure needs both the result and the editor). Swapping in a library later means mapping these action-driven, multi-target steps onto its Next-driven model, which is why the choice is recorded here. The spotlight sits above the sticky header, so the header is dimmed with the rest of the page, and it steps aside whenever another dialog or popup is open (the Accepted modal, a confirmation, the language list), coming back when that closes.

Steps 3 and 5 light more than the one thing they point at, a deliberate departure from lighting only each step's target: step 3 lights the editor with Run, and step 5 lights Submit with the editor and the result, so a newcomer can keep fixing their code, or read the passing result, without leaving the step. Step 4 lights the first failed row of the result and the editor, and leaves the rest of the result usable but dimmed (scrolling to other cases, switching tabs); with no failed row on screen (after a reload, a Run the server refused, or with the Test Cases tab open) it lights the whole result.

The keyboard follows the same rule as the pointer: Tab and Shift+Tab cycle among the coach mark and what the step lets the user use, and Escape returns to the coach mark, except inside the editor, which keeps Escape (closing suggestions, Vim) and Tab (indenting). A keyboard user leaves the editor with Escape then Tab or Shift+Tab, or with Monaco's Tab-focus toggle (Ctrl+M, Ctrl+Shift+M on macOS); neither is named in the coach marks, whose copy stays short. Each step's title is announced through a polite live region the page keeps mounted, filled only while the step shows, so a step that appears after a panel opens or a modal closes is still announced.

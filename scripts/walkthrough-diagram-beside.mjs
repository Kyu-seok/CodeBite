// Decides walkthrough-app-check.mjs's side-by-side shot: a problem whose description draws Diagrams
// (fenced ```diagram-* blocks, as MarkdownRenderer draws them) gets one shot of those Diagrams next to the
// Walkthrough's first frame at 1440, so a reviewer sees whether a view matches the description's layout
// (docs/adr/0012); a description with none gets no shot. Pure, so the shell test checks it without Chrome.

const FENCE = /^ {0,3}(?:`{3,}|~{3,})[ \t]*(diagram-[\w-]+)/gm;

/** @returns {{ name: string, kinds: string[] } | null} the shot's file name (no .png) and the kinds, in order */
export function diagramBeside(slug, description) {
  const kinds = [...(description ?? '').matchAll(FENCE)].map(m => m[1]);
  return kinds.length ? { name: `${slug}-diagram-beside-frame-1440`, kinds } : null;
}

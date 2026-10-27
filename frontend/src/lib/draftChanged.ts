/** What the Solutions editor's form holds: the parts of a solution its author writes. */
export interface SolutionDraft {
  title: string;
  content: string;
  languages: string[];
  tagSlugs: string[];
}

/** Whether two lists hold the same items, in any order. */
function sameSet(a: string[], b: string[]): boolean {
  if (a.length !== b.length) return false;
  const sortedA = [...a].sort();
  const sortedB = [...b].sort();
  return sortedA.every((item, i) => item === sortedB[i]);
}

/**
 * Whether `draft` differs from `saved`. Languages and tags are sets, so turning one off and on
 * again, or reordering them, is not a change; a different title, content, language set or tag
 * set is.
 */
export function draftChanged(saved: SolutionDraft, draft: SolutionDraft): boolean {
  return (
    saved.title !== draft.title ||
    saved.content !== draft.content ||
    !sameSet(saved.languages, draft.languages) ||
    !sameSet(saved.tagSlugs, draft.tagSlugs)
  );
}

import { cFamilySource, declaredType, type CFamily } from './cFamily';
import { CPP_TYPES } from './cppMembers';
import { JAVA_STATICS, JAVA_TYPES } from './javaMembers';
import { UNKNOWN, pointee, typeRef, type Member, type TypeInfo, type TypeRef, type TypeTable } from './model';
import { boundType, pythonSource, redefinesClass, subscriptType } from './python';
import { PYTHON_MODULES, PYTHON_TYPES } from './pythonMembers';
import { indexType, lookup, stripCommentsAndStrings, trailingAccess } from './source';

export type { Member, MemberKind } from './model';

interface Language {
  readonly table: TypeTable;
  /** Members of a name nothing declares: Java's `Math`, Python's `heapq`. */
  readonly globals: Readonly<Record<string, readonly Member[]>>;
  readonly typeOf: (code: string, name: string, before: number) => TypeRef | undefined;
  /** The type of `x[subscript]` for an `x` of `type`. */
  readonly subscript: (type: TypeRef, subscript: string) => TypeRef;
  readonly stringLiteral: TypeRef;
  readonly python: boolean;
  /** C++ reaches a pointer's members with `->`. */
  readonly arrow: boolean;
  /** Whether the document defines its own `name`, whose members may not be the built-in ones. */
  readonly redefines: (document: string, name: string, builtin: readonly Member[]) => boolean;
}

const cFamily = (lang: CFamily, globals: Language['globals'], arrow: boolean): Language => ({
  table: lang.table,
  globals,
  typeOf: (code, name, before) => declaredType(lang, cFamilySource(lang, code), name, before),
  subscript: (type) => indexType(lang.table, type),
  stringLiteral: lang.stringLiteral,
  python: false,
  arrow,
  redefines: (document, name) => new RegExp(`\\b(?:class|struct)\\s+${name}\\b`).test(document),
});

const LANGUAGES: Readonly<Record<string, Language>> = {
  java: cFamily(
    { table: JAVA_TYPES, inferred: 'var', newKeyword: true, untypedLambdas: true, stringLiteral: typeRef('String') },
    JAVA_STATICS,
    false,
  ),
  cpp: cFamily(
    { table: CPP_TYPES, inferred: 'auto', newKeyword: false, untypedLambdas: false, stringLiteral: UNKNOWN },
    {},
    true,
  ),
  python: {
    table: PYTHON_TYPES,
    globals: PYTHON_MODULES,
    typeOf: (code, name, before) => boundType(pythonSource(code), name, before),
    subscript: subscriptType,
    stringLiteral: typeRef('str'),
    python: true,
    arrow: false,
    redefines: (document, name, builtin) =>
      redefinesClass(document, name, builtin.filter((m) => m.kind === 'field').map((m) => m.name)),
  },
};

/** The languages with member completion, by CodeBite language code (also the Monaco language id). */
export const MEMBER_COMPLETION_LANGUAGES = Object.keys(LANGUAGES);

/**
 * What to suggest when the code before the cursor ends in a member access (`a.`, `grid[i].si`,
 * `node->`): the members of the receiver's type, from its latest declaration in scope at the
 * cursor. Null when the text doesn't end in one, the cursor is in a comment or string, or the
 * type isn't one CodeBite knows, has no members (a C array), or is a class the document defines
 * itself (anywhere, so the text after the cursor counts too).
 */
export function memberCompletions(
  language: string,
  textBeforeCursor: string,
  textAfterCursor = '',
): readonly Member[] | null {
  const lang = lookup(LANGUAGES, language);
  if (!lang || !/(?:\.|->)\s*\w*$/.test(textBeforeCursor.slice(-128))) return null;
  const code = stripCommentsAndStrings(textBeforeCursor, lang.python);
  if (code === null) return null;
  const access = trailingAccess(code, lang.arrow);
  if (!access) return null;

  let type: TypeRef;
  if (access.receiver === 'string literal') {
    type = lang.stringLiteral;
  } else {
    const declared = lang.typeOf(code, access.receiver.name, access.receiver.start);
    if (!declared) return access.subscripts.length === 0 ? (lookup(lang.globals, access.receiver.name) ?? null) : null;
    type = declared;
  }
  for (const subscript of access.subscripts) type = lang.subscript(type, subscript);
  if (access.arrow) type = pointee(type);
  const members = lookup<TypeInfo>(lang.table, type.name)?.members;
  if (!members?.length) return null;
  const document = textAfterCursor
    ? (stripCommentsAndStrings(textBeforeCursor + textAfterCursor, lang.python) ?? code)
    : code;
  return /^\w+$/.test(type.name) && lang.redefines(document, type.name, members) ? null : members;
}

/**
 * What choosing a member types, as a Monaco snippet: `add($0)` leaves the cursor between the
 * parentheses, `size()` after them, and a field is its bare name.
 */
export function insertText(member: Member): string {
  if (member.kind === 'field' || member.kind === 'constant') return member.name;
  const params = /\(([^)]*)/.exec(member.signature)?.[1].trim();
  return params ? `${member.name}($0)` : `${member.name}()`;
}

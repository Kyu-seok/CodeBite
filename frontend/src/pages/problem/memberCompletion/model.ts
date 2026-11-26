export type MemberKind = 'method' | 'field' | 'function' | 'constant';

/** One suggestion after `receiver.`: `signature` is written as the language's own docs write it. */
export interface Member {
  readonly name: string;
  readonly kind: MemberKind;
  readonly signature: string;
  readonly doc?: string;
}

/** A type as far as completion needs it: `vector<vector<int>>` is vector of (vector of int). */
export interface TypeRef {
  readonly name: string;
  readonly args: readonly TypeRef[];
}

/** A type nothing is known about: every lookup on it misses, so it suggests nothing. */
export const UNKNOWN: TypeRef = { name: '', args: [] };

export const typeRef = (name: string, ...args: TypeRef[]): TypeRef => ({ name, args });

/** What a type offers: its members, what `x[i]` yields, and what iterating it yields. */
export interface TypeInfo {
  readonly members: readonly Member[];
  readonly index?: (args: readonly TypeRef[]) => TypeRef | undefined;
  readonly element?: (args: readonly TypeRef[]) => TypeRef | undefined;
}

export type TypeTable = Readonly<Record<string, TypeInfo>>;

/** `x[i]` or iterating `x` yields its `n`th type argument. */
export const arg = (n: number) => (args: readonly TypeRef[]) => args[n];
export const always = (type: TypeRef) => () => type;

type Spec = string | readonly [signature: string, doc: string];

/**
 * Members from their signatures. The name is the identifier before the first `(`; a field is
 * `name: type` (Python) or `type name` (Java, C++).
 */
export function members(kind: MemberKind, specs: readonly Spec[]): Member[] {
  return specs.map((spec) => {
    const [signature, doc] = typeof spec === 'string' ? [spec, undefined] : spec;
    const name =
      /(\w+)\s*\(/.exec(signature)?.[1] ?? /^(\w+):/.exec(signature)?.[1] ?? /(\w+)$/.exec(signature)![1];
    return doc ? { name, kind, signature, doc } : { name, kind, signature };
  });
}

/** One member list from several, each signature once: `TreeMap` is Map's members plus its own. */
export function combine(...lists: readonly (readonly Member[])[]): readonly Member[] {
  const seen = new Set<string>();
  return lists.flat().filter((m) => !seen.has(m.signature) && seen.add(m.signature));
}

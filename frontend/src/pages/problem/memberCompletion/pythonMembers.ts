import { always, arg, combine, members, override, typeRef, type Member, type TypeTable } from './model';

const LIST = members('method', [
  'append(x) -> None',
  'extend(iterable) -> None',
  'insert(i, x) -> None',
  ['remove(x) -> None', 'Removes the first item equal to x; ValueError if none.'],
  ['pop(i=-1)', 'Removes and returns the item at i, the last by default.'],
  'clear() -> None',
  'index(x, start=0, end=sys.maxsize) -> int',
  'count(x) -> int',
  'sort(*, key=None, reverse=False) -> None',
  'reverse() -> None',
  'copy() -> list',
]);

const DICT = members('method', [
  ['get(key, default=None)', 'The value for key, or default when key is missing.'],
  'items() -> dict_items',
  'keys() -> dict_keys',
  'values() -> dict_values',
  ['pop(key[, default])', 'Removes key and returns its value; KeyError when missing and no default.'],
  'popitem() -> tuple',
  ['setdefault(key, default=None)', 'The value for key, inserting default first when missing.'],
  'update([other]) -> None',
  'clear() -> None',
  'copy() -> dict',
]);

const SET = members('method', [
  'add(elem) -> None',
  ['remove(elem) -> None', 'KeyError when elem is missing; discard does not raise.'],
  'discard(elem) -> None',
  'pop()',
  'clear() -> None',
  'copy() -> set',
  'union(*others) -> set',
  'intersection(*others) -> set',
  'difference(*others) -> set',
  'symmetric_difference(other) -> set',
  'update(*others) -> None',
  'intersection_update(*others) -> None',
  'difference_update(*others) -> None',
  'issubset(other) -> bool',
  'issuperset(other) -> bool',
  'isdisjoint(other) -> bool',
]);

const STR = members('method', [
  'split(sep=None, maxsplit=-1) -> list[str]',
  'rsplit(sep=None, maxsplit=-1) -> list[str]',
  'splitlines(keepends=False) -> list[str]',
  'join(iterable) -> str',
  'strip(chars=None) -> str',
  'lstrip(chars=None) -> str',
  'rstrip(chars=None) -> str',
  'startswith(prefix[, start[, end]]) -> bool',
  'endswith(suffix[, start[, end]]) -> bool',
  ['find(sub[, start[, end]]) -> int', 'The lowest index of sub, or -1.'],
  'rfind(sub[, start[, end]]) -> int',
  ['index(sub[, start[, end]]) -> int', 'Like find, but raises ValueError when sub is missing.'],
  'rindex(sub[, start[, end]]) -> int',
  'count(sub[, start[, end]]) -> int',
  'replace(old, new, count=-1) -> str',
  'lower() -> str',
  'upper() -> str',
  'title() -> str',
  'capitalize() -> str',
  'swapcase() -> str',
  'isdigit() -> bool',
  'isalpha() -> bool',
  'isalnum() -> bool',
  'isspace() -> bool',
  'islower() -> bool',
  'isupper() -> bool',
  'isnumeric() -> bool',
  'zfill(width) -> str',
  'center(width, fillchar=" ") -> str',
  'ljust(width, fillchar=" ") -> str',
  'rjust(width, fillchar=" ") -> str',
  'partition(sep) -> tuple[str, str, str]',
  'rpartition(sep) -> tuple[str, str, str]',
  'removeprefix(prefix) -> str',
  'removesuffix(suffix) -> str',
  'format(*args, **kwargs) -> str',
  'encode(encoding="utf-8") -> bytes',
]);

const DEQUE = combine(
  members('method', [
    'append(x) -> None',
    'appendleft(x) -> None',
    'pop()',
    'popleft()',
    'extend(iterable) -> None',
    'extendleft(iterable) -> None',
    ['rotate(n=1) -> None', 'Rotates n steps to the right; negative n rotates left.'],
    'clear() -> None',
    'count(x) -> int',
    'index(x[, start[, stop]]) -> int',
    'insert(i, x) -> None',
    'remove(value) -> None',
    'reverse() -> None',
    'copy() -> deque',
  ]),
  members('field', ['maxlen: int | None']),
);

const COUNTER = combine(
  DICT,
  members('method', [
    ['most_common(n=None) -> list[tuple]', 'The n most common elements and their counts, most common first.'],
    'elements() -> Iterator',
    'subtract(iterable_or_mapping) -> None',
    'total() -> int',
  ]),
);

const DEFAULTDICT = combine(DICT, members('field', ['default_factory: Callable | None']));

const ORDERED_DICT = override(
  DICT,
  members('method', ['move_to_end(key, last=True) -> None', 'popitem(last=True) -> tuple']),
);

const TUPLE = members('method', ['count(x) -> int', 'index(x[, start[, end]]) -> int']);

const TREE_NODE = members('field', ['val: int', 'left: Optional[TreeNode]', 'right: Optional[TreeNode]']);
const LIST_NODE = members('field', ['val: int', 'next: Optional[ListNode]']);

const first = arg(0);
const second = arg(1);
const str = typeRef('str');

export const PYTHON_TYPES: TypeTable = {
  list: { members: LIST, index: first, element: first },
  dict: { members: DICT, index: second, element: first },
  set: { members: SET, element: first },
  frozenset: { members: SET.filter((m) => !m.signature.includes('-> None') && m.name !== 'pop'), element: first },
  str: { members: STR, index: always(str), element: always(str) },
  tuple: { members: TUPLE, index: first, element: first },
  deque: { members: DEQUE, index: first, element: first },
  Counter: { members: COUNTER, index: always(typeRef('int')), element: first },
  defaultdict: { members: DEFAULTDICT, index: second, element: first },
  OrderedDict: { members: ORDERED_DICT, index: second, element: first },
  TreeNode: { members: TREE_NODE },
  ListNode: { members: LIST_NODE },
};

/** Members of a module used as a receiver (`heapq.heappush`), when no variable has that name. */
export const PYTHON_MODULES: Readonly<Record<string, readonly Member[]>> = {
  heapq: members('function', [
    'heappush(heap, item) -> None',
    ['heappop(heap)', 'Pops the smallest item; heapq is a min-heap.'],
    'heapify(x) -> None',
    'heappushpop(heap, item)',
    'heapreplace(heap, item)',
    'nlargest(n, iterable, key=None) -> list',
    'nsmallest(n, iterable, key=None) -> list',
    'merge(*iterables, key=None, reverse=False) -> Iterator',
  ]),
  math: combine(
    members('constant', ['inf: float', 'pi: float', 'e: float', 'nan: float']),
    members('function', [
      'sqrt(x) -> float',
      'isqrt(n) -> int',
      'floor(x) -> int',
      'ceil(x) -> int',
      'trunc(x) -> int',
      'gcd(*integers) -> int',
      'lcm(*integers) -> int',
      'pow(x, y) -> float',
      'log(x[, base]) -> float',
      'log2(x) -> float',
      'log10(x) -> float',
      'exp(x) -> float',
      'factorial(n) -> int',
      'comb(n, k) -> int',
      'perm(n, k=None) -> int',
      'fabs(x) -> float',
      'hypot(*coordinates) -> float',
      'dist(p, q) -> float',
      'prod(iterable, *, start=1)',
      'fsum(iterable) -> float',
      'isclose(a, b, *, rel_tol=1e-09, abs_tol=0.0) -> bool',
      'isinf(x) -> bool',
      'isnan(x) -> bool',
      'copysign(x, y) -> float',
      'atan2(y, x) -> float',
      'degrees(x) -> float',
      'radians(x) -> float',
    ]),
  ),
  bisect: members('function', [
    ['bisect_left(a, x, lo=0, hi=len(a), *, key=None) -> int', 'The first index where x could go, keeping a sorted.'],
    ['bisect_right(a, x, lo=0, hi=len(a), *, key=None) -> int', 'The index after any items equal to x.'],
    'bisect(a, x, lo=0, hi=len(a), *, key=None) -> int',
    'insort_left(a, x, lo=0, hi=len(a), *, key=None) -> None',
    'insort_right(a, x, lo=0, hi=len(a), *, key=None) -> None',
    'insort(a, x, lo=0, hi=len(a), *, key=None) -> None',
  ]),
  collections: members('function', [
    'deque(iterable=(), maxlen=None)',
    'Counter(iterable_or_mapping=None, /, **kwds)',
    'defaultdict(default_factory=None, /, ...)',
    'OrderedDict(...)',
    'namedtuple(typename, field_names, *, rename=False, defaults=None, module=None)',
  ]),
  itertools: members('function', [
    'permutations(iterable, r=None)',
    'combinations(iterable, r)',
    'combinations_with_replacement(iterable, r)',
    'product(*iterables, repeat=1)',
    'accumulate(iterable, func=None, *, initial=None)',
    'chain(*iterables)',
    'groupby(iterable, key=None)',
    'count(start=0, step=1)',
    'cycle(iterable)',
    'repeat(object[, times])',
    'islice(iterable, stop)',
    'zip_longest(*iterables, fillvalue=None)',
    'pairwise(iterable)',
    'batched(iterable, n)',
    'starmap(function, iterable)',
    'takewhile(predicate, iterable)',
    'dropwhile(predicate, iterable)',
    'compress(data, selectors)',
    'filterfalse(predicate, iterable)',
    'tee(iterable, n=2)',
  ]),
};

import { arg, combine, members, type Member, type TypeTable } from './model';

const OBJECT = members('method', ['boolean equals(Object o)', 'int hashCode()', 'String toString()']);

const COLLECTION = combine(
  members('method', [
    'boolean add(E e)',
    'boolean addAll(Collection<? extends E> c)',
    'void clear()',
    'boolean contains(Object o)',
    'boolean containsAll(Collection<?> c)',
    'boolean isEmpty()',
    'Iterator<E> iterator()',
    'boolean remove(Object o)',
    'boolean removeAll(Collection<?> c)',
    'boolean removeIf(Predicate<? super E> filter)',
    'boolean retainAll(Collection<?> c)',
    'int size()',
    'Stream<E> stream()',
    'Object[] toArray()',
    'void forEach(Consumer<? super E> action)',
  ]),
  OBJECT,
);

const LIST = combine(
  COLLECTION,
  members('method', [
    'void add(int index, E element)',
    'E get(int index)',
    'E set(int index, E element)',
    ['E remove(int index)', 'Removes by position; list.remove(Integer.valueOf(x)) removes a value.'],
    'int indexOf(Object o)',
    'int lastIndexOf(Object o)',
    'void sort(Comparator<? super E> c)',
    'List<E> subList(int fromIndex, int toIndex)',
    'void replaceAll(UnaryOperator<E> operator)',
    'ListIterator<E> listIterator()',
  ]),
);

const QUEUE = combine(
  COLLECTION,
  members('method', [
    'boolean offer(E e)',
    ['E poll()', 'Removes the head, or returns null when empty.'],
    ['E peek()', 'The head without removing it, or null when empty.'],
    ['E element()', 'The head without removing it; throws when empty.'],
    ['E remove()', 'Removes the head; throws when empty.'],
  ]),
);

const DEQUE = combine(
  QUEUE,
  members('method', [
    'void addFirst(E e)',
    'void addLast(E e)',
    'boolean offerFirst(E e)',
    'boolean offerLast(E e)',
    'E pollFirst()',
    'E pollLast()',
    'E peekFirst()',
    'E peekLast()',
    'E removeFirst()',
    'E removeLast()',
    'E getFirst()',
    'E getLast()',
    ['void push(E e)', 'Adds to the front, like addFirst.'],
    ['E pop()', 'Removes from the front, like removeFirst.'],
    'Iterator<E> descendingIterator()',
  ]),
);

const STACK = combine(
  LIST,
  members('method', [
    'E push(E item)',
    'E pop()',
    'E peek()',
    'boolean empty()',
    ['int search(Object o)', '1-based distance from the top, or -1.'],
  ]),
);

const PRIORITY_QUEUE = combine(QUEUE, members('method', ['Comparator<? super E> comparator()']));

const SET = COLLECTION;

const TREE_SET = combine(
  SET,
  members('method', [
    'E first()',
    'E last()',
    ['E floor(E e)', 'The greatest element <= e, or null.'],
    ['E ceiling(E e)', 'The least element >= e, or null.'],
    ['E lower(E e)', 'The greatest element < e, or null.'],
    ['E higher(E e)', 'The least element > e, or null.'],
    'E pollFirst()',
    'E pollLast()',
    'SortedSet<E> headSet(E toElement)',
    'SortedSet<E> tailSet(E fromElement)',
    'SortedSet<E> subSet(E fromElement, E toElement)',
    'NavigableSet<E> descendingSet()',
    'Iterator<E> descendingIterator()',
  ]),
);

const MAP = combine(
  members('method', [
    'V get(Object key)',
    'V getOrDefault(Object key, V defaultValue)',
    'V put(K key, V value)',
    'void putAll(Map<? extends K, ? extends V> m)',
    'V putIfAbsent(K key, V value)',
    'V remove(Object key)',
    'boolean containsKey(Object key)',
    'boolean containsValue(Object value)',
    'Set<K> keySet()',
    'Collection<V> values()',
    'Set<Map.Entry<K, V>> entrySet()',
    'int size()',
    'boolean isEmpty()',
    'void clear()',
    'V merge(K key, V value, BiFunction<? super V, ? super V, ? extends V> remappingFunction)',
    'V compute(K key, BiFunction<? super K, ? super V, ? extends V> remappingFunction)',
    'V computeIfAbsent(K key, Function<? super K, ? extends V> mappingFunction)',
    'V computeIfPresent(K key, BiFunction<? super K, ? super V, ? extends V> remappingFunction)',
    'V replace(K key, V value)',
    'void forEach(BiConsumer<? super K, ? super V> action)',
  ]),
  OBJECT,
);

const TREE_MAP = combine(
  MAP,
  members('method', [
    'K firstKey()',
    'K lastKey()',
    'Map.Entry<K, V> firstEntry()',
    'Map.Entry<K, V> lastEntry()',
    'Map.Entry<K, V> pollFirstEntry()',
    'Map.Entry<K, V> pollLastEntry()',
    ['K floorKey(K key)', 'The greatest key <= key, or null.'],
    ['K ceilingKey(K key)', 'The least key >= key, or null.'],
    ['K lowerKey(K key)', 'The greatest key < key, or null.'],
    ['K higherKey(K key)', 'The least key > key, or null.'],
    'Map.Entry<K, V> floorEntry(K key)',
    'Map.Entry<K, V> ceilingEntry(K key)',
    'Map.Entry<K, V> lowerEntry(K key)',
    'Map.Entry<K, V> higherEntry(K key)',
    'SortedMap<K, V> headMap(K toKey)',
    'SortedMap<K, V> tailMap(K fromKey)',
    'SortedMap<K, V> subMap(K fromKey, K toKey)',
    'NavigableMap<K, V> descendingMap()',
    'NavigableSet<K> navigableKeySet()',
    'NavigableSet<K> descendingKeySet()',
  ]),
);

const ENTRY = combine(members('method', ['K getKey()', 'V getValue()', 'V setValue(V value)']), OBJECT);

const STRING = combine(
  members('method', [
    'char charAt(int index)',
    'int length()',
    'boolean isEmpty()',
    'boolean isBlank()',
    'String substring(int beginIndex)',
    'String substring(int beginIndex, int endIndex)',
    'int indexOf(String str)',
    'int indexOf(int ch)',
    'int indexOf(String str, int fromIndex)',
    'int lastIndexOf(String str)',
    'int lastIndexOf(int ch)',
    'boolean contains(CharSequence s)',
    'boolean startsWith(String prefix)',
    'boolean endsWith(String suffix)',
    'boolean equalsIgnoreCase(String anotherString)',
    'int compareTo(String anotherString)',
    'char[] toCharArray()',
    'String toLowerCase()',
    'String toUpperCase()',
    'String trim()',
    'String strip()',
    'String[] split(String regex)',
    'String replace(CharSequence target, CharSequence replacement)',
    'String replace(char oldChar, char newChar)',
    'String replaceAll(String regex, String replacement)',
    'String repeat(int count)',
    'String concat(String str)',
    'boolean matches(String regex)',
    'IntStream chars()',
    'Stream<String> lines()',
  ]),
  OBJECT,
);

const STRING_BUILDER = members('method', [
  'StringBuilder append(Object obj)',
  'StringBuilder insert(int offset, Object obj)',
  'StringBuilder reverse()',
  'String toString()',
  'int length()',
  'char charAt(int index)',
  'void setCharAt(int index, char ch)',
  'StringBuilder deleteCharAt(int index)',
  ['StringBuilder delete(int start, int end)', 'Removes [start, end).'],
  'StringBuilder replace(int start, int end, String str)',
  'int indexOf(String str)',
  'int lastIndexOf(String str)',
  'String substring(int start)',
  'String substring(int start, int end)',
  'void setLength(int newLength)',
]);

const ARRAY = combine(members('field', ['int length']), members('method', ['T[] clone()']));

const TREE_NODE = members('field', ['int val', 'TreeNode left', 'TreeNode right']);
const LIST_NODE = members('field', ['int val', 'ListNode next']);

const first = arg(0);

export const JAVA_TYPES: TypeTable = {
  '[]': { members: ARRAY, index: first, element: first },
  String: { members: STRING },
  StringBuilder: { members: STRING_BUILDER },
  Collection: { members: COLLECTION, element: first },
  List: { members: LIST, element: first },
  ArrayList: { members: LIST, element: first },
  LinkedList: { members: combine(LIST, DEQUE), element: first },
  Queue: { members: QUEUE, element: first },
  Deque: { members: DEQUE, element: first },
  ArrayDeque: { members: DEQUE, element: first },
  Stack: { members: STACK, element: first },
  PriorityQueue: { members: PRIORITY_QUEUE, element: first },
  Set: { members: SET, element: first },
  HashSet: { members: SET, element: first },
  LinkedHashSet: { members: SET, element: first },
  TreeSet: { members: TREE_SET, element: first },
  Map: { members: MAP },
  HashMap: { members: MAP },
  LinkedHashMap: { members: MAP },
  TreeMap: { members: TREE_MAP },
  Entry: { members: ENTRY },
  TreeNode: { members: TREE_NODE },
  ListNode: { members: LIST_NODE },
};

const statics = (kind: 'method' | 'constant', specs: readonly string[]) =>
  members(kind, specs.map((s) => (kind === 'method' ? `static ${s}` : `static final ${s}`)));

const INTEGRAL_BOXES = (box: string, prim: string, parse: string): readonly Member[] =>
  combine(
    statics('constant', [`${prim} MAX_VALUE`, `${prim} MIN_VALUE`]),
    statics('method', [
      `${prim} ${parse}(String s)`,
      `${prim} ${parse}(String s, int radix)`,
      `${box} valueOf(${prim} i)`,
      `String toString(${prim} i)`,
      `String toString(${prim} i, int radix)`,
      `String toBinaryString(${prim} i)`,
      `int bitCount(${prim} i)`,
      `int compare(${prim} x, ${prim} y)`,
      `${prim} max(${prim} a, ${prim} b)`,
      `${prim} min(${prim} a, ${prim} b)`,
      `${prim} sum(${prim} a, ${prim} b)`,
      `${prim} highestOneBit(${prim} i)`,
      `${prim} lowestOneBit(${prim} i)`,
      `int numberOfLeadingZeros(${prim} i)`,
      `int numberOfTrailingZeros(${prim} i)`,
    ]),
  );

/** Members of a class name used as a receiver (`Math.max`), when no variable has that name. */
export const JAVA_STATICS: Readonly<Record<string, readonly Member[]>> = {
  Math: combine(
    statics('constant', ['double PI', 'double E']),
    statics('method', [
      'int max(int a, int b)',
      'int min(int a, int b)',
      'int abs(int a)',
      'double pow(double a, double b)',
      'double sqrt(double a)',
      'double cbrt(double a)',
      'double floor(double a)',
      'double ceil(double a)',
      'long round(double a)',
      'double log(double a)',
      'double log10(double a)',
      'double exp(double a)',
      'double hypot(double x, double y)',
      'double signum(double d)',
      'double random()',
      'int floorDiv(int x, int y)',
      'int floorMod(int x, int y)',
      'int addExact(int x, int y)',
      'int multiplyExact(int x, int y)',
      'int toIntExact(long value)',
    ]),
  ),
  Arrays: statics('method', [
    'void sort(int[] a)',
    'void sort(int[] a, int fromIndex, int toIndex)',
    'void sort(T[] a, Comparator<? super T> c)',
    'void fill(int[] a, int val)',
    'List<T> asList(T... a)',
    'String toString(int[] a)',
    'String deepToString(Object[] a)',
    'int[] copyOf(int[] original, int newLength)',
    'int[] copyOfRange(int[] original, int from, int to)',
    'boolean equals(int[] a, int[] a2)',
    'IntStream stream(int[] array)',
    'int binarySearch(int[] a, int key)',
  ]),
  Collections: statics('method', [
    'void sort(List<T> list)',
    'void sort(List<T> list, Comparator<? super T> c)',
    'void reverse(List<?> list)',
    'T max(Collection<? extends T> coll)',
    'T min(Collection<? extends T> coll)',
    'void swap(List<?> list, int i, int j)',
    'int frequency(Collection<?> c, Object o)',
    'List<T> nCopies(int n, T o)',
    'Comparator<T> reverseOrder()',
    'boolean addAll(Collection<? super T> c, T... elements)',
    'List<T> emptyList()',
    'List<T> singletonList(T o)',
    'List<T> unmodifiableList(List<? extends T> list)',
    'int binarySearch(List<? extends Comparable<? super T>> list, T key)',
    'void shuffle(List<?> list)',
  ]),
  Integer: INTEGRAL_BOXES('Integer', 'int', 'parseInt'),
  Long: INTEGRAL_BOXES('Long', 'long', 'parseLong'),
  Character: combine(
    statics('constant', ['char MAX_VALUE', 'char MIN_VALUE']),
    statics('method', [
      'boolean isDigit(char ch)',
      'boolean isLetter(char ch)',
      'boolean isLetterOrDigit(char ch)',
      'boolean isAlphabetic(int codePoint)',
      'boolean isUpperCase(char ch)',
      'boolean isLowerCase(char ch)',
      'boolean isWhitespace(char ch)',
      'char toUpperCase(char ch)',
      'char toLowerCase(char ch)',
      'int getNumericValue(char ch)',
      'Character valueOf(char c)',
      'String toString(char c)',
    ]),
  ),
  String: statics('method', [
    'String valueOf(Object obj)',
    'String valueOf(char[] data)',
    'String join(CharSequence delimiter, CharSequence... elements)',
    'String format(String format, Object... args)',
  ]),
};

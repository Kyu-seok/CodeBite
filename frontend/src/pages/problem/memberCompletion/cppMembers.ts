import { always, arg, combine, members, typeRef, type TypeRef, type TypeTable } from './model';

const ITERATORS = members('method', [
  'iterator begin()',
  'iterator end()',
  'reverse_iterator rbegin()',
  'reverse_iterator rend()',
]);

const SIZED = members('method', ['size_type size() const', 'bool empty() const', 'void clear()', 'void swap(other)']);

const SEQUENCE = combine(
  SIZED,
  ITERATORS,
  members('method', [
    'void push_back(const T& value)',
    'void emplace_back(Args&&... args)',
    'void pop_back()',
    'reference at(size_type pos)',
    'reference front()',
    'reference back()',
    'iterator insert(const_iterator pos, const T& value)',
    'iterator emplace(const_iterator pos, Args&&... args)',
    'iterator erase(const_iterator pos)',
    'iterator erase(const_iterator first, const_iterator last)',
    'void resize(size_type count, const T& value = T())',
    'void assign(size_type count, const T& value)',
    'void shrink_to_fit()',
  ]),
);

const VECTOR = combine(
  SEQUENCE,
  members('method', ['void reserve(size_type new_cap)', 'size_type capacity() const', 'T* data()']),
);

const DEQUE = combine(
  SEQUENCE,
  members('method', ['void push_front(const T& value)', 'void emplace_front(Args&&... args)', 'void pop_front()']),
);

const STRING = combine(
  SIZED,
  ITERATORS,
  members('method', [
    'size_type length() const',
    'void push_back(char ch)',
    'void pop_back()',
    'string& append(const string& str)',
    'string substr(size_type pos = 0, size_type count = npos) const',
    ['size_type find(const string& str, size_type pos = 0) const', 'The first index of str, or string::npos.'],
    'size_type rfind(const string& str, size_type pos = npos) const',
    'size_type find_first_of(const string& chars, size_type pos = 0) const',
    'size_type find_last_of(const string& chars, size_type pos = npos) const',
    'size_type find_first_not_of(const string& chars, size_type pos = 0) const',
    'int compare(const string& str) const',
    'const char* c_str() const',
    'char& at(size_type pos)',
    'char& front()',
    'char& back()',
    'string& insert(size_type index, const string& str)',
    'string& erase(size_type index = 0, size_type count = npos)',
    'string& replace(size_type pos, size_type count, const string& str)',
    'void resize(size_type count, char ch = char())',
    'void reserve(size_type new_cap)',
  ]),
);

const ASSOCIATIVE = combine(
  SIZED,
  members('method', [
    'iterator begin()',
    'iterator end()',
    'pair<iterator, bool> insert(const value_type& value)',
    'pair<iterator, bool> emplace(Args&&... args)',
    ['size_type erase(const key_type& key)', 'Removes every element with this key.'],
    'iterator erase(const_iterator pos)',
    ['iterator find(const key_type& key)', 'An iterator to the element, or end().'],
    ['size_type count(const key_type& key) const', '0 or 1, or how many in a multiset.'],
    'pair<iterator, iterator> equal_range(const key_type& key)',
  ]),
);

const ORDERED = combine(
  ASSOCIATIVE,
  members('method', [
    'reverse_iterator rbegin()',
    'reverse_iterator rend()',
    ['iterator lower_bound(const key_type& key)', 'The first element not less than key.'],
    ['iterator upper_bound(const key_type& key)', 'The first element greater than key.'],
  ]),
);

const HASHED = combine(
  ASSOCIATIVE,
  members('method', ['void reserve(size_type count)', 'size_type bucket_count() const', 'float load_factor() const']),
);

const MAPPED = members('method', ['T& at(const key_type& key)']);

const ADAPTER = members('method', [
  'void push(const T& value)',
  'void emplace(Args&&... args)',
  'void pop()',
  'size_type size() const',
  'bool empty() const',
  'void swap(other)',
]);

const QUEUE = combine(ADAPTER, members('method', ['reference front()', 'reference back()']));
const TOP = combine(ADAPTER, members('method', ['const_reference top() const']));

const PAIR = combine(members('field', ['T1 first', 'T2 second']), members('method', ['void swap(pair& other)']));

const TREE_NODE = members('field', ['int val', 'TreeNode* left', 'TreeNode* right']);
const LIST_NODE = members('field', ['int val', 'ListNode* next']);

const first = arg(0);
const second = arg(1);
const entry = (args: readonly TypeRef[]) => typeRef('pair', ...args);

export const CPP_TYPES: TypeTable = {
  string: { members: STRING, index: always(typeRef('char')), element: always(typeRef('char')) },
  vector: { members: VECTOR, index: first, element: first },
  deque: { members: DEQUE, index: first, element: first },
  map: { members: combine(ORDERED, MAPPED), index: second, element: entry },
  unordered_map: { members: combine(HASHED, MAPPED), index: second, element: entry },
  multimap: { members: ORDERED, element: entry },
  set: { members: ORDERED, element: first },
  multiset: { members: ORDERED, element: first },
  unordered_set: { members: HASHED, element: first },
  queue: { members: QUEUE },
  stack: { members: TOP },
  priority_queue: { members: TOP },
  pair: { members: PAIR },
  TreeNode: { members: TREE_NODE },
  ListNode: { members: LIST_NODE },
};


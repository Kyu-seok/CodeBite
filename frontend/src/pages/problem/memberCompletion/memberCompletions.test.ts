import { describe, expect, it } from 'vitest';
import { insertText, memberCompletions } from './memberCompletions';

/** The names suggested at the end of `code`, or null when nothing is. */
function suggested(language: string, code: string): string[] | null {
  return memberCompletions(language, code)?.map((m) => m.name) ?? null;
}

describe('Java', () => {
  it('suggests List methods after a list declared as List and built as ArrayList', () => {
    expect(suggested('java', 'List<Integer> a = new ArrayList<>(); a.')).toEqual(
      expect.arrayContaining(['add', 'clear', 'size', 'get', 'remove']),
    );
  });

  it('keeps suggesting while a member name is half typed', () => {
    expect(suggested('java', 'List<Integer> a = new ArrayList<>();\na.ad')).toContain('add');
  });

  it('reads parameters from a starter signature', () => {
    const starter = 'class Solution {\n    public int maxProfit(int[] prices, String s) {\n        ';
    expect(suggested('java', `${starter}prices.`)).toEqual(['length', 'clone']);
    expect(suggested('java', `${starter}s.`)).toEqual(expect.arrayContaining(['charAt', 'substring', 'length']));
  });

  it('follows nested generics and indexing', () => {
    expect(suggested('java', 'Map<String, List<Integer>> m = new HashMap<>();\nm.')).toEqual(
      expect.arrayContaining(['getOrDefault', 'computeIfAbsent', 'entrySet']),
    );
    expect(suggested('java', 'void f(int[][] grid) { grid[0].')).toEqual(['length', 'clone']);
    expect(suggested('java', 'List<List<String>> rows) {\n rows.')).toContain('subList');
  });

  it('gives a TreeMap its navigation methods and a HashMap none', () => {
    expect(suggested('java', 'TreeMap<Integer, Integer> t = new TreeMap<>(); t.')).toContain('floorKey');
    expect(suggested('java', 'HashMap<Integer, Integer> h = new HashMap<>(); h.')).not.toContain('floorKey');
  });

  it('types var from what it is created as', () => {
    expect(suggested('java', 'var q = new ArrayDeque<int[]>(); q.')).toEqual(expect.arrayContaining(['offer', 'pollFirst']));
    expect(suggested('java', 'var dp = new int[n + 1][m]; dp[0].')).toEqual(['length', 'clone']);
    expect(suggested('java', 'var s = "abc"; s.')).toContain('charAt');
    expect(suggested('java', 'var x = compute(); x.')).toBeNull();
  });

  it('types a for-each variable, declared or var', () => {
    expect(suggested('java', 'for (Map.Entry<String, Integer> e : m.entrySet()) {\n e.')).toEqual(
      expect.arrayContaining(['getKey', 'getValue']),
    );
    expect(suggested('java', 'int[][] grid = new int[3][3];\nfor (var row : grid) row.')).toEqual(['length', 'clone']);
  });

  it('uses the latest declaration of a reused name', () => {
    const code = 'String a = "";\nStringBuilder a = new StringBuilder();\na.';
    expect(suggested('java', code)).toContain('append');
    expect(suggested('java', code)).not.toContain('toCharArray');
    expect(suggested('java', 'List<Integer> a = new ArrayList<>();\nint a = 0;\na.')).toBeNull();
  });

  it('ends the search at a declaration of a type it has no table for', () => {
    expect(suggested('java', 'List<Integer> cur = new ArrayList<>();\nNode cur = head;\ncur.')).toBeNull();
    expect(suggested('java', 'List<Integer> it;\nIterator<Integer> it = s.iterator();\nit.')).toBeNull();
    expect(suggested('java', 'List<Integer> x;\nInteger x = 5;\nx.')).toBeNull();
    expect(suggested('java', 'List<Integer> b;\nint a = 0, b = 1;\nb.')).toBeNull();
    expect(suggested('java', 'List<Integer> a;\nlist.sort((a, b) -> a.')).toBeNull();
    expect(suggested('java', 'List<Integer> a;\nlist.forEach(a -> a.')).toBeNull();
  });

  it('sees a declaration only inside the block, parameter list or loop that declares it', () => {
    const field = 'class Solution {\n  StringBuilder path;\n  void a() { List<Integer> path = new ArrayList<>(); }\n  void b() { path.';
    expect(suggested('java', field)).toContain('append');
    expect(suggested('java', field)).not.toContain('add');
    expect(suggested('java', 'void f(String s) {}\nvoid g(List<Integer> s) {\n  s.')).toContain('add');
    expect(suggested('java', 'List<Integer> a = new ArrayList<>();\nlist.sort((a, b) -> a - b);\na.')).toContain('add');
    expect(suggested('java', 'List<Integer> a = new ArrayList<>();\nlist.forEach(a -> f(a));\na.')).toContain('add');
    expect(suggested('java', 'List<Integer> i = new ArrayList<>();\nfor (int i = 0; i < n; i++) t += i;\ni.')).toContain('add');
    expect(suggested('java', 'String e = "";\ntry { f(); } catch (Exception e) { }\ne.')).toContain('charAt');
    expect(suggested('java', 'String s = "";\n{ int s = 0; }\ns.')).toContain('charAt');
  });

  it('does not take a statement or an expression for a declaration', () => {
    expect(suggested('java', 'String s = "";\nif (s == null) return s;\ns.')).toContain('charAt');
    expect(suggested('java', 'List<Integer> b = new ArrayList<>();\na = b;\nb.')).toContain('add');
    expect(suggested('java', 'String s = "";\nthrow s;\ns.')).toContain('charAt');
    expect(suggested('java', 'int[] nums) {\n best = Math.max(best, k * nums[i]);\n nums.')).toEqual(['length', 'clone']);
    expect(suggested('java', 'int[] nums) {\n f(k, nums);\n nums.')).toEqual(['length', 'clone']);
  });

  it('offers only what Java 13 has', () => {
    expect(suggested('java', 'StringBuilder sb = new StringBuilder(); sb.')).not.toContain('isEmpty');
    expect(suggested('java', 'String s; s.')).toContain('isEmpty');
    expect(suggested('java', 'String s; s.')).not.toContain('formatted');
    expect(suggested('java', 'List<Integer> a; a.')).not.toContain('getFirst');
  });

  it('suggests static members of a class name nothing declares', () => {
    expect(suggested('java', 'int m = Math.')).toEqual(expect.arrayContaining(['max', 'abs', 'PI']));
    expect(suggested('java', 'Integer.')).toEqual(expect.arrayContaining(['MAX_VALUE', 'parseInt']));
    expect(suggested('java', 'Arrays.')).toEqual(expect.arrayContaining(['sort', 'fill', 'asList']));
    expect(suggested('java', 'if (Character.')).toContain('isDigit');
    expect(suggested('java', 'String.')).toContain('valueOf');
  });

  it('suggests String members after a string literal', () => {
    expect(suggested('java', '"abc".')).toContain('length');
  });

  it('suggests nothing for an unknown receiver, a method result, or a number', () => {
    expect(suggested('java', 'foo.')).toBeNull();
    expect(suggested('java', 'Node n = new Node(); n.')).toBeNull();
    expect(suggested('java', 'List<Integer> a = new ArrayList<>(); a.get(0).')).toBeNull();
    expect(suggested('java', 'double d = 1.')).toBeNull();
    expect(suggested('java', 'this.')).toBeNull();
  });

  it('ignores dots and declarations in strings and comments, and stays quiet inside them', () => {
    expect(suggested('java', 'String s = "a.b"; // StringBuilder s.\n/* int s; */ s.')).toContain('charAt');
    expect(suggested('java', 'String s = "s.')).toBeNull();
    expect(suggested('java', 'String s = ""; // s.')).toBeNull();
    expect(suggested('java', 'String s; /* s.')).toBeNull();
  });
});

describe('Python', () => {
  it('suggests list and dict methods after literals', () => {
    expect(suggested('python', 'a = []; a.')).toEqual(expect.arrayContaining(['append', 'pop', 'sort']));
    expect(suggested('python', 'd = {}; d.')).toEqual(expect.arrayContaining(['get', 'items', 'keys']));
    expect(suggested('python', 's = {1, 2}\ns.')).toContain('add');
    expect(suggested('python', 'c = {k: 0 for k in xs}\nc.')).toContain('items');
  });

  it('does not take == for an assignment', () => {
    const code = 'a = []\nif a == {}:\n    a.';
    expect(suggested('python', code)).toContain('append');
    expect(suggested('python', code)).not.toContain('items');
  });

  it('reads annotated parameters from a starter signature', () => {
    const starter =
      'class Solution:\n    def f(self, nums: List[int], s: str, root: Optional[TreeNode], grid: list[list[int]]) -> int:\n        ';
    expect(suggested('python', `${starter}nums.`)).toContain('append');
    expect(suggested('python', `${starter}s.`)).toEqual(expect.arrayContaining(['split', 'join', 'isdigit']));
    expect(suggested('python', `${starter}root.`)).toEqual(['val', 'left', 'right']);
    expect(suggested('python', `${starter}grid[0].`)).toContain('append');
  });

  it('types collections built by their constructors', () => {
    expect(suggested('python', 'q = deque([root])\nq.')).toEqual(expect.arrayContaining(['popleft', 'appendleft']));
    expect(suggested('python', 'q = collections.deque()\nq.')).toContain('popleft');
    expect(suggested('python', 'cnt = Counter(s)\ncnt.')).toEqual(expect.arrayContaining(['most_common', 'get']));
    expect(suggested('python', 'seen = set()\nseen.')).toContain('discard');
    expect(suggested('python', 'adj = defaultdict(list)\nadj.')).toEqual(expect.arrayContaining(['items', 'default_factory']));
    expect(suggested('python', 'adj = defaultdict(list)\nadj[u].')).toContain('append');
  });

  it('types indexing and loops through nested lists', () => {
    expect(suggested('python', 'dp = [[0] * n for _ in range(m)]\ndp[0].')).toContain('append');
    expect(suggested('python', 'grid: List[List[int]] = []\nfor row in grid:\n    row.')).toContain('append');
    expect(suggested('python', 'for ch in s:\n    pass\nword = "ab"\nword[0].')).toContain('isalpha');
  });

  it('keeps the container type through a slice', () => {
    const starter = 'def f(self, words: List[str], s: str, grid: List[List[int]]):\n    ';
    expect(suggested('python', `${starter}words[1:].`)).toContain('append');
    expect(suggested('python', `${starter}words[1:].`)).not.toContain('split');
    expect(suggested('python', `${starter}rest = words[1:]\n    rest.`)).toContain('append');
    expect(suggested('python', `${starter}rest = words[:-1][0]\n    rest.`)).toContain('split');
    expect(suggested('python', `${starter}grid[1:][0].`)).toContain('append');
    expect(suggested('python', `${starter}t = s[::-1]\n    t.`)).toContain('split');
    expect(suggested('python', `${starter}words[i].`)).toContain('split');
  });

  it('shows a subclass\'s own member in place of the one it overrides', () => {
    const popitems = memberCompletions('python', 'd = OrderedDict()\nd.')!.filter((m) => m.name === 'popitem');
    expect(popitems.map((m) => m.signature)).toEqual(['popitem(last=True) -> tuple']);
  });

  it('suggests module functions for a module name nothing binds', () => {
    expect(suggested('python', 'heapq.')).toEqual(expect.arrayContaining(['heappush', 'heappop', 'heapify']));
    expect(suggested('python', 'x = math.')).toEqual(expect.arrayContaining(['inf', 'gcd', 'isqrt']));
    expect(suggested('python', 'bisect.')).toContain('bisect_left');
    expect(suggested('python', 'itertools.')).toContain('permutations');
  });

  it('suggests str methods after a string literal', () => {
    expect(suggested('python', 'return "".')).toContain('join');
    expect(suggested('python', "x = ', '.")).toContain('join');
  });

  it('uses the latest binding of a reused name', () => {
    expect(suggested('python', 'x = []\nx = {}\nx.')).toContain('items');
    expect(suggested('python', 'x = []\nx = 0\nx.')).toBeNull();
  });

  it('suggests nothing after a rebinding whose type it cannot tell', () => {
    const list = 's: List[int] = []\n';
    expect(suggested('python', `${list}a, s = f()\ns.`)).toBeNull();
    expect(suggested('python', `${list}(a, s) = f()\ns.`)).toBeNull();
    expect(suggested('python', `${list}first, *s = words\ns.`)).toBeNull();
    expect(suggested('python', `${list}a = s = f()\ns.`)).toBeNull();
    expect(suggested('python', `${list}for i, s in enumerate(words):\n    s.`)).toBeNull();
    expect(suggested('python', `${list}with open(p) as s:\n    s.`)).toBeNull();
    expect(suggested('python', `${list}try:\n    pass\nexcept ValueError as s:\n    s.`)).toBeNull();
    expect(suggested('python', `${list}def f(self, s):\n    s.`)).toBeNull();
    expect(suggested('python', `${list}def f(self,\n      s=None):\n    s.`)).toBeNull();
    expect(suggested('python', `${list}if (s := f()):\n    s.`)).toBeNull();
    expect(suggested('python', `${list}def f():\n    global s\n    s.`)).toBeNull();
    expect(suggested('python', `${list}def f():\n    nonlocal a, s\n    s.`)).toBeNull();
    expect(suggested('python', `${list}key = lambda s: s.`)).toBeNull();
    expect(suggested('python', `${list}words.sort(key=lambda x, s=0: s.`)).toBeNull();
    expect(suggested('python', `${list}def s():\n    pass\ns.`)).toBeNull();
  });

  it('keeps a binding that a comprehension, lambda, subscript or keyword argument leaves alone', () => {
    const list = 's: List[int] = []\n';
    expect(suggested('python', `${list}words = [s for s in "ab"]\ns.`)).toContain('append');
    expect(suggested('python', `${list}words.sort(key=lambda s: len(s))\ns.`)).toContain('append');
    expect(suggested('python', `${list}s[0], s[1] = s[1], s[0]\ns.`)).toContain('append');
    expect(suggested('python', `${list}s[i] = 1\ns.`)).toContain('append');
    expect(suggested('python', `${list}f(a, s=1)\ns.`)).toContain('append');
    expect(suggested('python', `${list}print(a, s)\ns.`)).toContain('append');
    expect(suggested('python', `${list}s += [1]\ns.`)).toContain('append');
    expect(suggested('python', `${list}d = {a: 1,\n     s: 2}\ns.`)).toContain('append');
    expect(suggested('python', `${list}x = [1 for _ in s if s.`)).toContain('append');
    expect(suggested('python', `${list}words = [w for w in s if w > 0]\nfor w in s:\n    s.`)).toContain('append');
  });

  it('suggests nothing for an unknown receiver, attribute, call result, or number', () => {
    expect(suggested('python', 'foo.')).toBeNull();
    expect(suggested('python', 'x = foo()\nx.')).toBeNull();
    expect(suggested('python', 'self.')).toBeNull();
    expect(suggested('python', 'a = []\nself.a.')).toBeNull();
    expect(suggested('python', 'x = 1.')).toBeNull();
  });

  it('ignores strings and comments, and stays quiet inside them', () => {
    expect(suggested('python', 's = "a.b"  # s = []\ns.')).toContain('split');
    expect(suggested('python', 's = """\ns = [].\n"""\ns.')).toContain('split');
    expect(suggested('python', 'a = []  # a.')).toBeNull();
    expect(suggested('python', "a = 'a.")).toBeNull();
  });
});

describe('C++', () => {
  it('suggests vector methods after a vector declaration', () => {
    expect(suggested('cpp', 'vector<int> a; a.')).toEqual(expect.arrayContaining(['push_back', 'size', 'clear']));
  });

  it('reads parameters from a starter signature', () => {
    const starter = 'class Solution {\npublic:\n    int f(vector<int>& nums, string s, TreeNode* root) {\n        ';
    expect(suggested('cpp', `${starter}nums.`)).toContain('push_back');
    expect(suggested('cpp', `${starter}s.`)).toEqual(expect.arrayContaining(['substr', 'find']));
    expect(suggested('cpp', `${starter}root->`)).toEqual(['val', 'left', 'right']);
  });

  it('follows nested generics and indexing', () => {
    expect(suggested('cpp', 'vector<vector<int>> g(n, vector<int>(m)); g[0].')).toContain('push_back');
    expect(suggested('cpp', 'unordered_map<int, vector<int>> adj;\nadj[u].')).toContain('push_back');
    expect(suggested('cpp', 'std::map<std::string, int> m; m.')).toEqual(
      expect.arrayContaining(['lower_bound', 'upper_bound', 'find', 'count']),
    );
    expect(suggested('cpp', 'priority_queue<int, vector<int>, greater<int>> pq; pq.')).toEqual(
      expect.arrayContaining(['top', 'push', 'pop']),
    );
    expect(suggested('cpp', 'const string& word) { word.')).toContain('substr');
  });

  it('offers only what C++14 has', () => {
    expect(suggested('cpp', 'unordered_map<int, int> m; m.')).not.toContain('contains');
    expect(suggested('cpp', 'unordered_map<int, int> m; m.')).not.toContain('lower_bound');
    expect(suggested('cpp', 'string s; s.')).not.toContain('starts_with');
  });

  it('gives insert and emplace the return type of their container', () => {
    const signatures = (code: string, name: string) =>
      memberCompletions('cpp', code)!.filter((m) => m.name === name).map((m) => m.signature.split(' ')[0]);
    expect(signatures('multiset<int> s; s.', 'insert')).toEqual(['iterator']);
    expect(signatures('multimap<int, int> m; m.', 'emplace')).toEqual(['iterator']);
    expect(signatures('set<int> s; s.', 'insert')).toEqual(['pair<iterator,']);
    expect(signatures('unordered_map<int, int> m; m.', 'emplace')).toEqual(['pair<iterator,']);
  });

  it('types auto from a constructor, another variable, or a range', () => {
    expect(suggested('cpp', 'auto v = vector<int>(n, 0); v.')).toContain('push_back');
    expect(suggested('cpp', 'vector<vector<int>>& grid) {\n for (auto& row : grid) row.')).toContain('push_back');
    expect(suggested('cpp', 'map<int, int> m; for (const auto& p : m) p.')).toEqual(['first', 'second', 'swap']);
    expect(suggested('cpp', 'auto it = m.find(k); it->')).toBeNull();
  });

  it('uses the latest declaration and is not fooled by multiplication', () => {
    expect(suggested('cpp', 'vector<int> a;\nset<int> a;\na.')).toContain('lower_bound');
    expect(suggested('cpp', 'vector<int>& nums) {\n int s = x * nums[0];\n nums.')).toContain('push_back');
    expect(suggested('cpp', 'int n = 1\'000;\nstring s; s.')).toContain('substr');
  });

  it('sees a declaration only inside the block, parameter list or loop that declares it', () => {
    const lambda =
      'class Solution {\npublic:\n  int f(string left, string right) {\n    sort(v.begin(), v.end(), [](const vector<int>& left, const vector<int>& right) { return 0; });\n    left.';
    expect(suggested('cpp', lambda)).toContain('substr');
    expect(suggested('cpp', lambda)).not.toContain('emplace_back');
    const block = 'vector<int> cur;\nfor (int i = 0; i < 3; i++) { string cur = "a"; }\ncur.';
    expect(suggested('cpp', block)).toContain('emplace_back');
    expect(suggested('cpp', block)).not.toContain('substr');
    expect(suggested('cpp', 'string row;\nfor (auto& row : grid) t += row[0];\nrow.')).toContain('substr');
    expect(suggested('cpp', 'struct DSU {\n  DSU(vector<int> p) : parent(p.size()), rank(p.size(), 0) {\n    p.')).toContain('push_back');
    expect(suggested('cpp', 'auto cmp = [](string a) -> bool {\n  a.')).toContain('substr');
  });

  it('ends the search at a declaration of a type it has no table for', () => {
    expect(suggested('cpp', 'vector<int> cur;\nNode cur = head;\ncur.')).toBeNull();
    expect(suggested('cpp', 'vector<int> j;\nint i = 0, j = n - 1;\nj.')).toBeNull();
    expect(suggested('cpp', 'vector<int> x;\nauto [x, y] = p;\nx.')).toBeNull();
    expect(suggested('cpp', 'string a;\nlong long a = 0;\na.')).toBeNull();
  });

  it('does not take a statement or an expression for a declaration', () => {
    expect(suggested('cpp', 'string s;\nif (s.empty()) return s;\ns.')).toContain('substr');
    expect(suggested('cpp', 'vector<int>& nums) {\n best = max(best, k * nums[i]);\n nums.')).toContain('push_back');
    expect(suggested('cpp', 'vector<int> b;\na = b;\nb.')).toContain('push_back');
    expect(suggested('cpp', 'TreeNode* t = root;\ndelete t;\nt->')).toEqual(['val', 'left', 'right']);
  });

  it('reaches a pointer\'s members only with ->, and an object\'s only with .', () => {
    const starter = 'class Solution {\npublic:\n    ListNode* f(ListNode* head, vector<ListNode*>& lists) {\n        ';
    expect(suggested('cpp', `${starter}head.`)).toBeNull();
    expect(suggested('cpp', `${starter}head->`)).toEqual(['val', 'next']);
    expect(suggested('cpp', `${starter}lists[0]->`)).toEqual(['val', 'next']);
    expect(suggested('cpp', 'TreeNode* root; root.')).toBeNull();
    expect(suggested('cpp', 'TreeNode* root;\nauto p = root; p->')).toEqual(['val', 'left', 'right']);
    expect(suggested('cpp', 'ListNode *slow = head, *fast = head;\nfast.')).toBeNull();
    expect(suggested('cpp', 'ListNode *slow = head, *fast = head;\nfast->')).toEqual(['val', 'next']);
    expect(suggested('cpp', 'ListNode* a = head, b;\nb.')).toEqual(['val', 'next']);
    expect(suggested('cpp', 'vector<int> v; v->')).toBeNull();
    expect(suggested('cpp', 'TreeNode t; t->')).toBeNull();
  });

  it('suggests nothing for an unknown receiver', () => {
    expect(suggested('cpp', 'Node* n; n->')).toBeNull();
    expect(suggested('cpp', 'foo.')).toBeNull();
    expect(suggested('cpp', 'x > y; y.')).toBeNull();
  });
});

it('answers within a keystroke on a 2000-line file', () => {
  const files = [
    ['python', 'class Solution:\n    def f(self, nums: List[int]) -> int:\n', '        total += nums[0] * nums[1]\n'],
    ['java', 'class Solution {\n  int f(int[] nums) {\n', '        total += nums[0] * nums[1];\n'],
    ['cpp', 'class Solution {\npublic:\n  int f(vector<int>& nums) {\n', '        total += nums[0] * nums[1];\n'],
  ];
  for (const [language, head, line] of files) {
    const start = performance.now();
    expect(suggested(language, `${head}${line.repeat(2000)}        nums.`)).not.toBeNull();
    expect(performance.now() - start).toBeLessThan(200);
  }
});

it('suggests nothing for a language without member tables', () => {
  expect(suggested('javascript', 'const a = []; a.')).toBeNull();
});

describe('insertText', () => {
  const member = (language: string, code: string, name: string) =>
    memberCompletions(language, code)!.find((m) => m.name === name)!;

  it('puts the cursor between the parentheses only when the method takes arguments', () => {
    expect(insertText(member('java', 'List<Integer> a; a.', 'add'))).toBe('add($0)');
    expect(insertText(member('java', 'List<Integer> a; a.', 'size'))).toBe('size()');
    expect(insertText(member('cpp', 'vector<int> a; a.', 'resize'))).toBe('resize($0)');
    expect(insertText(member('python', 'heapq.', 'heappop'))).toBe('heappop($0)');
  });

  it('inserts a field or constant as its bare name', () => {
    expect(insertText(member('java', 'int[] a; a.', 'length'))).toBe('length');
    expect(insertText(member('python', 'math.', 'inf'))).toBe('inf');
  });
});

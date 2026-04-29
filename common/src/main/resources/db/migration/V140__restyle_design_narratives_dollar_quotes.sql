-- V140: Re-apply V127 design narratives using standard `$$` dollar-quote tags.
--
-- V127 used a custom `$D$ ... $D$` dollar-quote tag (a Postgres feature that
-- lets you embed a literal `$$` inside the quoted body without escaping). The
-- bodies in V127 do not actually contain a `$$` substring, so the custom tag
-- was unnecessary; standard `$$ ... $$` quoting works just as well and keeps
-- the migration source consistent with every other migration in the tree.
--
-- This migration re-runs each UPDATE from V127 with `$$` quoting. The column
-- values produced are byte-identical to what V127 already wrote, so this is
-- a no-op against any database that has applied V127. It exists purely to
-- forward-record the style change; V127 itself stays untouched so its
-- Flyway checksum remains valid in environments where it has already run.
--

-- click-counter
UPDATE problems SET description = $$A live traffic dashboard for a marketing landing page needs to show how many clicks the page has absorbed in the last few minutes. Requests arrive tagged with their server-side second-of-day, and the dashboard should always reflect a rolling five-minute window, inclusive on both ends.

Build the `ClickTally` class so it can ingest click events and answer window queries on demand:

- `ClickTally()` — boots a fresh tally with no recorded clicks.
- `void record(int timestamp)` — logs a single click that landed at second `timestamp`. A burst of clicks may share the same second, and each one counts.
- `int countSince(int timestamp)` — returns how many clicks fell into the inclusive window `[timestamp - 299, timestamp]`.

Calls to `record` and `countSince` arrive in non-decreasing timestamp order, reflecting the append-only nature of the traffic log.

**Example 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
At second 4, clicks at 1, 2, and 3 are all inside `[-295, 4]`. At second 300, the click at second 1 is still inside `[1, 300]`, so the window holds four clicks. One tick later the oldest click at second 1 falls outside `[2, 301]` and the count drops to three.

**Example 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
Three clicks that share a second all count toward the window anchored at that second.

**Example 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
A query before any clicks have arrived returns zero, and the later click is still inside the window at second 300.$$ WHERE slug = 'click-counter';
UPDATE problems SET constraints = $$- `1 <= timestamp <= 2 * 10^9`
- Each `timestamp` passed in is greater than or equal to the previous one across all calls.
- At most 250 total calls are made to `record` and `countSince` combined.$$ WHERE slug = 'click-counter';

-- feed-designer
UPDATE problems SET description = $$You are wiring up the backend for a lightweight short-post social network where each account can publish snippets and skim a timeline made from their own posts plus whoever they currently follow. The timeline must stay ordered by publish time, newest first, and capped at the ten most recent items.

Implement the `MicroFeed` class so the follow graph and the post stream stay consistent as users subscribe and unsubscribe throughout the day:

- `MicroFeed()` — starts an empty service with no users, follows, or posts.
- `publishPost(int userId, int messageId)` — records that account `userId` just published snippet `messageId`. Every `messageId` is globally unique and arrives in publish order.
- `List<Integer> latestFeed(int userId)` — returns up to the ten most recent message IDs visible to `userId`, which means anything that `userId` published plus anything published by someone `userId` currently follows, sorted newest first.
- `subscribe(int followerId, int followeeId)` — makes `followerId` start following `followeeId`. If the two IDs are identical, the call is a no-op.
- `unsubscribe(int followerId, int followeeId)` — makes `followerId` stop following `followeeId`. If the two IDs are identical, or the follow relationship is not currently active, the call is a no-op.

**Example 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
Account 1 publishes two snippets and sees them in most-recent-first order.

**Example 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
Once account 1 follows account 2, account 2's snippet shows up on account 1's timeline.

**Example 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
Dropping the follow edge immediately removes account 2's contribution from account 1's timeline.$$ WHERE slug = 'feed-designer';
UPDATE problems SET constraints = $$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- At most `20000` calls total will be made across `publishPost`, `latestFeed`, `subscribe`, and `unsubscribe`.$$ WHERE slug = 'feed-designer';

-- hash-table
UPDATE problems SET description = $$You are wiring a small parts-inventory service that maps integer SKU codes to on-hand counts. The platform forbids pulling in a built-in dictionary library, so the lookup table has to be assembled from scratch using chaining (or any equivalent collision-handling scheme) while still exposing a friendly set/lookup/erase surface.

Build the `ChainedMap` class so the stockroom clerk can keep counts fresh as shipments and pulls happen throughout the day:

- `ChainedMap()` — creates an empty catalog with no SKU entries.
- `void set(int key, int value)` — records that SKU `key` now has quantity `value`. If the SKU is already tracked, overwrite its quantity with the new value.
- `int lookup(int key)` — returns the quantity currently bound to SKU `key`, or `-1` when the catalog has no entry for that SKU.
- `void erase(int key)` — drops SKU `key` from the catalog entirely. If the SKU is not present, the call is a silent no-op.

**Example 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
After recording `(1,10)` and `(2,20)`, looking up SKU 1 returns its quantity while SKU 3 yields the missing sentinel `-1`. Overwriting SKU 2 with 30 is reflected on the next read, and erasing SKU 2 makes a follow-up read return `-1` again.

**Example 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
Three independent SKUs are recorded and each one returns its own quantity on read-back.

**Example 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
Queries and erases against a SKU that was never inserted are harmless.$$ WHERE slug = 'hash-table';
UPDATE problems SET constraints = $$- `0 <= key, value <= 800000`
- At most `8000` calls will be made across `set`, `lookup`, and `erase`.$$ WHERE slug = 'hash-table';

-- kth-largest-stream
UPDATE problems SET description = $$A rooftop weather lab forwards a continuous stream of integer readings from a bank of sensors into a monitoring service. Analysts want to watch the `k`-th largest reading as the stream grows — not the `k`-th *distinct* reading, but the `k`-th value in the overall sorted order, so duplicates keep their own rank.

Build the `TopKStream` class to answer that running question efficiently as each new sample arrives:

- `TopKStream(int k, int[] nums)` — seeds the tracker with rank parameter `k` and a starting batch of readings `nums` already collected from the sensors.
- `int record(int val)` — appends `val` to the stream and returns the current `k`-th largest reading across everything that has been ingested so far.

**Example 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // stream becomes [4,5,8,2,3]; 3rd largest is 4
tracker.record(5);   // stream becomes [4,5,8,2,3,5]; 3rd largest is 5
tracker.record(10);  // stream becomes [4,5,8,2,3,5,10]; 3rd largest is 5
tracker.record(9);   // stream becomes [4,5,8,2,3,5,10,9]; 3rd largest is 8
tracker.record(4);   // stream becomes [4,5,8,2,3,5,10,9,4]; 3rd largest is 8
```

The tracker must stay responsive across the full shift; a naive re-sort on every sample will quickly fall behind the feed.$$ WHERE slug = 'kth-largest-stream';
UPDATE problems SET constraints = $$- `1 <= k <= 8000`
- `0 <= nums.length <= 8000`
- `-10^8 <= nums[i] <= 10^8`
- `-10^8 <= val <= 10^8`
- At most `8000` calls will be made to `record`.
- When `record` is called, the combined stream is guaranteed to contain at least `k` readings.$$ WHERE slug = 'kth-largest-stream';

-- minimum-stack
UPDATE problems SET description = $$An operations team keeps a running log of service-latency samples pushed from a production tracer. Investigators walk the log like a stack — appending readings as they arrive, popping the tail during rollbacks — and a sidecar dashboard needs to show the **lowest** latency currently sitting in the log at any moment. Every single operation on the log, including the low-watermark query, has to finish in constant time so the tracer never stalls.

Build the `LowTrackStack` class with exactly this surface:

- `LowTrackStack()` — spins up an empty log with no samples.
- `void push(int val)` — appends latency reading `val` to the top of the log.
- `void pop()` — drops the reading that currently sits at the top of the log.
- `int top()` — returns the reading at the top of the log without removing it.
- `int getMin()` — returns the smallest reading anywhere in the log right now.

Each of `push`, `pop`, `top`, and `getMin` must run in `O(1)` time so the dashboard keeps pace with the live tracer.

**Example 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
Three latency samples (12, 6, -2) are appended in order. `getMin` returns `-2`, the smallest reading currently in the log. After popping the top sample, the log holds `[12, 6]`; `top` now returns `6`, and `getMin` also returns `6` because the previous minimum has been evicted.

The sidecar relies on the fact that `pop`, `top`, and `getMin` are only fired after at least one sample has been pushed, so the implementation may assume the log is non-empty for those three operations.$$ WHERE slug = 'minimum-stack';
UPDATE problems SET constraints = $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, and `getMin` are only invoked after at least one element has been pushed.
- At most `20000` calls will be made across `push`, `pop`, `top`, and `getMin` combined.$$ WHERE slug = 'minimum-stack';

-- prefix-tree
UPDATE problems SET description = $$A filesystem indexer for a massive directory catalog needs a compact structure that can answer two questions fast: "have I seen this exact file name before?" and "does anything in the catalog start with this prefix?" A shared character-by-character tree is the right fit — walking one node per letter keeps both queries proportional to the length of the query, not the size of the catalog.

Build the `PrefixIndex` class so the indexer can stream file names in and let downstream tooling probe them by full name or by prefix:

- `PrefixIndex()` — creates an empty index with no names yet registered.
- `void insert(String word)` — records the string `word` as a full, indexed file name. Re-inserting an existing name is harmless.
- `boolean search(String word)` — returns `true` when `word` was previously inserted as a complete name, and `false` otherwise. A prefix that happens to match the first few letters of an inserted name but was never inserted as a full name on its own must return `false`.
- `boolean startsWith(String prefix)` — returns `true` when at least one previously inserted name begins with `prefix`, and `false` otherwise.

**Example 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

After inserting `"apple"`, `search("apple")` is `true` because the exact name is on record. `search("app")` is `false` because `"app"` has only been *seen as a prefix*, not inserted as its own name. `startsWith("app")` is `true` because `"apple"` begins with those three letters. Once `"app"` is inserted in its own right, the later `search("app")` flips to `true`.$$ WHERE slug = 'prefix-tree';
UPDATE problems SET constraints = $$- `1 <= word.length, prefix.length <= 2000`
- `word` and `prefix` consist only of lowercase English letters.
- At most `20000` calls total will be made across `insert`, `search`, and `startsWith`.$$ WHERE slug = 'prefix-tree';

-- random-set
UPDATE problems SET description = $$A raffle desk keeps a live pool of eligible ticket numbers and must be able to draw one uniformly at any moment. Each ticket number is a distinct integer, and the set of eligible tickets grows or shrinks as entries come in and are disqualified. Every draw must give each currently-eligible ticket the same chance of being picked, and the bookkeeping for add/remove/draw must stay constant on average no matter how many tickets are in play.

Implement the `RandomBag` class:

- `RandomBag()` sets up an empty pool with no eligible tickets.
- `boolean insert(int val)` registers ticket number `val` as eligible. Returns `true` if the ticket was newly added, or `false` if it was already in the pool.
- `boolean remove(int val)` disqualifies ticket number `val`. Returns `true` if the ticket was in the pool and was removed, or `false` if it was not present.
- `int drawRandom()` returns a ticket number chosen uniformly at random from the current pool. Every eligible ticket must have identical probability of being returned. This method is only invoked while the pool holds at least one ticket.

**Example:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
Ticket `1` and ticket `2` enter the pool, then ticket `1` is disqualified. Only ticket `2` remains eligible, so the draw must return `2`.$$ WHERE slug = 'random-set';
UPDATE problems SET constraints = $$- `-10^8 <= val <= 10^8`
- At most `2 * 10^5` combined calls to `insert`, `remove`, and `drawRandom`
- The pool is guaranteed to be non-empty whenever `drawRandom` is invoked$$ WHERE slug = 'random-set';

-- recent-cache
UPDATE problems SET description = $$An edge node keeps a bounded registry of recently consulted records. Each record is identified by a numeric key and carries a numeric value (think of it as a computed response that is expensive to recompute). When the registry is full and a brand-new key arrives, the record that has gone the longest without being touched must be dropped to make room. Any access to a key — whether a fresh write or a successful read — counts as touching that key and refreshes its standing as the most recently used entry.

Implement the `RecentRegistry` class:

- `RecentRegistry(int capacity)` creates an empty registry that can hold up to `capacity` entries at once.
- `int lookup(int key)` returns the value currently bound to `key`, or `-1` if no such binding is present. A successful lookup promotes `key` to most-recently-used.
- `void store(int key, int value)` binds `key` to `value`. If `key` already exists, its value is overwritten and it is promoted to most-recently-used. If `key` is new and the registry is already at capacity, the least-recently-used binding is evicted before the new one is recorded.

Both `lookup` and `store` must run in average `O(1)` time.

**Example:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$$ WHERE slug = 'recent-cache';
UPDATE problems SET constraints = $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- At most `2 * 10^5` combined calls to `lookup` and `store`$$ WHERE slug = 'recent-cache';

-- ring-buffer
UPDATE problems SET description = $$A streaming pipeline reuses a fixed block of slots arranged in a ring. Readings flow in at one end and are drained at the other; when the write head reaches the end of the block it wraps around to the start, so the storage never grows beyond the capacity chosen at startup. The pipeline must reject writes when every slot is occupied, ignore drains when nothing is buffered, and cheaply report the head and tail values as well as empty/full status at any time.

Implement the `FixedRing` class:

- `FixedRing(int k)` prepares an empty ring with room for up to `k` readings.
- `boolean push(int value)` appends `value` at the rear (the write head). Returns `true` on success, or `false` if the ring is already full.
- `boolean pull()` drops the reading at the front (the read head). Returns `true` on success, or `false` if the ring is currently empty.
- `int front()` returns the reading at the front without removing it, or `-1` if the ring is empty.
- `int rear()` returns the reading at the rear without removing it, or `-1` if the ring is empty.
- `boolean isEmpty()` returns `true` exactly when no readings are buffered.
- `boolean isFull()` returns `true` exactly when all `k` slots are occupied.

**Example:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$$ WHERE slug = 'ring-buffer';
UPDATE problems SET constraints = $$- `1 <= k <= 1000`
- `0 <= value <= 1000`
- At most `3000` combined calls to `push`, `pull`, `front`, `rear`, `isEmpty`, and `isFull`$$ WHERE slug = 'ring-buffer';

-- running-median
UPDATE problems SET description = $$A metrics collector ingests a stream of integer samples from a live service and must be ready, at any point, to report the median of every sample seen so far. Samples arrive one at a time and are never removed. When an even number of samples has been observed, the median is defined as the arithmetic mean of the two middle values and must be returned as a floating-point number; otherwise the middle value itself is returned (also as a floating-point number). Reads and writes are interleaved freely, so both operations need to be cheap even after very long sessions.

Implement the `StreamMedian` class:

- `StreamMedian()` initializes an empty collector that has not yet seen any samples.
- `void record(int num)` ingests the sample `num` into the running collection.
- `double median()` returns the median of all samples ingested so far. This method is only called after at least one sample has been recorded.

**Example:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // middle of [1, 2, 3] = 2.0
```$$ WHERE slug = 'running-median';
UPDATE problems SET constraints = $$- `-80000 <= num <= 80000`
- At most `40000` combined calls to `record` and `median`
- `median` is never called before the first `record`$$ WHERE slug = 'running-median';

-- stack-queue
UPDATE problems SET description = $$A processing pipeline receives jobs that must be handled in strict arrival order (first-in, first-out), but the only primitive storage available in this environment is a last-in, first-out stack. Your task is to expose a FIFO interface while internally keeping exactly two stacks as backing storage — no arrays, lists, deques, or other containers are permitted. The standard stack primitives (push to top, pop from top, peek at top, emptiness check) are the only moves allowed on the two internal stacks.

Implement the `QueueFromStacks` class:

- `QueueFromStacks()` initializes an empty pipeline.
- `void push(int x)` appends job `x` to the back of the pipeline.
- `int pop()` removes and returns the job at the front of the pipeline.
- `int peek()` returns the job at the front of the pipeline without removing it.
- `boolean empty()` returns `true` when no jobs are queued, `false` otherwise.

The calling code guarantees that `pop` and `peek` are never invoked on an empty pipeline.

**Example:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- front of the pipeline
q.pop()    // 1  -- front is dequeued
q.empty()  // false -- 2 still queued
```$$ WHERE slug = 'stack-queue';
UPDATE problems SET constraints = $$- `1 <= x <= 9`
- At most `100` combined calls to `push`, `pop`, `peek`, and `empty`
- `pop` and `peek` are only invoked when the pipeline is non-empty$$ WHERE slug = 'stack-queue';

-- state-snapshots
UPDATE problems SET description = $$A configuration service manages a fixed-length row of numeric cells that operators update in place, and it periodically freezes the current row as an immutable snapshot for auditing. Every snapshot gets the next consecutive id, starting at `0`, and later reads must be able to reconstruct the exact value a given cell held at the moment a given snapshot was taken — even after many further edits. All cells start at `0` when the service is created.

Implement the `VersionedCells` class:

- `VersionedCells(int length)` creates a row of `length` cells, all initialized to `0`, with no snapshots yet taken.
- `void set(int index, int val)` overwrites the live value at position `index` with `val`. This change affects only the live row; previously committed snapshots are untouched.
- `int commit()` freezes the current live row as a new snapshot and returns its id. The first call returns `0`, the second `1`, and so on.
- `int readAt(int index, int snapId)` returns the value that cell `index` held in the snapshot identified by `snapId`.

**Example:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$$ WHERE slug = 'state-snapshots';
UPDATE problems SET constraints = $$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId` and `snapId` is strictly less than the number of `commit` calls made so far
- At most `50000` combined calls to `set`, `commit`, and `readAt`$$ WHERE slug = 'state-snapshots';

-- string-codec
UPDATE problems SET description = $$A message-framing layer sits between two services that can only exchange a single raw string across a socket. The upstream side has a list of arbitrary string fragments it needs to hand to the downstream side; the downstream side must reconstruct that list byte-for-byte. Your job is to build the framing codec that lives on both ends.

Implement the `ListCoder` class with two methods:

- `String pack(List<String> strs)` — takes a list of fragments and returns a single framed string that carries enough structural information to recover the list later. The fragments may contain *any* byte pattern, including whatever delimiter or escape character your framing scheme uses, so a naive join on a reserved character will not work.
- `List<String> unpack(String s)` — takes a framed string previously produced by `pack` and returns the original list, preserving order, length, and content of every fragment, including empty fragments.

The codec must be **stateless**: everything `unpack` needs has to live inside the string that `pack` emitted — no shared counters, no out-of-band metadata, no instance fields persisting between calls. A round trip through `pack` followed by `unpack` must reproduce the input list exactly, even when the list is empty, contains only empty fragments like `hello` or `world`, or contains fragments built entirely of characters that look like framing markers.$$ WHERE slug = 'string-codec';
UPDATE problems SET constraints = $$- `0 <= strs.length <= 200`
- `0 <= strs[i].length <= 200`
- Each `strs[i]` may contain any Unicode code point, including characters that the codec uses as delimiters or escapes.$$ WHERE slug = 'string-codec';

-- time-map
UPDATE problems SET description = $$A metrics platform ingests named signals from fleet instrumentation. Each signal is identified by a string `key` (for example a device identifier or metric name), and the platform records a new `value` for that key every time the device reports in. Reports for the same key arrive in strictly increasing timestamp order. Analysts later ask, for some key and some timestamp `t`, "what did this signal read as-of `t`?" — meaning the latest recorded reading whose timestamp was not in the future relative to `t`.

Build the `TimestampedStore` class that backs this workload:

- `TimestampedStore()` — constructs an empty store holding no signals.
- `void write(String key, String value, int timestamp)` — appends the reading `value` for signal `key` at the given `timestamp`. For any given key, successive calls to `write` use timestamps that are strictly greater than all prior timestamps for that same key.
- `String readAt(String key, int timestamp)` — returns the `value` most recently written for `key` at any timestamp `<= timestamp`. When `key` has no reading at or before `timestamp` (including the case where `key` has never been written), return the empty string `""`.

Queries can ask about a point that sits between two recorded timestamps; in that case the reading from the most recent prior write is what was in effect, so that is what `readAt` returns. Queries can also arrive for timestamps newer than the most recent write, and should surface that most recent reading.$$ WHERE slug = 'time-map';
UPDATE problems SET constraints = $$- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- Timestamps passed to `write` are strictly increasing per `key`.
- The total number of `write` and `readAt` calls combined is at most `2 * 10^5`.$$ WHERE slug = 'time-map';

-- tree-codec
UPDATE problems SET description = $$A hierarchical document workflow needs to hand binary-tree-shaped artifacts (think: a content outline where each node has an optional left and right child and an integer label) between services that only speak in strings. Your job is to write the two halves of that wire format: one side flattens a live tree into a single string, the other side rebuilds the identical tree from that string.

Implement the `TreeSerializer` class with two methods:

- `String pack(TreeNode root)` — walks the tree rooted at `root` and produces a single string that captures every node's integer value and every parent/child relationship. `root` may be `null`, in which case `pack` still returns a well-defined string that represents "no tree".
- `TreeNode unpack(String data)` — consumes a string previously produced by `pack` and reconstructs a tree that is structurally identical to the original: every node has the same value, the same left child, and the same right child. When `data` represents an empty tree, `unpack` returns `null`.

The specific textual format is yours to pick. What is fixed is the round-trip guarantee: for any valid input tree `t`, calling `unpack(pack(t))` must return a tree indistinguishable from `t`. That guarantee has to hold for a lopsided tree whose children sit on the left only, for a single-node tree, and for the empty tree.

You may not rely on any state outside the string itself — the serializer and deserializer must be stateless so two different processes can exchange trees through `pack`/`unpack` alone.$$ WHERE slug = 'tree-codec';
UPDATE problems SET constraints = $$- The number of nodes in the tree is in the range `[0, 10000]`.
- `-1000 <= Node.val <= 1000`$$ WHERE slug = 'tree-codec';

-- word-dictionary
UPDATE problems SET description = $$A spell-check subsystem keeps a growing lexicon of known lowercase terms. Authors can register new terms at any time, and reviewers issue lookup queries against the lexicon using a simple pattern language: an exact letter must match that letter, and a `.` matches any single letter. A pattern is satisfied when at least one stored term, compared letter-for-letter against the pattern of the same length, matches under those rules.

Implement the `WildcardLexicon` class:

- `WildcardLexicon()` — initializes the lexicon with no terms registered.
- `void enroll(String word)` — adds `word` to the lexicon. `word` is made of lowercase English letters only. Duplicate enrollments for the same term are harmless; the term simply stays in the lexicon.
- `boolean match(String word)` — returns `true` if some enrolled term has the same length as `word` and matches it position-by-position, where every `.` in `word` is treated as a single-letter wildcard. Returns `false` when no enrolled term satisfies the pattern, including the case where the lexicon is empty or when every enrolled term is a different length than `word`.

A query's `word` contains only lowercase letters and the wildcard character `.`. A non-wildcard character must match its counterpart exactly; a `.` is allowed to stand in for any single lowercase letter, but it still consumes exactly one character of the stored term. Queries do not mutate the lexicon — they only inspect it — and enrollments and queries may be interleaved arbitrarily.$$ WHERE slug = 'word-dictionary';
UPDATE problems SET constraints = $$- `1 <= word.length <= 25`
- `word` in `enroll` consists of lowercase English letters only.
- `word` in `match` consists of lowercase English letters and/or the wildcard character `.`.
- At most `8000` calls will be made to `enroll` and `match` combined.$$ WHERE slug = 'word-dictionary';

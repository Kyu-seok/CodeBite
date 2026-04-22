-- V125: Rename design-interface classes, methods, and titles across 16 problems.
-- Applies REPLACE() on test_cases.input (sample + hidden) to rewrite the quoted
-- class/method tokens in command traces. Problem descriptions get REPLACE() on
-- backtick-wrapped tokens and the bare class identifier. Drivers and starters
-- in source control are updated in the same commit.

-- click-counter: HitCounter -> ClickTally
UPDATE problems SET title = 'Click Tally Window' WHERE slug = 'click-counter';
UPDATE test_cases SET input = REPLACE(input, '"HitCounter"', '"ClickTally"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter');
UPDATE test_cases SET input = REPLACE(input, '"hit"', '"record"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter');
UPDATE test_cases SET input = REPLACE(input, '"getHits"', '"countSince"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter');
UPDATE problems SET description = REPLACE(description, '`HitCounter`', '`ClickTally`') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, 'HitCounter', 'ClickTally') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, '`hit`', '`record`') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, '`hit(', '`record(') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, '`getHits`', '`countSince`') WHERE slug = 'click-counter';
UPDATE problems SET description = REPLACE(description, '`getHits(', '`countSince(') WHERE slug = 'click-counter';

-- feed-designer: FeedDesigner -> MicroFeed
UPDATE problems SET title = 'Short-Post Feed' WHERE slug = 'feed-designer';
UPDATE test_cases SET input = REPLACE(input, '"FeedDesigner"', '"MicroFeed"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer');
UPDATE test_cases SET input = REPLACE(input, '"postMessage"', '"publishPost"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer');
UPDATE test_cases SET input = REPLACE(input, '"getNewsFeed"', '"latestFeed"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer');
UPDATE test_cases SET input = REPLACE(input, '"follow"', '"subscribe"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer');
UPDATE test_cases SET input = REPLACE(input, '"unfollow"', '"unsubscribe"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer');
UPDATE problems SET description = REPLACE(description, '`FeedDesigner`', '`MicroFeed`') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, 'FeedDesigner', 'MicroFeed') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`postMessage`', '`publishPost`') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`postMessage(', '`publishPost(') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`getNewsFeed`', '`latestFeed`') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`getNewsFeed(', '`latestFeed(') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`follow`', '`subscribe`') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`follow(', '`subscribe(') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`unfollow`', '`unsubscribe`') WHERE slug = 'feed-designer';
UPDATE problems SET description = REPLACE(description, '`unfollow(', '`unsubscribe(') WHERE slug = 'feed-designer';

-- hash-table: SimpleHashMap -> ChainedMap
UPDATE problems SET title = 'Chained Key-Value Map' WHERE slug = 'hash-table';
UPDATE test_cases SET input = REPLACE(input, '"SimpleHashMap"', '"ChainedMap"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table');
UPDATE test_cases SET input = REPLACE(input, '"put"', '"set"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table');
UPDATE test_cases SET input = REPLACE(input, '"get"', '"lookup"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table');
UPDATE test_cases SET input = REPLACE(input, '"remove"', '"erase"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table');
UPDATE problems SET description = REPLACE(description, '`SimpleHashMap`', '`ChainedMap`') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, 'SimpleHashMap', 'ChainedMap') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`put`', '`set`') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`put(', '`set(') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`get`', '`lookup`') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`get(', '`lookup(') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`remove`', '`erase`') WHERE slug = 'hash-table';
UPDATE problems SET description = REPLACE(description, '`remove(', '`erase(') WHERE slug = 'hash-table';

-- kth-largest-stream: KthLargest -> TopKStream
UPDATE problems SET title = 'K-th Highest Running Value' WHERE slug = 'kth-largest-stream';
UPDATE test_cases SET input = REPLACE(input, '"KthLargest"', '"TopKStream"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream');
UPDATE test_cases SET input = REPLACE(input, '"add"', '"record"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream');
UPDATE problems SET description = REPLACE(description, '`KthLargest`', '`TopKStream`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET description = REPLACE(description, 'KthLargest', 'TopKStream') WHERE slug = 'kth-largest-stream';
UPDATE problems SET description = REPLACE(description, '`add`', '`record`') WHERE slug = 'kth-largest-stream';
UPDATE problems SET description = REPLACE(description, '`add(', '`record(') WHERE slug = 'kth-largest-stream';

-- minimum-stack: MinStack -> LowTrackStack
UPDATE problems SET title = 'Low-Tracking Stack' WHERE slug = 'minimum-stack';
UPDATE test_cases SET input = REPLACE(input, '"MinStack"', '"LowTrackStack"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack');
UPDATE problems SET description = REPLACE(description, '`MinStack`', '`LowTrackStack`') WHERE slug = 'minimum-stack';
UPDATE problems SET description = REPLACE(description, 'MinStack', 'LowTrackStack') WHERE slug = 'minimum-stack';

-- prefix-tree: Trie -> PrefixIndex
UPDATE problems SET title = 'Prefix Index' WHERE slug = 'prefix-tree';
UPDATE test_cases SET input = REPLACE(input, '"Trie"', '"PrefixIndex"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'prefix-tree');
UPDATE problems SET description = REPLACE(description, '`Trie`', '`PrefixIndex`') WHERE slug = 'prefix-tree';
UPDATE problems SET description = REPLACE(description, 'Trie', 'PrefixIndex') WHERE slug = 'prefix-tree';

-- random-set: RandomSet -> RandomBag
UPDATE problems SET title = 'Random-Pick Bag' WHERE slug = 'random-set';
UPDATE test_cases SET input = REPLACE(input, '"RandomSet"', '"RandomBag"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set');
UPDATE test_cases SET input = REPLACE(input, '"getRandom"', '"drawRandom"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set');
UPDATE problems SET description = REPLACE(description, '`RandomSet`', '`RandomBag`') WHERE slug = 'random-set';
UPDATE problems SET description = REPLACE(description, 'RandomSet', 'RandomBag') WHERE slug = 'random-set';
UPDATE problems SET description = REPLACE(description, '`getRandom`', '`drawRandom`') WHERE slug = 'random-set';
UPDATE problems SET description = REPLACE(description, '`getRandom(', '`drawRandom(') WHERE slug = 'random-set';

-- recent-cache: RecentCache -> RecentRegistry
UPDATE problems SET title = 'Least-Recent Registry' WHERE slug = 'recent-cache';
UPDATE test_cases SET input = REPLACE(input, '"RecentCache"', '"RecentRegistry"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache');
UPDATE test_cases SET input = REPLACE(input, '"get"', '"lookup"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache');
UPDATE test_cases SET input = REPLACE(input, '"put"', '"store"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache');
UPDATE problems SET description = REPLACE(description, '`RecentCache`', '`RecentRegistry`') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, 'RecentCache', 'RecentRegistry') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, '`get`', '`lookup`') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, '`get(', '`lookup(') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, '`put`', '`store`') WHERE slug = 'recent-cache';
UPDATE problems SET description = REPLACE(description, '`put(', '`store(') WHERE slug = 'recent-cache';

-- ring-buffer: RingBuffer -> FixedRing
UPDATE problems SET title = 'Fixed-Length Ring Buffer' WHERE slug = 'ring-buffer';
UPDATE test_cases SET input = REPLACE(input, '"RingBuffer"', '"FixedRing"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer');
UPDATE test_cases SET input = REPLACE(input, '"enQueue"', '"push"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer');
UPDATE test_cases SET input = REPLACE(input, '"deQueue"', '"pull"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ring-buffer');
UPDATE problems SET description = REPLACE(description, '`RingBuffer`', '`FixedRing`') WHERE slug = 'ring-buffer';
UPDATE problems SET description = REPLACE(description, 'RingBuffer', 'FixedRing') WHERE slug = 'ring-buffer';
UPDATE problems SET description = REPLACE(description, '`enQueue`', '`push`') WHERE slug = 'ring-buffer';
UPDATE problems SET description = REPLACE(description, '`enQueue(', '`push(') WHERE slug = 'ring-buffer';
UPDATE problems SET description = REPLACE(description, '`deQueue`', '`pull`') WHERE slug = 'ring-buffer';
UPDATE problems SET description = REPLACE(description, '`deQueue(', '`pull(') WHERE slug = 'ring-buffer';

-- running-median: MedianTracker -> StreamMedian
UPDATE problems SET title = 'Running Median Tracker' WHERE slug = 'running-median';
UPDATE test_cases SET input = REPLACE(input, '"MedianTracker"', '"StreamMedian"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median');
UPDATE test_cases SET input = REPLACE(input, '"addNum"', '"record"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median');
UPDATE test_cases SET input = REPLACE(input, '"findMedian"', '"median"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median');
UPDATE problems SET description = REPLACE(description, '`MedianTracker`', '`StreamMedian`') WHERE slug = 'running-median';
UPDATE problems SET description = REPLACE(description, 'MedianTracker', 'StreamMedian') WHERE slug = 'running-median';
UPDATE problems SET description = REPLACE(description, '`addNum`', '`record`') WHERE slug = 'running-median';
UPDATE problems SET description = REPLACE(description, '`addNum(', '`record(') WHERE slug = 'running-median';
UPDATE problems SET description = REPLACE(description, '`findMedian`', '`median`') WHERE slug = 'running-median';
UPDATE problems SET description = REPLACE(description, '`findMedian(', '`median(') WHERE slug = 'running-median';

-- stack-queue: StackQueue -> QueueFromStacks
UPDATE problems SET title = 'Queue Built from Stacks' WHERE slug = 'stack-queue';
UPDATE test_cases SET input = REPLACE(input, '"StackQueue"', '"QueueFromStacks"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stack-queue');
UPDATE problems SET description = REPLACE(description, '`StackQueue`', '`QueueFromStacks`') WHERE slug = 'stack-queue';
UPDATE problems SET description = REPLACE(description, 'StackQueue', 'QueueFromStacks') WHERE slug = 'stack-queue';

-- state-snapshots: SnapshotArray -> VersionedCells
UPDATE problems SET title = 'Versioned Cell Array' WHERE slug = 'state-snapshots';
UPDATE test_cases SET input = REPLACE(input, '"SnapshotArray"', '"VersionedCells"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots');
UPDATE test_cases SET input = REPLACE(input, '"snap"', '"commit"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots');
UPDATE test_cases SET input = REPLACE(input, '"get"', '"readAt"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots');
UPDATE problems SET description = REPLACE(description, '`SnapshotArray`', '`VersionedCells`') WHERE slug = 'state-snapshots';
UPDATE problems SET description = REPLACE(description, 'SnapshotArray', 'VersionedCells') WHERE slug = 'state-snapshots';
UPDATE problems SET description = REPLACE(description, '`snap`', '`commit`') WHERE slug = 'state-snapshots';
UPDATE problems SET description = REPLACE(description, '`snap(', '`commit(') WHERE slug = 'state-snapshots';
UPDATE problems SET description = REPLACE(description, '`get`', '`readAt`') WHERE slug = 'state-snapshots';
UPDATE problems SET description = REPLACE(description, '`get(', '`readAt(') WHERE slug = 'state-snapshots';

-- string-codec: Codec -> ListCoder
UPDATE problems SET title = 'String-List Codec' WHERE slug = 'string-codec';
UPDATE test_cases SET input = REPLACE(input, '"Codec"', '"ListCoder"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec');
UPDATE test_cases SET input = REPLACE(input, '"encode"', '"pack"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec');
UPDATE test_cases SET input = REPLACE(input, '"decode"', '"unpack"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec');
UPDATE problems SET description = REPLACE(description, '`Codec`', '`ListCoder`') WHERE slug = 'string-codec';
UPDATE problems SET description = REPLACE(description, 'Codec', 'ListCoder') WHERE slug = 'string-codec';
UPDATE problems SET description = REPLACE(description, '`encode`', '`pack`') WHERE slug = 'string-codec';
UPDATE problems SET description = REPLACE(description, '`encode(', '`pack(') WHERE slug = 'string-codec';
UPDATE problems SET description = REPLACE(description, '`decode`', '`unpack`') WHERE slug = 'string-codec';
UPDATE problems SET description = REPLACE(description, '`decode(', '`unpack(') WHERE slug = 'string-codec';

-- time-map: TimeMap -> TimestampedStore
UPDATE problems SET title = 'Timestamped Value Store' WHERE slug = 'time-map';
UPDATE test_cases SET input = REPLACE(input, '"TimeMap"', '"TimestampedStore"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map');
UPDATE test_cases SET input = REPLACE(input, '"set"', '"write"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map');
UPDATE test_cases SET input = REPLACE(input, '"get"', '"readAt"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map');
UPDATE problems SET description = REPLACE(description, '`TimeMap`', '`TimestampedStore`') WHERE slug = 'time-map';
UPDATE problems SET description = REPLACE(description, 'TimeMap', 'TimestampedStore') WHERE slug = 'time-map';
UPDATE problems SET description = REPLACE(description, '`set`', '`write`') WHERE slug = 'time-map';
UPDATE problems SET description = REPLACE(description, '`set(', '`write(') WHERE slug = 'time-map';
UPDATE problems SET description = REPLACE(description, '`get`', '`readAt`') WHERE slug = 'time-map';
UPDATE problems SET description = REPLACE(description, '`get(', '`readAt(') WHERE slug = 'time-map';

-- tree-codec: Codec -> TreeSerializer
UPDATE problems SET title = 'Binary Tree Serializer' WHERE slug = 'tree-codec';
UPDATE test_cases SET input = REPLACE(input, '"Codec"', '"TreeSerializer"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec');
UPDATE test_cases SET input = REPLACE(input, '"serialize"', '"pack"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec');
UPDATE test_cases SET input = REPLACE(input, '"deserialize"', '"unpack"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec');
UPDATE problems SET description = REPLACE(description, '`Codec`', '`TreeSerializer`') WHERE slug = 'tree-codec';
UPDATE problems SET description = REPLACE(description, 'Codec', 'TreeSerializer') WHERE slug = 'tree-codec';
UPDATE problems SET description = REPLACE(description, '`serialize`', '`pack`') WHERE slug = 'tree-codec';
UPDATE problems SET description = REPLACE(description, '`serialize(', '`pack(') WHERE slug = 'tree-codec';
UPDATE problems SET description = REPLACE(description, '`deserialize`', '`unpack`') WHERE slug = 'tree-codec';
UPDATE problems SET description = REPLACE(description, '`deserialize(', '`unpack(') WHERE slug = 'tree-codec';

-- word-dictionary: WordDictionary -> WildcardLexicon
UPDATE problems SET title = 'Wildcard Lexicon' WHERE slug = 'word-dictionary';
UPDATE test_cases SET input = REPLACE(input, '"WordDictionary"', '"WildcardLexicon"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary');
UPDATE test_cases SET input = REPLACE(input, '"addWord"', '"enroll"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary');
UPDATE test_cases SET input = REPLACE(input, '"search"', '"match"') WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary');
UPDATE problems SET description = REPLACE(description, '`WordDictionary`', '`WildcardLexicon`') WHERE slug = 'word-dictionary';
UPDATE problems SET description = REPLACE(description, 'WordDictionary', 'WildcardLexicon') WHERE slug = 'word-dictionary';
UPDATE problems SET description = REPLACE(description, '`addWord`', '`enroll`') WHERE slug = 'word-dictionary';
UPDATE problems SET description = REPLACE(description, '`addWord(', '`enroll(') WHERE slug = 'word-dictionary';
UPDATE problems SET description = REPLACE(description, '`search`', '`match`') WHERE slug = 'word-dictionary';
UPDATE problems SET description = REPLACE(description, '`search(', '`match(') WHERE slug = 'word-dictionary';

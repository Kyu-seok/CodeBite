-- Phase 3 Batch 4: Heap (#130-134) + Backtracking (#135-138)
-- 9 problems: job-scheduler, feed-designer, running-median, rearrange-letters, frequent-words, unique-subsets, unique-combinations, palindrome-split, ip-builder

------------------------------------------------------------
-- Add Job Scheduler problem
-- CodeBite original name: Job Scheduler (inspired by Task Scheduler, LC #621)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Job Scheduler',
    'job-scheduler',
    'You are given an array of jobs represented by characters, where each character identifies the job type. You are also given an integer `n` representing the **cooldown period** between two identical jobs.

Each time unit, you can either execute one job or stay idle. Identical jobs must be separated by at least `n` time units. Jobs can be completed in any order.

Return the **minimum number of time units** needed to finish all the given jobs.

**Example 1:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 2
Output: 8
Explanation: One valid schedule is A -> B -> idle -> A -> B -> idle -> A -> B. There are 8 total intervals.
```

**Example 2:**
```
Input: jobs = ["A","C","A","B","D","B"], n = 1
Output: 6
Explanation: One valid schedule is A -> B -> C -> D -> A -> B. No idle time is needed since all identical jobs are already spaced apart.
```

**Example 3:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 0
Output: 6
Explanation: With no cooldown, all jobs can run back to back in 6 intervals.
```',
    'MEDIUM',
    '1 <= jobs.length <= 10^4
jobs[i] is an uppercase English letter
0 <= n <= 100',
    130,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","B","B","B"]\n2', '8', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","C","A","B","D","B"]\n1', '6', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","B","B","B"]\n0', '6', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","A","A","B","C","D","E","F","G"]\n1', '12', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A"]\n0', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","B","B","B"]\n3', '10', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","B","B","B","C","C"]\n2', '10', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'job-scheduler';

------------------------------------------------------------
-- Add Feed Designer problem
-- CodeBite original name: Feed Designer (inspired by Design Twitter, LC #355)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Feed Designer',
    'feed-designer',
    'Design a simple social feed system that supports posting messages, following and unfollowing users, and retrieving a user''s news feed.

Implement the `FeedDesigner` class:

- `FeedDesigner()` Initializes the feed system.
- `postMessage(userId, messageId)` Creates a new message with the given `messageId` posted by user `userId`. Each `messageId` is unique.
- `getNewsFeed(userId)` Returns a list of the 10 most recent message IDs in the user''s news feed. The feed should contain messages posted by the user themselves and by anyone they follow. Messages must be ordered from most recent to least recent.
- `follow(followerId, followeeId)` The user `followerId` starts following the user `followeeId`. If `followerId == followeeId`, do nothing.
- `unfollow(followerId, followeeId)` The user `followerId` stops following the user `followeeId`. If `followerId == followeeId`, do nothing.

**Example 1:**
```
Input: ["FeedDesigner","postMessage","postMessage","getNewsFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
Explanation: User 1 posts two messages. Their feed shows the most recent first.
```

**Example 2:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
Explanation: User 1 follows user 2. User 1''s feed now includes user 2''s posts.
```

**Example 3:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
Explanation: After unfollowing user 2, user 1''s feed no longer shows user 2''s messages.
```',
    'MEDIUM',
    '`1 <= userId, followerId, followeeId <= 500`\n`0 <= messageId <= 10^4`\nAt most `3 * 10^4` calls total across all methods.',
    131,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","getNewsFeed"]\n[[],[1,10],[1,20],[1]]', '[null,null,null,[20,10]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]\n[[],[1,10],[2,20],[1,2],[1]]', '[null,null,null,null,[20,10]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]\n[[],[1,10],[2,20],[1,2],[1],[1,2],[1]]', '[null,null,null,null,[20,10],null,[10]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","getNewsFeed"]\n[[],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[1,9],[1,10],[1,11],[1]]', '[null,null,null,null,null,null,null,null,null,null,null,null,[11,10,9,8,7,6,5,4,3,2]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","follow","getNewsFeed","postMessage","getNewsFeed"]\n[[],[1,1],[1],[1,50],[1]]', '[null,null,[],null,[50]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","postMessage","postMessage","follow","follow","getNewsFeed"]\n[[],[1,5],[2,3],[1,10],[2,8],[3,1],[3,2],[3]]', '[null,null,null,null,null,null,null,[8,10,3,5]]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'feed-designer'),
    'en',
    'Feed Designer',
    'Design a simple social feed system that supports posting messages, following and unfollowing users, and retrieving a user''s news feed.

Implement the `FeedDesigner` class:

- `FeedDesigner()` Initializes the feed system.
- `postMessage(userId, messageId)` Creates a new message with the given `messageId` posted by user `userId`. Each `messageId` is unique.
- `getNewsFeed(userId)` Returns a list of the 10 most recent message IDs in the user''s news feed. The feed should contain messages posted by the user themselves and by anyone they follow. Messages must be ordered from most recent to least recent.
- `follow(followerId, followeeId)` The user `followerId` starts following the user `followeeId`. If `followerId == followeeId`, do nothing.
- `unfollow(followerId, followeeId)` The user `followerId` stops following the user `followeeId`. If `followerId == followeeId`, do nothing.

**Example 1:**
```
Input: ["FeedDesigner","postMessage","postMessage","getNewsFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
Explanation: User 1 posts two messages. Their feed shows the most recent first.
```

**Example 2:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
Explanation: User 1 follows user 2. User 1''s feed now includes user 2''s posts.
```

**Example 3:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
Explanation: After unfollowing user 2, user 1''s feed no longer shows user 2''s messages.
```',
    '`1 <= userId, followerId, followeeId <= 500`\n`0 <= messageId <= 10^4`\nAt most `3 * 10^4` calls total across all methods.'
);

------------------------------------------------------------
-- Add Running Median problem
-- CodeBite original name: Running Median (inspired by Find Median from Data Stream, LC #295)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Running Median',
    'running-median',
    'Design a data structure that supports adding integers one at a time and efficiently retrieving the median of all elements added so far.

Implement the `MedianTracker` class:

- `MedianTracker()` Initializes the data structure.
- `addNum(num)` Adds the integer `num` to the collection.
- `findMedian()` Returns the median of all elements added so far. If the total count is even, the median is the average of the two middle values. The result should be a floating-point number.

**Example 1:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]
       [[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
Explanation: After adding 1, the median is 1.0. After adding 2, the median of [1, 2] is 1.5. After adding 3, the median of [1, 2, 3] is 2.0.
```

**Example 2:**
```
Input: ["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]
       [[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
Explanation: The sorted collection is [2, 3, 4, 5]. The median of four elements is (3 + 4) / 2 = 3.5.
```

**Example 3:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian"]
       [[],[7],[],[3],[]]
Output: [null,null,7.0,null,5.0]
Explanation: After adding 7, the median is 7.0. After adding 3, the median of [3, 7] is (3 + 7) / 2 = 5.0.
```',
    'HARD',
    '-10^5 <= num <= 10^5
At most 5 * 10^4 calls will be made to addNum and findMedian
findMedian is always called after at least one addNum call',
    132,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]\n[[],[1],[],[2],[],[3],[]]', '[null,null,1.0,null,1.5,null,2.0]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]\n[[],[4],[2],[5],[3],[]]', '[null,null,null,null,null,3.5]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian","addNum","findMedian"]\n[[],[7],[],[3],[]]', '[null,null,7.0,null,5.0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","addNum","addNum","findMedian"]\n[[],[5],[5],[5],[5],[5],[]]', '[null,null,null,null,null,null,5.0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian","addNum","findMedian","addNum","findMedian"]\n[[],[10],[],[20],[],[30],[],[40],[],[50],[]]', '[null,null,10.0,null,15.0,null,20.0,null,25.0,null,30.0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","findMedian","addNum","findMedian"]\n[[],[-1],[-2],[-3],[],[-4],[]]', '[null,null,null,null,-2.0,null,-2.5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian","addNum","findMedian"]\n[[],[1],[],[1000000],[],[2],[],[999999],[]]', '[null,null,1.0,null,500000.5,null,2.0,null,500000.5]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'running-median'),
    'en',
    'Running Median',
    'Design a data structure that supports adding integers one at a time and efficiently retrieving the median of all elements added so far.

Implement the `MedianTracker` class:

- `MedianTracker()` Initializes the data structure.
- `addNum(num)` Adds the integer `num` to the collection.
- `findMedian()` Returns the median of all elements added so far. If the total count is even, the median is the average of the two middle values. The result should be a floating-point number.

**Example 1:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]
       [[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
Explanation: After adding 1, the median is 1.0. After adding 2, the median of [1, 2] is 1.5. After adding 3, the median of [1, 2, 3] is 2.0.
```

**Example 2:**
```
Input: ["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]
       [[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
Explanation: The sorted collection is [2, 3, 4, 5]. The median of four elements is (3 + 4) / 2 = 3.5.
```

**Example 3:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian"]
       [[],[7],[],[3],[]]
Output: [null,null,7.0,null,5.0]
Explanation: After adding 7, the median is 7.0. After adding 3, the median of [3, 7] is (3 + 7) / 2 = 5.0.
```',
    '-10^5 <= num <= 10^5
At most 5 * 10^4 calls will be made to addNum and findMedian
findMedian is always called after at least one addNum call'
);

------------------------------------------------------------
-- Add Rearrange Letters problem
-- CodeBite original name: Rearrange Letters (inspired by Reorganize String, LC #767)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Rearrange Letters',
    'rearrange-letters',
    'Given a string `s`, rearrange its characters so that no two adjacent characters are the same.

Return any valid rearrangement. If no valid rearrangement is possible, return an empty string `""`.

**Example 1:**
```
Input: s = "aab"
Output: "aba"
```

**Example 2:**
```
Input: s = "aaab"
Output: ""
Explanation: No matter how the letters are arranged, two ''a''s will always be next to each other.
```

**Example 3:**
```
Input: s = "aabb"
Output: "abab"
```',
    'MEDIUM',
    '1 <= s.length <= 500
s consists of lowercase English letters only',
    133,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aab', 'valid', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaab', '', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aabb', 'valid', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'a', 'valid', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaabbbccc', 'valid', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaaaabc', '', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'abcdef', 'valid', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaaaabbbbbccccc', 'valid', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rearrange-letters'),
    'en',
    'Rearrange Letters',
    'Given a string `s`, rearrange its characters so that no two adjacent characters are the same.

Return any valid rearrangement. If no valid rearrangement is possible, return an empty string `""`.

**Example 1:**
```
Input: s = "aab"
Output: "aba"
```

**Example 2:**
```
Input: s = "aaab"
Output: ""
Explanation: No matter how the letters are arranged, two ''a''s will always be next to each other.
```

**Example 3:**
```
Input: s = "aabb"
Output: "abab"
```',
    '1 <= s.length <= 500
s consists of lowercase English letters only'
);

------------------------------------------------------------
-- Add Frequent Words problem
-- CodeBite original name: Frequent Words (inspired by Top K Frequent Words, LC #692)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Frequent Words',
    'frequent-words',
    'Given a list of words `words` and an integer `k`, return the `k` most frequently occurring words. The result should be sorted by frequency in descending order. If two or more words have the same frequency, sort them in alphabetical order.

**Example 1:**
```
Input: words = ["apple","banana","apple","cherry","banana","apple"], k = 2
Output: ["apple","banana"]
Explanation: "apple" appears 3 times, "banana" appears 2 times. These are the 2 most frequent words.
```

**Example 2:**
```
Input: words = ["yes","yes","no","no","maybe"], k = 3
Output: ["no","yes","maybe"]
Explanation: "yes" and "no" both appear 2 times, so they are ordered alphabetically. "maybe" appears once.
```

**Example 3:**
```
Input: words = ["hello","world","hello"], k = 1
Output: ["hello"]
```',
    'MEDIUM',
    '1 <= words.length <= 500
1 <= words[i].length <= 10
words[i] consists of lowercase English letters
k is in the range [1, number of unique words]
The answer is guaranteed to be unique',
    134,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["apple","banana","apple","cherry","banana","apple"]\n2', '["apple","banana"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["yes","yes","no","no","maybe"]\n3', '["no","yes","maybe"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["hello","world","hello"]\n1', '["hello"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["a","b","c","d","e"]\n5', '["a","b","c","d","e"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["x","x","x","y","y","z"]\n1', '["x"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["the","day","is","the","the","sunny","is","is","sunny"]\n4', '["is","the","day","sunny"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["code","code","code","bite","bite","algo"]\n2', '["code","bite"]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'frequent-words'),
    'en',
    'Frequent Words',
    'Given a list of words `words` and an integer `k`, return the `k` most frequently occurring words. The result should be sorted by frequency in descending order. If two or more words have the same frequency, sort them in alphabetical order.

**Example 1:**
```
Input: words = ["apple","banana","apple","cherry","banana","apple"], k = 2
Output: ["apple","banana"]
Explanation: "apple" appears 3 times, "banana" appears 2 times. These are the 2 most frequent words.
```

**Example 2:**
```
Input: words = ["yes","yes","no","no","maybe"], k = 3
Output: ["no","yes","maybe"]
Explanation: "yes" and "no" both appear 2 times, so they are ordered alphabetically. "maybe" appears once.
```

**Example 3:**
```
Input: words = ["hello","world","hello"], k = 1
Output: ["hello"]
```',
    '1 <= words.length <= 500
1 <= words[i].length <= 10
words[i] consists of lowercase English letters
k is in the range [1, number of unique words]
The answer is guaranteed to be unique'
);

------------------------------------------------------------
-- Add Unique Subsets problem
-- CodeBite original name: Unique Subsets (inspired by Subsets II, LC #90)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Unique Subsets',
    'unique-subsets',
    'Given an integer array `nums` that may contain **duplicate** values, return all possible subsets (the power set). The result must **not** contain duplicate subsets. You may return the subsets in any order.

**Example 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```

**Example 3:**
```
Input: nums = [4,4,4,1,4]
Output: [[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]
Explanation: Despite duplicates in the input, each subset appears only once.
```',
    'MEDIUM',
    '1 <= nums.length <= 10
-10 <= nums[i] <= 10',
    135,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1,2,2]', '[[],[1],[1,2],[1,2,2],[2],[2,2]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[0]', '[[],[0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[4,4,4,1,4]', '[[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1,1]', '[[],[1],[1,1]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[3,1,2,2]', '[[],[1],[1,2],[1,2,2],[1,2,2,3],[1,2,3],[1,3],[2],[2,2],[2,2,3],[2,3],[3]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[5,5,5,5]', '[[],[5],[5,5],[5,5,5],[5,5,5,5]]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-subsets'),
    'en',
    'Unique Subsets',
    'Given an integer array `nums` that may contain **duplicate** values, return all possible subsets (the power set). The result must **not** contain duplicate subsets. You may return the subsets in any order.

**Example 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```

**Example 3:**
```
Input: nums = [4,4,4,1,4]
Output: [[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]
Explanation: Despite duplicates in the input, each subset appears only once.
```',
    '1 <= nums.length <= 10
-10 <= nums[i] <= 10'
);

------------------------------------------------------------
-- Add Unique Combinations problem
-- CodeBite original name: Unique Combinations (inspired by Combination Sum II, LC #40)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Unique Combinations',
    'unique-combinations',
    'Given a collection of integers `candidates` (which may contain duplicates) and a `target` number, find all unique combinations in `candidates` where the selected values sum to `target`.

Each number in `candidates` may only be used **once** per combination. The solution set must not contain duplicate combinations.

**Example 1:**
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]
```

**Example 2:**
```
Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**Example 3:**
```
Input: candidates = [1,1,1,1], target = 2
Output: [[1,1]]
Explanation: Although 1 appears four times, the only way to reach 2 is by picking two 1s. Duplicate combinations are excluded.
```',
    'MEDIUM',
    '1 <= candidates.length <= 100
1 <= candidates[i] <= 50
1 <= target <= 30',
    136,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[10,1,2,7,6,1,5]\n8', '[[1,1,6],[1,2,5],[1,7],[2,6]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[2,5,2,1,2]\n5', '[[1,2,2],[5]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1,1,1,1]\n2', '[[1,1]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[3,1,3,5,1,1]\n8', '[[1,1,1,5],[1,1,3,3],[3,5]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1]\n1', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1]\n2', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[2,2,2,2,2]\n4', '[[2,2]]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-combinations'),
    'en',
    'Unique Combinations',
    'Given a collection of integers `candidates` (which may contain duplicates) and a `target` number, find all unique combinations in `candidates` where the selected values sum to `target`.

Each number in `candidates` may only be used **once** per combination. The solution set must not contain duplicate combinations.

**Example 1:**
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]
```

**Example 2:**
```
Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**Example 3:**
```
Input: candidates = [1,1,1,1], target = 2
Output: [[1,1]]
Explanation: Although 1 appears four times, the only way to reach 2 is by picking two 1s. Duplicate combinations are excluded.
```',
    '1 <= candidates.length <= 100
1 <= candidates[i] <= 50
1 <= target <= 30'
);

------------------------------------------------------------
-- Add Palindrome Split problem
-- CodeBite original name: Palindrome Split (inspired by Palindrome Partitioning, LC #131)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Palindrome Split',
    'palindrome-split',
    'Given a string `s`, split it into segments where **every** segment is a palindrome. Return all possible ways to perform such a split.

The segments in each split must cover the entire string without reordering characters. You may return the splits in any order.

**Example 1:**
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]
```

**Example 2:**
```
Input: s = "a"
Output: [["a"]]
```

**Example 3:**
```
Input: s = "aba"
Output: [["a","b","a"],["aba"]]
Explanation: Both "a", "b", "a" (each single character) and "aba" (the whole string) are valid palindrome splits.
```',
    'MEDIUM',
    '1 <= s.length <= 16
s contains only lowercase English letters.',
    137,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aab', '[["a","a","b"],["aa","b"]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'a', '[["a"]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aba', '[["a","b","a"],["aba"]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aaa', '[["a","a","a"],["a","aa"],["aa","a"],["aaa"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'abba', '[["a","b","b","a"],["a","bb","a"],["abba"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aabb', '[["a","a","b","b"],["a","a","bb"],["aa","b","b"],["aa","bb"]]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'palindrome-split'),
    'en',
    'Palindrome Split',
    'Given a string `s`, split it into segments where **every** segment is a palindrome. Return all possible ways to perform such a split.

The segments in each split must cover the entire string without reordering characters. You may return the splits in any order.

**Example 1:**
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]
```

**Example 2:**
```
Input: s = "a"
Output: [["a"]]
```

**Example 3:**
```
Input: s = "aba"
Output: [["a","b","a"],["aba"]]
Explanation: Both "a", "b", "a" (each single character) and "aba" (the whole string) are valid palindrome splits.
```',
    '1 <= s.length <= 16
s contains only lowercase English letters.'
);

------------------------------------------------------------
-- Add IP Builder problem
-- CodeBite original name: IP Builder (inspired by Restore IP Addresses, LC #93)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'IP Builder',
    'ip-builder',
    'Given a string `s` containing only digits, return all possible valid IPv4 addresses that can be formed by placing exactly three dots into the string.

A valid IPv4 address consists of exactly four integers (called octets), each ranging from `0` to `255`, separated by dots. An octet must **not** have leading zeros unless the octet itself is `0`.

Return the result as a sorted list of strings.

**Example 1:**
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]
```

**Example 2:**
```
Input: s = "0000"
Output: ["0.0.0.0"]
```

**Example 3:**
```
Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]
```',
    'MEDIUM',
    '1 <= s.length <= 20
s consists of digits only.',
    138,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '25525511135', '["255.255.11.135","255.255.111.35"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '0000', '["0.0.0.0"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '101023', '["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '1111', '["1.1.1.1"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '010010', '["0.10.0.10","0.100.1.0"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '256256256256', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '12', '[]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ip-builder'),
    'en',
    'IP Builder',
    'Given a string `s` containing only digits, return all possible valid IPv4 addresses that can be formed by placing exactly three dots into the string.

A valid IPv4 address consists of exactly four integers (called octets), each ranging from `0` to `255`, separated by dots. An octet must **not** have leading zeros unless the octet itself is `0`.

Return the result as a sorted list of strings.

**Example 1:**
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]
```

**Example 2:**
```
Input: s = "0000"
Output: ["0.0.0.0"]
```

**Example 3:**
```
Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]
```',
    '1 <= s.length <= 20
s consists of digits only.'
);


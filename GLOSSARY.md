# CodeBite

A code practice platform where users solve problems, submit code for judging, and are motivated to practise daily.

## Language

### Problems

**Slug**:
A problem's current name in its URL, and the name its Driver and Starter Code are filed under. It changes only by a Restatement, never by editing the title.

**Former Slug**:
A Slug a problem had before a Restatement. It still finds the problem, so old links keep working, and is never given to another problem.
_Avoid_: Old slug, redirect

**Restatement**:
Rewording a problem without changing what is asked: its Test Cases, and so the algorithm that solves it, stay the same, while its Slug, title, description, constraints and the names in its Starter Code may change. A change to the Test Cases makes it a different problem, not a Restatement, unless it is a Test Case Correction.
_Avoid_: Rename, rewrite, retheme

**Test Case Correction**:
Changing a problem's Test Cases so they agree with its statement, where a case breaks what the statement promises about its input or expects a wrong output. The statement is the truth and the problem stays the same problem; a statement that promises the wrong thing calls for a Restatement instead.
_Avoid_: Regenerating test cases, test case fix

**Problem Report**:
A user's report that something in a problem is wrong (a Test Case, the description, the Starter Code), made from the problem page or from a Failing Case. CodeBite doesn't receive it: the user posts it publicly themselves, so it never carries a hidden case's input or expected output.
_Avoid_: Bug report, feedback, ticket

**Diagram**:
A picture of an example's input (and, when the problem transforms it, the output), or of its output alone when the output is the structure and the input is just a size, drawn from a short text block in the problem's description and the same in every language. A Restatement keeps it.
_Avoid_: Visual aid, image, illustration

### Grading

**Verdict**:
The outcome of grading one program against an ordered list of test cases: a status for each case and an overall status, which is the status of the first judged case that is not Accepted, or Accepted when there is none. A submission's Verdict is announced to the rest of the system (the live result push, stats, Streak Days, Solution Commits) only once it is stored; the announcement is a notification of the Verdict, not the Verdict itself.
_Avoid_: Result, outcome, overall status

**Failing Case**:
The case a Verdict's overall status comes from: the first judged case, in order, that is not Accepted. An Accepted Verdict has none, and neither does a program that failed to compile or a case CodeBite itself failed to run. A submission shows its Failing Case's input, expected output and actual output, hidden or not, unless the user has chosen not to see them.
_Avoid_: Failed test, first failure, wrong case

**Unjudged Case**:
A custom test case the user gave no expected output for. It runs and shows its output, and counts against the Verdict only if the program fails to compile, crashes or exceeds its time limit.
_Avoid_: Free run, output-only case

**Language**:
One of the codes CodeBite accepts in a submission (`java`, `python`, `javascript`, `cpp`), each bound to one active Judge0 language id.
_Avoid_: Runtime, language id (that is Judge0's)

**Driver**:
The per-problem, per-Language source that reads stdin, calls the user's code at `{USER_CODE}` and prints the answer.
_Avoid_: Template, harness, wrapper

**Starter Code**:
The per-problem, per-Language stub shown in the editor, defining the method the Driver calls.

**Program**:
The Driver with the user's code substituted, as sent to Judge0; the only thing that knows which combined line is which user line.

**Library**:
Shared Driver source (`ListNode`, `JsonOutput`) spliced in at a `{{LIB:Name}}` marker.

**Abandoned**:
A submission that stayed PENDING past the re-drive window and was closed as INTERNAL_ERROR without ever being judged. Distinct from a submission that failed after the worker's retries.
_Avoid_: Expired, timed out

### Streaks

**Streak**:
The number of consecutive Streak Days and Repaired Days ending today or yesterday, shown on the user's profile as the current and best streak.
_Avoid_: Solve streak, activity streak, profile streak

**Streak Day**:
A UTC calendar day on which the user made at least one Accepted, non-admin submission. Once earned, it is never taken away.
_Avoid_: Active day, activity day

**Missed Day**:
A past day, after the user's first Streak Day, that is neither a Streak Day nor a Repaired Day.
_Avoid_: Gap, break, hole

**Repaired Day**:
A Missed Day that the user chose to fill by spending one Repair. It counts toward the Streak and Best Streak, but not toward Repair Progress.

**Repair**:
An earned item that turns one Missed Day of the user's choosing into a Repaired Day. A user holds at most five.
_Avoid_: Repair point, streak freeze, token

**Repair Progress**:
The count of Streak Days, from 0 to 4, toward the next Repair. The fifth earns a Repair and returns it to 0; a Missed Day never resets it.
_Avoid_: Repair streak

**Review Streak**:
The number of consecutive days with a completed Review, ending today or yesterday like the Streak, tracked independently of it.

### Reviews

**Review**:
A Confidence given to one judged submission, timestamped at that moment. Re-rating a submission replaces its Review and its timestamp.
_Avoid_: Rating, grade

**Confidence**:
One of Again, Hard, Good, Easy, chosen in a Review.
_Avoid_: Score, difficulty felt

**Review Schedule**:
What replaying all of a user's Reviews of one problem in timestamp order through SM-2 lite yields: review count, ease, interval, next due moment and whether Mastered. The Reviews are the source of truth; the stored row is a snapshot.
_Avoid_: Review state, SM-2 cache

**Due**:
A problem whose Review Schedule's next due moment is at or before now.

**Mastered**:
A problem with at least three Reviews, the last two Good or Easy, and an interval of 30 days or more; recomputed on every Review and can be lost.

### Progress

**Solved**:
A problem to which the user has at least one Accepted, non-admin submission. Once Solved, always Solved.
_Avoid_: Completed, passed, done, "has accepted"

**Attempted**:
A problem the user has a graded, non-admin submission to but has not Solved. A pending submission makes a problem neither Solved nor Attempted.

**Progress**:
A user's Solved and Attempted problems, and their counts by difficulty and tag against the published catalogue.
_Avoid_: Stats, score

**Activity**:
The number of submissions of any status a user made on a UTC day; the profile heatmap. An Activity day is not a Streak Day unless one of them was Accepted.
_Avoid_: Active day, heatmap day

**Acceptance Rate**:
Per problem, the share of graded non-admin submissions that were Accepted, as a percentage to one decimal. A problem nobody has been graded on has none.
_Avoid_: Pass rate, success rate, solve rate

### Onboarding

**Tutorial**:
A newcomer's guided first solve of the Tutorial Problem, from reading it to its first Accepted. Anyone can start it, signed in or not; it can be skipped at any step and replayed from the start.
_Avoid_: Onboarding tour, walkthrough

**Tutorial Problem**:
The one real, published problem the Tutorial runs on. Solving it counts like any other problem (Solved, a Streak Day, a Solution Commit), but it belongs to no curation and is never recommended.

**Tip**:
A short explanation shown to a user the first time something happens to them, on any problem (their first Wrong Answer, their first Accepted, ...), until they dismiss it.
_Avoid_: Hint (that is help with solving a problem), nudge

### GitHub

**GitHub Link**:
The connection between a CodeBite user and one GitHub account and its Solution Repository, through which Accepted submissions are committed. It is separate from signing in with GitHub, and its GitHub account need not be the one the user signs in with.
_Avoid_: GitHub integration, GitHub sync, connected account

**Solution Repository**:
The single repository in the GitHub account's own space that receives the user's Solution Commits. The user creates it on GitHub as part of linking, under the name they pick in CodeBite, or reuses a repository already bearing that name. Files in it are only ever added, never replaced or removed.

**Solution Commit**:
The commit that adds one Accepted submission, an admin's included, to the Solution Repository, dated at the moment the submission was Accepted. A Repaired Day never has one.

**Import**:
The user's one-time choice, per Solution Repository, to add all of their earlier Accepted submissions as Solution Commits, each dated when it was originally Accepted.
_Avoid_: Backfill, sync history

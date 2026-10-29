# CodeBite

A code practice platform where users solve problems, submit code for judging, and are motivated to practise daily.

## Language

### Grading

**Verdict**:
The outcome of grading one program against an ordered list of test cases: a status for each case and an overall status, which is the status of the first judged case that is not Accepted, or Accepted when there is none. A submission's Verdict is announced to the rest of the system (the live result push, stats, Streak Days, Solution Commits) only once it is stored; the announcement is a notification of the Verdict, not the Verdict itself.
_Avoid_: Result, outcome, overall status

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

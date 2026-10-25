# CodeBite

A code practice platform where users solve problems, submit code for judging, and are motivated to practise daily.

## Language

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
The number of consecutive days with a completed review, tracked independently of the Streak.

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

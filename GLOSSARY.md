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

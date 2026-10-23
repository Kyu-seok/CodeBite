# Streak Days use UTC, not the user's local timezone

A Streak Day is the UTC date of an Accepted submission, for every user. For Korean users, who are most of the audience, the day therefore ends at 09:00 KST. We chose UTC because accepted solutions will be committed to the user's GitHub repository, and GitHub dates contributions in UTC. Using UTC means a CodeBite Streak Day and a GitHub green square always fall on the same day. It also removes the need to store, capture or default a timezone per user. LeetCode makes the same choice for its daily streak.

## Considered Options

- **The user's local timezone, fixed when the submission is made.** This matches the user's real day. But a submission made between 00:00 and 09:00 KST would land on a different GitHub day than CodeBite day, so the two streaks would visibly disagree.
- **Fixed KST for everyone.** This has the same disagreement with GitHub, and it is wrong for users outside Korea.

## Consequences

Changing this later means re-dating every stored Streak Day, which can merge or split days and change Streaks that users have already seen.

Live Streak Days are dated in Java from the submission's timestamp, so they are always UTC. The one-off backfill in `V189__add_streaks.sql` is different: it casts the stored timestamp in SQL, so it is only UTC if the backend that wrote the timestamps ran on UTC. Production does, but only by default: neither the backend image nor Postgres sets a timezone. Pinning it with `TZ` or `hibernate.jdbc.time_zone` would change how every existing timestamp is read, so it was left out of scope.

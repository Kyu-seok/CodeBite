# Test Case Corrections edit cases in place, and past Verdicts stand

A Test Case Correction changes a wrong case where it is: a migration `UPDATE`s its input and expected output, keeping its id and position, and no submission is judged again. Results already stored keep pointing at the row and keep their status. Earlier fixes regenerated cases instead (V100 and its batches deleted the hidden cases and every `submission_results` row that named them), which erased each affected submission's per-case history for the sake of the cases that were actually wrong.

## Considered Options

- **Delete the results and replace the cases**, as the regeneration batches did. The data stays consistent, but every submission graded on those cases loses its results, right ones included.
- **Add a corrected case and retire the old one**, keeping both. History stays exact, but it needs a retired flag that every grading and progress read must then respect, for a fix that touches a few rows a year.
- **Re-judge past submissions** after the correction. An old Wrong Answer could become Accepted, which would move Solved counts, Streak Days, Reviews and Solution Commits after the fact. Re-judging would need a design of its own.

## Consequences

An old submission whose Failing Case was the corrected case shows the corrected input and expected output next to the output it printed for the old input. A user judged Wrong Answer because of the wrong case stays Wrong Answer until they submit again, so a correction that came from a Problem Report ends by asking its reporter to resubmit.

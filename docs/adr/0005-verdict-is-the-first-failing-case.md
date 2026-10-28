# A Verdict is the first failing case in order

When a program is graded against several test cases, its Verdict's overall status is the status of the first case, in order, that is judged and not Accepted; if there is none, the Verdict is Accepted. Submit grades every test case and still reports the first failure, so the stored results show full coverage while the headline status is stable and easy to reason about: it names the earliest case the user would have hit working through them in order, which is where problem authors put the simplest inputs. Run stops at the first failing sample and never runs the custom cases unless every sample passed, because Run is a quick feedback loop and a failing sample makes the rest noise. Custom cases never stop one another: the user chose them and wants to see each one. An Unjudged Case counts only when the program fails to compile, crashes or exceeds its time limit; a program that merely prints something cannot be wrong about an output nobody specified.

The rule lives in one place, the Grader (`common/.../judge/grader`), and both Submit and Run grade through it. It used to be two hand-rolled loops, one in the worker and one in the backend, that agreed only by convention.

## Considered Options

- **Worst status wins** (Compilation Error over Runtime Error over Wrong Answer, say). Every judge that uses it needs a severity order that users then have to learn, and for the common case, one wrong case among many, it reports the same thing as first-failure. It also hides which case to look at first.
- **Submit stops at the first failure too.** It would save Judge0 work, but the user would lose the per-case results they get today, and a batch to Judge0 already runs every case in one round trip.
- **Run grades the samples as one batch.** It would show every sample result on a failure instead of the prefix. That is a visible product change for the frontend and was left out of this move; the Grader makes it a one-line switch if it is wanted.

## Consequences

Changing the overall rule or the stopping rule is a change to the Grader and this ADR, not an edit in a caller. A Verdict's cases are always in input order, and after `gradeUntilFailure` they are a prefix of the input, so callers may index them back against their test cases by position.

Because an Unjudged Case can only ever contribute a non-Accepted status when the program failed outright, the Verdict of a Run with only Unjudged Cases is Accepted whenever the program ran to completion, whatever it printed.

# A submission reveals its Failing Case, hidden or not

A failed submission shows its Failing Case, the case its Verdict's status comes from, with the input, expected output and actual output, even when that case is hidden. No other hidden case is ever shown. Hidden cases used to be redacted completely: a user saw that case 7 of 42 failed and what it printed, but not what it was given or what it should have printed. Most failures happen on hidden cases (users check the samples with Run first), so the redaction left them guessing exactly when they needed help. A user who wants that guessing on purpose, to practise debugging, turns off "Show failing test case" in the editor settings. That only changes what is shown: the response still carries the case.

## Considered Options

- **Keep hidden cases redacted.** This protects the hidden set fully, but the feedback stays poor and users go looking for the inputs elsewhere.
- **Reveal every failing case.** A whole hidden set could leak in a few submissions, and the message "this is where you broke" gets lost in a list.
- **Hide the case on the server when the setting is off.** The setting is a restriction the user sets for themselves, not a security boundary, so making every submission read depend on a preference would cost more than it gives.

## Consequences

A determined user can collect hidden cases one at a time by submitting wrong answers on purpose, and so hard-code answers. We accept that, as most judges do: what a user gains that way is a solved badge, not a skill. Once a hidden case has been shown it can't be taken back, so going back to redaction later would not re-secure the cases already shown.

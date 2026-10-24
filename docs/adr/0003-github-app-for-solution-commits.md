# Solution Commits are written through a GitHub App, not an OAuth repo scope

CodeBite writes to a user's Solution Repository through a GitHub App that the user installs on that one repository, using short-lived installation tokens. The alternative, an OAuth App with the `public_repo` or `repo` scope, would mean storing a long-lived token that can write to every repository the user owns, which is too much access to ask of a code practice site. Signing in with GitHub stays a separate, read-only OAuth flow, which is why a GitHub Link is its own step even for users who signed in with GitHub.

## Consequences

Switching to an OAuth scope later would require every user to link again. The GitHub App cannot create repositories in the user's account, so the user creates the Solution Repository themselves and selects it when installing the app.

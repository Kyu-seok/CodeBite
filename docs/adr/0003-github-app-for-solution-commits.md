# Solution Commits are written through a GitHub App, not an OAuth repo scope

CodeBite writes to a user's Solution Repository through a GitHub App that the user installs on that one repository, using short-lived installation tokens. The alternative, an OAuth App with the `public_repo` or `repo` scope, would mean storing a long-lived token that can write to every repository the user owns, which is too much access to ask of a code practice site. Signing in with GitHub stays a separate, read-only OAuth flow, which is why a GitHub Link is its own step even for users who signed in with GitHub.

## Consequences

Switching to an OAuth scope later would require every user to link again. The GitHub App cannot create repositories in the user's account, so the user creates the Solution Repository themselves and selects it when installing the app.

A probe on 2026-10-25 tested the limit. The dev App was given the "Repository creation: write" permission. A user token from authorizing the App, before any installation, still got 403 "Resource not accessible by integration" on `POST /user/repos`, and an installation needs the repository to exist already. An OAuth `public_repo` or `repo` token could create it, but its consent screen asks for full control of every public or private repository, which is the access this ADR turned down. So linking guides the user instead. CodeBite opens GitHub's new-repository page prefilled with the chosen name, from a public template (`app.github.solution-repository-template`) so the repository starts with a README, and the install callback links the granted repository with that name.

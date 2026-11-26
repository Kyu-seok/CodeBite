#!/usr/bin/env bash
# PreToolUse hook (Bash): refuses `gh pr create` / `gh pr edit` with a --title
# whose squash subject would pass 72 characters. scripts/ship-branch.sh builds
# that subject as "<title> (#<n>)" and refuses it only at merge, after the PR
# has been reviewed under the long title. An edit names its PR, so its limit is
# exact; a new PR's number is unknown, so the limit leaves room for four digits.
# A title the hook cannot read (built from a variable or a command) passes.
jq -r '.tool_input.command // ""' | perl -CSDA -0ne '
  exit 0 unless /(?:^|[^\w-])gh\s+pr\s+(create|edit)\b(.*)/s;
  my ($verb, $rest) = ($1, $2);
  exit 0 unless $rest =~ /\s(?:--title|-t)(?:=|\s+)(?:"((?:[^"\\]|\\.)*)"|\x27([^\x27]*)\x27)/;
  my $title = defined $1 ? $1 : $2;
  exit 0 if defined $1 && $title =~ /[\$`]/;
  my $n = ($verb eq "edit" && $rest =~ /^\s+[\x27"]?#?(\d+)\b/) ? $1 : "0000";
  my $limit = 72 - length(" (#$n)");
  if (length($title) > $limit) {
    printf STDERR "Blocked: this PR title is %d characters and the limit is %d: the squash subject adds \" (#<n>)\" and scripts/ship-branch.sh refuses one over 72. Shorten the title and run the command again.\n", length($title), $limit;
    exit 2;
  }
'

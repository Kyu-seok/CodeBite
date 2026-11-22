#!/usr/bin/env bash
# Checks frontend/publish.sh, which the frontend image runs to put a build where nginx serves it
# (docs/adr/0014): a second build lands beside the first, whose hashed assets stay for the keep
# period after they stop being current and are removed after it; an asset that was current for
# months is kept from the day it is replaced, not the day it was built; a file outside assets/
# that the new build lacks goes at once; a build already published changes nothing; a build
# without index.html publishes nothing; a file with a space in its name counts toward the build id;
# a build id that can't be computed publishes nothing.
set -euo pipefail

publish="$(cd "$(dirname "$0")/.." && pwd)/frontend/publish.sh"
dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
fail=0
check() { local desc=$1; shift; "$@" || { echo "FAIL: $desc"; fail=1; }; }
build() {  # build <name> <asset>...: a dist whose index.html names its assets
  local name=$1 a; shift
  mkdir -p "$dir/$name/assets"
  for a in "$@"; do echo "$a" > "$dir/$name/assets/$a"; done
  echo "index of $name: $*" > "$dir/$name/index.html"
  echo "robots" > "$dir/$name/robots.txt"
}
days_ago() { touch -t "$(date -v-"$1"d +%Y%m%d%H%M 2>/dev/null || date -d "$1 days ago" +%Y%m%d%H%M)" "$2"; }
site=$dir/site html=$dir/site/html

build one app-1.js vendor.js
echo "old only" > "$dir/one/old.txt"
out=$(sh "$publish" "$dir/one" "$site")
check "first build: says published" grep -q "^Frontend published" <<<"$out"
check "first build: index.html served" grep -q "index of one" "$html/index.html"
check "first build: assets served" test -f "$html/assets/app-1.js" -a -f "$html/assets/vendor.js"

out=$(sh "$publish" "$dir/one" "$site")
check "same build again: says unchanged" grep -q "^Frontend unchanged" <<<"$out"

# vendor.js has been current since long before the keep period; app-1.js too.
days_ago 90 "$html/assets/vendor.js"; days_ago 90 "$html/assets/app-1.js"
build two app-2.js
out=$(sh "$publish" "$dir/two" "$site")
check "second build: says published" grep -q "^Frontend published" <<<"$out"
check "second build: its index.html served" grep -q "index of two" "$html/index.html"
check "second build: its asset served" test -f "$html/assets/app-2.js"
check "second build: the first build's assets stay" test -f "$html/assets/app-1.js" -a -f "$html/assets/vendor.js"
check "second build: a file outside assets/ it lacks is gone" test ! -e "$html/old.txt"
check "second build: no temporary file left" test -z "$(find "$site" -name '*.new')"

# Eight days on, a third build removes what the second replaced and keeps what it replaces itself.
days_ago 8 "$html/assets/vendor.js"; days_ago 8 "$html/assets/app-1.js"; days_ago 8 "$html/assets/app-2.js"
build three app-3.js
sh "$publish" "$dir/three" "$site" >/dev/null
check "after the keep period: the first build's assets are removed" test ! -e "$html/assets/app-1.js" -a ! -e "$html/assets/vendor.js"
check "after the keep period: the build just replaced stays" test -f "$html/assets/app-2.js"

mkdir "$dir/broken"; echo x > "$dir/broken/robots.txt"
check "a build without index.html: refused" bash -c "! sh '$publish' '$dir/broken' '$site' >/dev/null 2>&1"
check "a build without index.html: the last build still served" grep -q "index of three" "$html/index.html"

# A file name with a space counts toward the build id like any other: a change inside it is a new build.
build four app-4.js; echo "v1" > "$dir/four/og image.txt"
sh "$publish" "$dir/four" "$site" >/dev/null
echo "v2" > "$dir/four/og image.txt"
out=$(sh "$publish" "$dir/four" "$site")
check "a changed file with a space in its name: says published" grep -q "^Frontend published" <<<"$out"
check "a changed file with a space in its name: served" grep -q "v2" "$html/og image.txt"

# A build id that can't be computed stops the publish before a file moves (cksum fails here).
mkdir "$dir/bin"; printf '#!/bin/sh\nexit 1\n' > "$dir/bin/cksum"; chmod +x "$dir/bin/cksum"
build five app-5.js
check "the build id can't be computed: refused" bash -c "! PATH='$dir/bin':\$PATH sh '$publish' '$dir/five' '$site' >/dev/null 2>&1"
check "the build id can't be computed: the last build still served" grep -q "index of four" "$html/index.html"
check "the build id can't be computed: no asset of the new build lands" test ! -e "$html/assets/app-5.js"

(( fail )) && exit 1
echo "PASS: publish.sh swaps a build in under nginx and keeps replaced assets for the keep period"

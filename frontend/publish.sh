#!/bin/sh
# Puts this image's build where the running nginx serves it (docs/adr/0014); the frontend image's
# command, run by scripts/deploy-prod.sh:
#
#   publish.sh [<build directory> [<site directory>]]
#
# nginx serves <site>/html. Every file lands under a temporary name and is renamed into place, the
# assets first and index.html last, so a request never gets half a file or an index.html naming an
# asset that isn't there yet. A replaced build's assets stay KEEP_DAYS days from the publish that
# replaced them, for the tabs still open on it (a lazy route asks for its chunk when it opens);
# the next publish after that removes them. Prints "Frontend published" or "Frontend unchanged",
# which the deploy reads.
set -eu

src=${1:-/dist}
site=${2:-/srv/frontend}
keep_days=${KEEP_DAYS:-7}
html=$site/html

[ -f "$src/index.html" ] || { echo "publish.sh: no index.html in $src" >&2; exit 1; }

# The build's names and contents; the same sources build to the same id. One step at a time, each
# into a file: sh has no pipefail, and a pipeline would hide a find or cksum that failed and give a
# wrong id. Names are null-delimited, so one with a space stays one name.
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
(cd "$src" && find . -type f -print0) > "$work/names"
LC_ALL=C sort --zero-terminated "$work/names" > "$work/sorted"
(cd "$src" && xargs -0 cksum) < "$work/sorted" > "$work/sums"
sum=$(cksum < "$work/sums")
id=$(echo "$sum" | tr ' ' '-')
if [ -f "$html/index.html" ] && [ "$(cat "$site/build-id" 2>/dev/null)" = "$id" ]; then
  echo "Frontend unchanged (build $id)"
  exit 0
fi

mkdir -p "$html"
# The assets current until now are replaced now: their keep period starts here, not at their build.
if [ -f "$site/current-assets" ]; then
  while IFS= read -r f; do
    [ ! -f "$html/$f" ] || touch "$html/$f"
  done < "$site/current-assets"
fi

put() {  # put <file relative to the build>
  mkdir -p "$(dirname "$html/$1")"
  cp "$src/$1" "$html/$1.new"
  mv "$html/$1.new" "$html/$1"
}
(cd "$src" && find . -type f ! -path ./index.html) | while IFS= read -r f; do
  f=${f#./}
  # A hashed name already there is the same file, and keeps its date.
  case $f in assets/*) [ ! -f "$html/$f" ] || continue ;; esac
  put "$f"
done
put index.html

(cd "$src" && find . -type f -path './assets/*' | sed 's|^\./||') > "$site/current-assets.new"
mv "$site/current-assets.new" "$site/current-assets"
echo "$id" > "$site/build-id.new"
mv "$site/build-id.new" "$site/build-id"

# What the new build lacks: outside assets/ nothing depends on it; in assets/ it has had its days.
(cd "$html" && find . -type f ! -path './assets/*') | while IFS= read -r f; do
  [ -f "$src/$f" ] || rm -f "$html/$f"
done
(cd "$html" && find . -type f -path './assets/*' -mtime +"$((keep_days - 1))") | while IFS= read -r f; do
  [ -f "$src/$f" ] || rm -f "$html/$f"
done

echo "Frontend published (build $id)"

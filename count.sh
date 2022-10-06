#!/bin/bash
#
# usage: count.sh <commit-to-stop-at>
# Checkout each commit going backwards, count lines of code and print
# results stdout
#

type git >/dev/null 2>&1 || { printf 'fatal: need git\n'; exit 1; }
[[ $(git diff --stat) != '' ]] && { printf 'fatal: repo is dirty\n'; exit 1; }
[ "$#" != 1 ] &&  { printf 'usage: count <commit-to-stop-at>\n'; exit 1; }

tmpfile=$(mktemp)
git checkout master 2>/dev/null
git log --format="format:%H" "$1"..HEAD > "${tmpfile}"

while IFS= read -r line || [ -n "$line" ]; do
	printf '%s ' "${line}"
	printf '%s ' "$(git show -s --format=%ci "$line")"
	git checkout "$line" 2>/dev/null
	cloc src/ | grep '^C ' | awk '{ print $5 }'
done < "${tmpfile}"

git checkout master 2>/dev/null
rm -rf "${tmpfile}"

#!/usr/bin/env bash
# truth-check: fail the build if public copy carries anything the vault marks do-not-cite,
# an em dash, employer or domain specifics that must stay out of public deepSWE copy,
# or a placement claim the sources disagree on. Exit 1 on any hit.
set -u
root="$(cd "$(dirname "$0")/.." && pwd)"
fail=0
report() { echo "truth-check: $1"; fail=1; }

# 1. em dashes anywhere under docs/
if grep -rn --include='*.html' --include='*.md' $'\xe2\x80\x94' "$root/docs" >/dev/null; then
  grep -rn --include='*.html' --include='*.md' $'\xe2\x80\x94' "$root/docs"; report "em dash found"
fi

# 2. do-not-cite numbers and phrases (closed list; see the vault flex-sheet register)
dnc='2 billion|2b tokens|239m tokens|178m tokens|70 engineers|290%|250%|20k confluence|100k sources|youngest by|youngest ever|0\.882|0\.826|76% top|teleaudit|founders inc'
if grep -rniE --include='*.html' --include='*.md' "$dnc" "$root/docs"; then report "do-not-cite phrase found"; fi

# 3. employer and domain specifics that never appear in public copy
ea='fifa|fclive|fc27|juice|balrog|perforce|jaas|swarm review|frostbite|changelist|\bcl [0-9]{6,}|session 1[45][0-9]{3}'
if grep -rniE --include='*.html' --include='*.md' "$ea" "$root/docs"; then report "employer or domain specific found"; fi

# 4. stealth entity names stay off the public page
if grep -rniE --include='*.html' --include='*.md' 'persepolis' "$root/docs"; then report "stealth entity name found"; fi

# 5. the deepSWE block is described at architecture level only: no game vocabulary inside the marked block
block="$(awk '/truth:deepswe-start/{f=1} f{print} /truth:deepswe-end/{f=0}' "$root/docs/index.html")"
if printf '%s' "$block" | grep -niE '\bgames?\b|\bmatch(es)?\b|\bscreens?\b|kickoff|\bplayers?\b|nav event|backbuffer|\blaunch(es)?\b'; then report "domain vocabulary inside the deepSWE block"; fi

# 6. latenC placement: sources disagree on the ordinal (LinkedIn text says 2nd overall, June resume says 1st); the prize name is the invariant
latenc="$(awk '/<h3><a href="https:\/\/github.com\/dshak1\/latenC">/{f=1} f{print} /<\/li>/{if(f){exit}}' "$root/docs/index.html")"
if printf '%s' "$latenc" | grep -niE '1st|first place|2nd|second place'; then report "latenC block states a placement ordinal; use the prize name"; fi

# 7. GPA and phone number never appear
if grep -rnE --include='*.html' --include='*.md' '778-835|2\.67' "$root/docs"; then report "GPA or phone number found"; fi

if [ "$fail" -eq 0 ]; then echo "truth-check: clean"; fi
exit "$fail"

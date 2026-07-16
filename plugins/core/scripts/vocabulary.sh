#!/bin/bash
# The prohibited vocabulary, and the one place it is defined.
#
# WHY THIS FILE EXISTS
#
# This list used to live in two places: verify-skill.sh and .github/workflows/verify.yml.
# They drifted, which is what two copies of anything do. The local verifier reported
# 26/26 skills passing while CI would have failed the build on a line the local run had
# excluded. A check that disagrees with the check is worse than no check: it teaches you
# to trust a green tick that means nothing.
#
# THE QUOTES BUG, THREE TIMES
#
# The exclusion list is prose, and prose has punctuation. `No "price target"` is a
# prohibition; `no price target` is the pattern we excluded. They are the same sentence
# and the grep saw two. So before the exclusion is applied, quotes — straight, curly, and
# backtick — are stripped from the line. Match on the normalised text; show the original.
#
# WHAT COUNTS AS A VIOLATION
#
# PROHIBITED matches the vocabulary of a recommendation. ALLOWED matches an explicit
# refusal of it. A line that carries the vocabulary without the refusal is a verdict, and
# a verdict fails the build. This is the failure this repo exists to prevent: we shipped a
# plugin that told Claude to emit "Rating: BUY | Price Target: $XXX", and it sat there for
# months underneath a disclaimer that said we never do that.

# The vocabulary of a verdict. Renaming BUY to BULLISH does not get you out of this —
# MAR Art. 20 and EU Delegated Reg. 2016/958 reach the *implicit* recommendation.
PROHIBITED='price target|target price|rating box|Rating: *(BUY|SELL|HOLD|MAINTAIN|OUTPERFORM|UNDERPERFORM|OVERWEIGHT|UNDERWEIGHT|BULLISH|BEARISH)|BUY/HOLD/SELL|implied upside|upside/\(?downside|fair value|investment recommendation|suitability|fiduciary|risk tolerance'

# An explicit refusal. Only negations belong here. If you find yourself adding a phrase
# that is not a refusal, you are not fixing a false positive — you are drilling a hole.
ALLOWED='no rating|no price target|no target price|never|not a rating|does not|do not|no fair value|no verdict|dont make buy|no buy or sell|facts, not price|there is no|whatever it is called|no implied upside|not a fair value|no single figure|instead of|rather than|we dont|cannot'

# Sweep a set of directories. Prints offending lines; returns 1 if any survived.
#   vocab_sweep skills/ commands/ agents/
#
# The quote-stripping is perl, not sed, and that is not a preference. `sed 's/[\x22]//g'`
# does NOT read \x22 as an escape inside a bracket expression — BSD sed takes it literally,
# so the class ends up containing x, 2, 8, 0, 9, c, d, e… and the filter quietly deletes
# those letters from every line it inspects. The text is mangled, the prohibitions stop
# matching the ALLOWED list, and the sweep reports the entire catalogue as verdicts. It
# failed loudly here. A different character set and it would have failed silently, which
# is the direction that ships.
vocab_sweep() {
  local hits
  hits=$(grep -rniE "$PROHIBITED" "$@" 2>/dev/null \
    | perl -CSD -pe 's/[\x{0022}\x{0027}\x{0060}\x{201C}\x{201D}\x{2018}\x{2019}]//g' \
    | grep -viE "$ALLOWED" \
    || true)
  if [ -n "$hits" ]; then
    printf '%s\n' "$hits"
    return 1
  fi
  return 0
}

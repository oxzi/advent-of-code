# Let's automate writing an awk program to solve itself.
#
# Usage: awk "$(awk -f 19_1.awk input)"

BEGIN {
  print "function _A(x, m, a, s) { sum += x + m + a + s }"
  print "function _R(x, m, a, s) { }"
  print ""
}

match($0, /^[a-z]+/) {
  print "# " $0
  print "function _" substr($0, 1, RLENGTH) "(x, m, a, s) {"
  split(substr($0, RLENGTH+2, length($0)-RLENGTH-2), conds, ",")
  for (i in conds) {
    printf "  %s", (i == 1) ? "" : "else "
    if (match(conds[i], /.+:/))
      print "if (" substr(conds[i], 1, RLENGTH-1) ") _" substr(conds[i], RLENGTH+1) "(x, m, a, s)"
    else
      print "_" conds[i] "(x, m, a, s)"
  }
  print "}"
  print ""
}

/^$/ { print "BEGIN {" }

/^\{/ {
  gsub(/[^0-9,]/, "")
  print "  _in(" $0 ")"
}

END {
  print ""
  print "  print sum"
  print "  exit"
  print "}"
}

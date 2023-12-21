# Let's automate writing an awk program to solve itself.
#
# Usage: awk -f <(awk -f 19_2.awk input)

BEGIN {
  print "function min(a, b) { return (a < b) ? a : b }"
  print "function max(a, b) { return (a > b) ? a : b }"
  print ""
  print "function _A(x_min, x_max, m_min, m_max, a_min, a_max, s_min, s_max) {"
  print "  sum += (x_max-x_min+1) * (m_max-m_min+1) * (a_max-a_min+1) * (s_max-s_min+1)"
  print "}"
  print ""
  print "function _R(x_min, x_max, m_min, m_max, a_min, a_max, s_min, s_max) { }"
  print ""
}

match($0, /^[a-z]+/) {
  print "# " $0
  print "function _" substr($0, 1, RLENGTH) "(x_min, x_max, m_min, m_max, a_min, a_max, s_min, s_max) {"
  split(substr($0, RLENGTH+2, length($0)-RLENGTH-2), conds, ",")
  for (i in conds) {
    if (match(conds[i], /.+:/)) {
      cond = substr(conds[i], 1, 2)
      numb = substr(conds[i], 3, RLENGTH-3)
      fn = "_" substr(conds[i], RLENGTH+1)

      if (cond == "x<")
        print "  if (x_min < " numb ") { " fn "(x_min, min(" numb-1 ", x_max), m_min, m_max, a_min, a_max, s_min, s_max); x_min = " numb " }"
      else if (cond == "x>")
        print "  if (x_max > " numb ") { " fn "(max(" numb+1 ", x_min), x_max, m_min, m_max, a_min, a_max, s_min, s_max); x_max = " numb " }"
      else if (cond == "m<")
        print "  if (m_min < " numb ") { " fn "(x_min, x_max, m_min, min(" numb-1 ", m_max), a_min, a_max, s_min, s_max); m_min = " numb " }"
      else if (cond == "m>")
        print "  if (m_max > " numb ") { " fn "(x_min, x_max, max(" numb+1 ", m_min), m_max, a_min, a_max, s_min, s_max); m_max = " numb " }"
      else if (cond == "a<")
        print "  if (a_min < " numb ") { " fn "(x_min, x_max, m_min, m_max, a_min, min(" numb-1 ", a_max), s_min, s_max); a_min = " numb " }"
      else if (cond == "a>")
        print "  if (a_max > " numb ") { " fn "(x_min, x_max, m_min, m_max, max(" numb+1 ", a_min), a_max, s_min, s_max); a_max = " numb " }"
      else if (cond == "s<")
        print "  if (s_min < " numb ") { " fn "(x_min, x_max, m_min, m_max, a_min, a_max, s_min, min(" numb-1 ", s_max)); s_min = " numb " }"
      else if (cond == "s>")
        print "  if (s_max > " numb ") { " fn "(x_min, x_max, m_min, m_max, a_min, a_max, max(" numb+1 ", s_min), s_max); s_max = " numb " }"
    } else {
      print "_" conds[i] "(x_min, x_max, m_min, m_max, a_min, a_max, s_min, s_max)"
    }
  }
  print "}"
  print ""
}

END {
  print "BEGIN {"
  print "  _in(1, 4000, 1, 4000, 1, 4000, 1, 4000)"
  print "  print sum"
  print "  exit"
  print "}"
}

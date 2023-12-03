BEGIN {
  # Generate literal_numbs, an array mapping both number words and numbers to
  # their number, and numb_match, a regular expression group to capture numbers.

  split("one two three four five six seven eight nine", literal_numbs_raw)
  numb_match = "([0-9]|"
  for (i in literal_numbs_raw) {
    literal_numbs[i] = literal_numbs[literal_numbs_raw[i]] = i
    numb_match = numb_match literal_numbs_raw[i] ((i != 9) ? "|" : ")")
  }
}

{
  match($0, numb_match ".*", re_numb_first)
  match($0, ".*" numb_match, re_numb_last)
  sum += literal_numbs[re_numb_first[1]] literal_numbs[re_numb_last[1]]
}

END { print sum }

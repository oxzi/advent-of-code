{
  hits = win_endpos = 0
  for (i = 3; i <= NF; i++) {
    if ($i == "|") { win_endpos = i-1; continue }
    if (!win_endpos) { continue }

    for (j = 3; j <= win_endpos; j++)
      if ($i == $j)
        hits++
  }

  sum += (hits > 0) ? 2^(hits-1) : 0
}

END { print sum }

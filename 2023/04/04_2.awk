{
  hits = win_endpos = 0
  for (i = 3; i <= NF; i++) {
    if ($i == "|") { win_endpos = i-1; continue }
    if (!win_endpos) { continue }

    for (j = 3; j <= win_endpos; j++)
      if ($i == $j)
        hits++
  }

  sum += copies[NR] = copies[NR]+1
  for (i = NR+1; i <= NR+hits; i++)
    copies[i] = copies[i] + copies[NR]
  delete copies[NR]
}

END { print sum }

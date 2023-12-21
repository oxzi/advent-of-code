BEGIN {
  dir["3", "Y"] = -1
  dir["1", "Y"] = 1
  dir["2", "X"] = -1
  dir["0", "X"] = 1

  pos_x = pos_y = 0
}

{
  l = strtonum("0x" substr($3, 3, 5))
  d = substr($3, 8, 1)
  xs[NR] = pos_x += dir[d, "X"] * l
  ys[NR] = pos_y += dir[d, "Y"] * l
  sum += l
}

END {
  for (i = 1; i <= NR; i++) {
    j = (i%NR)+1
    sum += (ys[i]+ys[j]) * (xs[i]-xs[j])
  }
  print 0.5*sum+1
}

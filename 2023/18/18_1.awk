BEGIN {
  dir["U", "Y"] = -1
  dir["D", "Y"] = 1
  dir["L", "X"] = -1
  dir["R", "X"] = 1

  pos_x = pos_y = 0
}

{
  xs[NR] = pos_x += dir[$1, "X"] * $2
  ys[NR] = pos_y += dir[$1, "Y"] * $2
  sum += $2
}

END {
  for (i = 1; i <= NR; i++) {
    j = (i%NR)+1
    sum += (ys[i]+ys[j]) * (xs[i]-xs[j])
  }
  print 0.5*sum+1
}

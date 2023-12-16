BEGIN { FS = "" }

{
  for (x = 1; x <= NF; x++) {
    rounds[x, NR] = int($x == "O")
    cubes[x, NR] = int($x == "#")
  }
}

END {
  for (i = 2; i <= NR; i++) {
    for (j = i; j >= 2; j--) {
      for (k = 1; k <= NF; k++) {
        if (!rounds[k, j])
          continue

        blocked = or(rounds[k, j-1], cubes[k, j-1])
        moving = and(compl(blocked), rounds[k, j])
        rounds[k, j-1] = or(rounds[k, j-1], moving)
        rounds[k, j] = and(rounds[k, j], compl(moving))
      }
    }
  }

  for (i = 1; i <= NR; i++)
    for (j = 1; j <= NF; j++)
      if (rounds[j, i])
        sum += NR-i+1
  print sum
}

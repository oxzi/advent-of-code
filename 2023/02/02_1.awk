BEGIN {
  FS = ";"

  maxs["red"] = 12
  maxs["green"] = 13
  maxs["blue"] = 14
}

{
  for (i = 1; i <= NF; i++) {
    for (max in maxs) {
      if (match($i, "([0-9]+) " max, tmp) && (tmp[1] > maxs[max])) {
        next
      }
    }
  }

  match($1, /Game ([0-9]+):/, game_no)
  sum += game_no[1]
}

END { print sum }

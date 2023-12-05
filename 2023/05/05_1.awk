BEGIN { RS = ""}

/^seeds:/ {
  for (i = 2; i <= NF; i++)
    seeds[seedctr++] = $i
}

/^[a-z]+-to-[a-z]+ map:/ {
  for (s in seeds) {
    for (i = 3; i <= NF; i += 3) {
      if ($(i+1) <= seeds[s] && seeds[s] <= ($(i+1) + $(i+2))) {
        seeds[s] = $i + (seeds[s] - $(i+1))
        break
      }
    }
  }
}

END {
  for (s in seeds)
    min = (min == 0) ? seeds[s] : ((seeds[s] < min) ? seeds[s] : min)
  print min
}

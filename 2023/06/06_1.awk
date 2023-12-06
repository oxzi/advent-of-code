/^Time/ {
  for (i = 2; i <= NF; i++)
    times[i] = $i
}

/^Distance/ {
  wins = 1
  for (i = 2; i <= NF; i++) {
    for (ms = 0; ms <= times[i]; ms++) {
      if (((times[i] - ms) * ms) > $i) {
        wins *= (times[i]+1) - (ms * 2)
        break
      }
    }
  }

  print wins
}

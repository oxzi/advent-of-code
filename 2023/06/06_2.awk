/^Time/ {
  for (i = 2; i <= NF; i++)
    time = int(time $i)
}

/^Distance/ {
  for (i = 2; i <= NF; i++)
    dist = int(dist $i)

  for (ms = 0; ms <= time; ms++) {
    if (((time - ms) * ms) > dist) {
      print (time+1) - (ms * 2)
      exit
    }
  }
}

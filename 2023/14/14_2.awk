function tilt(r, c,    i, j, k, moving) {
  for (i = 2; i <= NR; i++) {
    for (j = i; j >= 2; j--) {
      for (k = 1; k <= NF; k++) {
        if (!r[k, j])
          continue

        moving = and(compl(or(r[k, j-1], c[k, j-1])), r[k, j])
        r[k, j-1] = or(r[k, j-1], moving)
        r[k, j] = and(r[k, j], compl(moving))
      }
    }
  }
}

function rotate(r, c,    i, j, tmp) {
  # Square matrix as input: transpose and reverse each row to rotate by 90 deg
  for (i = 1; i <= NR; i++) {
    for (j = i+1; j <= NR; j++) {
      tmp = r[i, j]
      r[i, j] = r[j, i]
      r[j, i] = tmp

      tmp = c[i, j]
      c[i, j] = c[j, i]
      c[j, i] = tmp
    }
  }
  for (i = 1; i <= NR; i++) {
    for (j = 1; j <= NR/2; j++) {
      tmp = r[j, i]
      r[j, i] = r[NR-j+1, i]
      r[NR-j+1, i] = tmp

      tmp = c[j, i]
      c[j, i] = c[NR-j+1, i]
      c[NR-j+1, i] = tmp
    }
  }
}

function hash(r, c,    i, j, a, b) {
  # Adler-32 to distinct inputs
  a = 1; b = 0
  for (y = 1; y <= NR; y++) {
    for (x = 1; x <= NF; x++) {
      a = (a + ((r[x, y] || c[x, y]) ? x+y : 0)) % 65521
      b = (b + a) % 65521
    }
  }
  return or(lshift(b, 16), a)
}

BEGIN { FS = "" }

{
  for (x = 1; x <= NF; x++) {
    rounds[x, NR] = int($x == "O")
    cubes[x, NR] = int($x == "#")
  }
}

END {
  for (i = 1; i <= 1000000000; i++) {
    for (j = 0; j < 4; j++) {
      tilt(rounds, cubes)
      rotate(rounds, cubes)
    }

    if ((h = hash(rounds, cubes)) in hashes)
      break
    hashes[h] = i
  }

  cycles = (1000000000-hashes[h]-1) % (i-hashes[h])
  for (i = 0; i <= cycles; i++) {
    for (j = 0; j < 4; j++) {
      tilt(rounds, cubes)
      rotate(rounds, cubes)
    }
  }

  for (i = 1; i <= NR; i++)
    for (j = 1; j <= NF; j++)
      if (rounds[j, i])
        sum += NR-i+1
  print sum
}

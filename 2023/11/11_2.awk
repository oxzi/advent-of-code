BEGIN { FS = "" }

/#/ {
  img_y++
  for (i = 1; i <= (img_x = NF); i++)
    img[i, img_y] = $i
}

/^\.+$/ {
  img_y++
  for (i = 1; i <= (img_x = NF); i++)
    img[i, img_y] = "X"
}

function expand_width(    x, y, empty) {
  for (x = 1; x <= img_x; x++) {
    for (empty = y = 1; y <= img_y; y++)
      empty = (img[x, y] == "#") ? 0 : empty

    for (y = 1; empty && y <= img_y; y++)
      img[x, y] = "X"
  }
}

function abs(a)    { return (a > 0) ? a : (-1)*a }
function max(a, b) { return (a > b) ? a : b }
function min(a, b) { return (a > b) ? b : a }

function pair_dist(    galaxy, galaxyctr, i, j, k, is, js, tmp, sum) {
  for (y = 1; y <= img_y; y++)
    for (x = 1; x <= img_x; x++)
      if (img[x, y] == "#")
        galaxy[++galaxyctr] = x SUBSEP y

  for (i = 1; i <= galaxyctr; i++) {
    for (j = i+1; j <= galaxyctr; j++) {
      split(galaxy[i], is, SUBSEP)
      split(galaxy[j], js, SUBSEP)
      tmp = abs(is[1]-js[1]) + abs(is[2]-js[2])

      for (k = min(is[1], js[1]); k < max(is[1], js[1]); k++)
        if (img[k, is[2]] == "X")
          tmp += 1000000-1
      for (k = min(is[2], js[2]); k < max(is[2], js[2]); k++)
        if (img[is[1], k] == "X")
          tmp += 1000000-1

      sum += tmp
    }
  }
  return sum
}

END {
  expand_width()
  print pair_dist()
}

BEGIN { FS = "" }

{
  for (i = 1; i <= (match($0, /^\.+$/) ? 2 : 1); i++) {
    img_y++
    for (j = 1; j <= (img_x = NF); j++)
      img[j, img_y] = $j
  }
}

function expand_width(    x, x_, y, empty) {
  for (x = 1; x <= img_x; x++) {
    for (empty = y = 1; y <= img_y; y++)
      empty = (img[x, y] != ".") ? 0 : empty

    if (!empty)
      continue

    for (x_ = ++img_x; x_ > x; x_--)
      for (y = 1; y <= img_y; y++)
        img[x_, y] = img[x_-1, y]
    x++
  }
}

function abs(a) { return (a > 0) ? a : (-1)*a }

function pair_dist(    galaxy, galaxyctr, i, j, is, js, sum) {
  for (y = 1; y <= img_y; y++)
    for (x = 1; x <= img_x; x++)
      if (img[x, y] == "#")
        galaxy[++galaxyctr] = x SUBSEP y

  for (i = 1; i <= galaxyctr; i++) {
    for (j = i+1; j <= galaxyctr; j++) {
      split(galaxy[i], is, SUBSEP)
      split(galaxy[j], js, SUBSEP)
      sum += abs(is[1]-js[1]) + abs(is[2]-js[2])
    }
  }
  return sum
}

END {
  expand_width()
  print pair_dist()
}

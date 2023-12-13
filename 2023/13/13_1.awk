function find_dups_search(is,    i, tmp, l, r) {
  for (i = 1; i < length(is); i++) {
    tmp = 0; l = i; r = i+1
    while (1 <= l && r <= length(is)) {
      tmp += xor(is[l], is[r])
      l--; r++
    }

    if (tmp == 0)
      return i
  }
  return 0
}

function find_dups(xs, ys,    x, y) {
  x = find_dups_search(xs)
  y = find_dups_search(ys)
  return (x > y) ? x : 100*y
}

BEGIN { FS = "" }

/./ {
  y++;
  for (x = 1; x <= NF; x++) {
    xs[x] += ($x == "#") ? lshift(1, y) : 0
    ys[y] += ($x == "#") ? lshift(1, x) : 0
  }
}

/^$/ {
  total += find_dups(xs, ys)
  y = 0; delete xs; delete ys
}

END { print total += find_dups(xs, ys) }

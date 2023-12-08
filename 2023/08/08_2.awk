# lcm, least common multiple, implemented over the greatest common divider.
function lcm(a, b,    gcd_a, gcd_b) {
  gcd_a = a; gcd_b = b
  while (gcd_a != gcd_b) {
    if (gcd_a > gcd_b)
      gcd_a -= gcd_b
    else
      gcd_b -= gcd_a
  }

  return (a * b)/gcd_a
}

NR == 1 { inst = $1 }

match($0, /^([1-9A-Z]{3}) = \(([1-9A-Z]{3}), ([1-9A-Z]{3})\)$/, n) {
  edge["L", n[1]] = n[2]
  edge["R", n[1]] = n[3]

  if (match(n[1], /..A/))
    nodes[++nodesctr] = n[1]
}

END {
  for (no in nodes) {
    for (i = 0; ; i++) {
      # Turns out each path cycles on the exact same /..Z/ node
      if (match((nodes[no] = edge[substr(inst, i % length(inst) + 1, 1), nodes[no]]), /..Z/)) {
        # lcm is associative, lcm(m, lcm(n, p)) = lcm(lcm(m, n), p) = lcm(m, n, p)
        dist = (dist == 0) ? i+1 : lcm(dist, i+1)
        break
      }
    }
  }
  print dist
}

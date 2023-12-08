NR == 1 { inst = $1 }

match($0, /^([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)$/, n) {
  edge["L", n[1]] = n[2]
  edge["R", n[1]] = n[3]
}

END {
  node = "AAA"
  for (i = 0; ; i++)
    if ((node = edge[substr(inst, i % length(inst) + 1, 1), node]) == "ZZZ")
      break
  print i+1
}

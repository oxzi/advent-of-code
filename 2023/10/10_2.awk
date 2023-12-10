BEGIN {
  FS = ""

  # Map connected edges as a bitmask of 0b_0000_NESW
  dir["out", "|"] =       dir["in", "|"] = 0x0A
  dir["out", "-"] =       dir["in", "-"] = 0x05
  dir["out", "L"] = 0x0C; dir["in", "L"] = 0x03
  dir["out", "J"] = 0x09; dir["in", "J"] = 0x06
  dir["out", "7"] = 0x03; dir["in", "7"] = 0x0C
  dir["out", "F"] = 0x06; dir["in", "F"] = 0x09
  dir["out", "."] =       dir["in", "."] = 0x00
  dir["out", "S"] =       dir["in", "S"] = 0x0F
}

{
  for (i = 1; i <= NF; i++)
    if ((map[i, NR] = $i) == "S")
      start = i SUBSEP NR
}

function neighbors(x, y,    offsets, i, x_, y_, rets) {
  # Tuple of (x offset, y offset, dec. out bitmask)
  split("0 -1 8 1 0 4 0 1 2 -1 0 1", offsets, " ")
  for (i = 1; i < length(offsets); i += 3) {
    x_ = x+offsets[i]
    y_ = y+offsets[i+1]
    if (x_ < 1 || NF < x_ || y_ < 1 || NR < y_)
      continue

    if (and(and(offsets[i+2], dir["out", map[x, y]]), dir["in", map[x_, y_]]))
      rets = rets OFS x_ SUBSEP y_
  }

  return substr(rets, length(OFS)+1)
}

function maze(    i, x, y, queue, queue_ctr, dist, v, vs, v_edges_s, v_edges, borders, enclosed, sum) {
  dist[start] = 0
  queue[++queue_ctr] = start

  while (queue_ctr > 0) {
    v = queue[1]
    for (i = 2; i <= queue_ctr; i++)
      queue[i-1] = queue[i]
    queue_ctr--

    split(v, vs, SUBSEP)
    v_edges_s = neighbors(vs[1], vs[2])
    split(v_edges_s, v_edges, OFS)
    for (i in v_edges) {
      if (v_edges[i] in dist)
        continue
      dist[v_edges[i]] = dist[v]+1
      queue[++queue_ctr] = v_edges[i]
    }
  }

  # Hacky ray casting algorithm based on Jordan curve theorem
  # https://en.wikipedia.org/wiki/Point_in_polygon#Ray_casting_algorithm
  for (y = 1; y <= NR; y++) {
    borders = 0
    for (x = 1; x <= NF; x++) {
      if (!(x, y) in dist) {
        sum += enclosed[x, y] = borders % 2 == 1
        continue
      }

      if (map[x, y] == "|" || map[x, y] == "L" || map[x, y] == "J")
        borders++
    }
  }

  # for (y = 1; y <= NR; y++) {
  #   for (x = 1; x <= NF; x++) {
  #     printf "%s", (((x, y) in dist) ? "x" : (((x, y) in enclosed) ? enclosed[x, y] : "?"))
  #   }
  #   print ""
  # }

  return sum
}

END { print maze() }

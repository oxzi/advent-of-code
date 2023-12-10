BEGIN { FS = "" }

{
  for (i = 1; i <= NF; i++)
    if ((map[i, NR] = $i) == "S")
      start = i SUBSEP NR
}

function neighbors(x, y,    dir, offsets, i, x_, y_, rets) {
  # Map connected edges as a bitmask of 0b_0000_NESW
  dir["out", "|"] =       dir["in", "|"] = 0x0A
  dir["out", "-"] =       dir["in", "-"] = 0x05
  dir["out", "L"] = 0x0C; dir["in", "L"] = 0x03
  dir["out", "J"] = 0x09; dir["in", "J"] = 0x06
  dir["out", "7"] = 0x03; dir["in", "7"] = 0x0C
  dir["out", "F"] = 0x06; dir["in", "F"] = 0x09
  dir["out", "."] =       dir["in", "."] = 0x00
  dir["out", "S"] =       dir["in", "S"] = 0x0F

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

function maze(    i, x, y, queue, queue_ctr, dist, v, vs, v_edges_s, v_edges, max) {
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

  # Fortunately, the puzzle does not contain dead paths, but is cyclic.
  for (y = 1; y <= NR; y++) {
    for (x = 1; x <= NF; x++) {
      # printf "%s", (((x, y) in dist) ? dist[x, y] : ".")
      # printf "%s", (((x, y) in dist) ? "x" : ".")
      max = (dist[x, y] > max) ? dist[x, y] : max
    }
    # print ""
  }
  return max
}

END { print maze() }

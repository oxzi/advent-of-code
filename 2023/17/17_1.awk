function dijkstra(    dist, queue, dirs, node, tmp, npos, d, dir, neigh, len, loss, dpos, min) {
  #    (1, 2, 3   , 4   , 5  )
  #    (x, y, xdir, ydir, len)
  dist [1, 1, 0,    0,    0] = 0
  queue[1, 1, 0,    0,    0] = 0

  dirs[0, -1] = dirs[1, 0] = dirs[0, 1] = dirs[-1, 0] = 1

  while (length(queue) > 0) {
    node = ""
    for (tmp in queue)
      node = ((tmp in dist) && (node == "" || dist[tmp] < dist[node])) ? tmp : node
    delete queue[node]

    split(node, npos, SUBSEP)

    for (d in dirs) {
      split(d, dir, SUBSEP)
      if (npos[3] == (-1)*dir[1] && npos[4] == (-1)*dir[2])
        continue

      neigh[1] = npos[1] + dir[1]
      neigh[2] = npos[2] + dir[2]

      if (neigh[1] < 1 || neigh[1] > NF || neigh[2] < 1 || neigh[2] > NR)
        continue

      len = (npos[3] == dir[1] && npos[4] == dir[2]) ? npos[5]+1 : 1
      if (len == 4)
        continue

      loss = dist[node] + map[neigh[1], neigh[2]]
      if (((neigh[1], neigh[2], dir[1], dir[2], len) in dist) && loss >= dist[neigh[1], neigh[2], dir[1], dir[2], len])
        continue

      dist [neigh[1], neigh[2], dir[1], dir[2], len] = loss
      queue[neigh[1], neigh[2], dir[1], dir[2], len] = 0
    }
  }

  for (d in dist) {
    split(d, dpos, SUBSEP)
    if (dpos[1] == NF && dpos[2] == NR)
      min = (min == 0 || min > dist[d]) ? dist[d] : min
  }
  print min
}

BEGIN { FS = "" }

{
  for (x = 1; x <= NF; x++)
    map[x, NR] = $x
}

END { dijkstra() }

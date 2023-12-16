function beam(start,
                  stack, stackctr,
                  following, following_parts,
                  visited, count,
                  parts, cur, i) {
  # (x, y, x-offset, y-offset)
  stack[++stackctr] = start

  # (type, x-in-dir, y-in-dir) -> (x-out-dir-1, y-out-dir-1, ...)
  following[ "/",  0,  1] = "-1 0"
  following[ "/", -1,  0] = "0 1"
  following[ "/",  0, -1] = "1 0"
  following[ "/",  1,  0] = "0 -1"
  following["\\",  0,  1] = "1 0"
  following["\\", -1,  0] = "0 -1"
  following["\\",  0, -1] = "-1 0"
  following["\\",  1,  0] = "0 1"
  following[ "|",  0,  1] = "0 1"
  following[ "|", -1,  0] = "0 -1 0 1"
  following[ "|",  0, -1] = "0 -1"
  following[ "|",  1,  0] = "0 -1 0 1"
  following[ "-",  0,  1] = "-1 0 1 0"
  following[ "-", -1,  0] = "-1 0"
  following[ "-",  0, -1] = "-1 0 1 0"
  following[ "-",  1,  0] = "1 0"

  while (stackctr > 0) {
    split(stack[1], parts, " ")
    for (i = 2; i <= stackctr; i++)
      stack[i-1] = stack[i]
    delete stack[stackctr--]

    if (parts[1] < 1 || parts[1] > NF || parts[2] < 1 || parts[2] > NR)
      continue

    if ((parts[1], parts[2], parts[3], parts[4]) in visited)
      continue
    count[parts[1], parts[2]] = visited[parts[1], parts[2], parts[3], parts[4]] = 1

    if ((cur = map[parts[1], parts[2]]) == ".") {
      stack[++stackctr] = (parts[1] + parts[3]) " " \
                          (parts[2] + parts[4]) " " \
                          parts[3] " " \
                          parts[4]
    } else {
      split(following[cur, parts[3], parts[4]], following_parts, " ")
      for (i = 1; i <= length(following_parts); i += 2)
        stack[++stackctr] = (parts[1] + following_parts[i]) " " \
                            (parts[2] + following_parts[i+1]) " " \
                            following_parts[i] " " \
                            following_parts[i+1]
    }
  }

  return length(count)
}

BEGIN { FS = "" }

{
  for (x = 1; x <= NF; x++)
    map[x, NR] = $x
}

END {
  for (x = 1; x <= NF; x++) {
    max = ((tmp = beam(x " 1 0 1")) > max) ? tmp : max
    max = ((tmp = beam(x " " NR " 0 -1")) > max) ? tmp : max
  }
  for (y = 1; y <= NR; y++) {
    max = ((tmp = beam("1 " y " 1 0")) > max) ? tmp : max
    max = ((tmp = beam(NF " " y " -1 0")) > max) ? tmp : max
  }
  print max
}

function numb_value() {
  for (x = numb[2]-1; x <= numb[3]+1; x++) {
    for (y = numb[1]-1; y <= numb[1]+1; y++) {
      if (symbs[y, x]) {
        return numb[4]
      }
    }
  }
  return 0
}

{
  for (offset = 0; length($0) > 0;) {
    if (start = match($0, /^[0-9]+/)) {
      # 1: y, 2: x_start, 3: x_end, 4: numb
      numbs[numbslen++] = NR FS \
           start+offset FS \
           start+offset+RLENGTH-1 FS \
           substr($0, start, RLENGTH)
    } else if (start = match($0, /^[^0-9.]/)) {
      symbs[NR, start+offset] = 1
    }

    off = (RLENGTH > 0) ? RLENGTH : 1
    $0 = substr($0, off+1)
    offset += off
  }
}

END {
  for (i in numbs) {
    split(numbs[i], numb)
    sum += numb_value()
  }
  print sum
}

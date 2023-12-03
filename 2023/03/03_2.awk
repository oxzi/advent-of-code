function numb_hit(pos_x, pos_y) {
  for (x = numb[2]-1; x <= numb[3]+1; x++) {
    for (y = numb[1]-1; y <= numb[1]+1; y++) {
      if (x == pos_x && y == pos_y) {
        return 1
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
    } else if (start = match($0, /^*/)) {
      # 1: y, 2: x
      gears[gearlen++] = NR FS start+offset
    }

    off = (RLENGTH > 0) ? RLENGTH : 1
    $0 = substr($0, off+1)
    offset += off
  }
}

END {
  for (i in gears) {
    split(gears[i], gear)
    gear_numbs = ""

    for (j in numbs) {
      split(numbs[j], numb)
      if (numb_hit(gear[2], gear[1])) {
        gear_numbs = numb[4] FS gear_numbs
      }
    }

    sub(FS "^", "", gear_numbs)
    split(gear_numbs, gear_numb)
    if (length(gear_numb) != 2) {
      continue
    }
    sum += gear_numb[1] * gear_numb[2]
  }

  print sum
}

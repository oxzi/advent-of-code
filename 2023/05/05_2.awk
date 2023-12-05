BEGIN { RS = ""}

/^seeds:/ {
  for (i = 2; i <= NF; i += 2)
    seeds[$i, $i+$(i+1)] = 1
}

/^[a-z]+-to-[a-z]+ map:/ {
  for (i = 3; i <= NF; i += 3) {
    range_start = $(i+1)
    range_end = range_start + $(i+2)
    delta = $i - range_start

    for (seed_pair in seeds) {
      split(seed_pair, seed_fields, SUBSEP)
      seed_start = seed_fields[1]
      seed_end = seed_fields[2]

      delete seeds[seed_start, seed_end]

      is_seed_within = range_start <= seed_start && seed_end <= range_end
      is_seed_over_right = range_start < seed_start && seed_start < range_end && range_end < seed_end
      is_seed_over_left = seed_start < range_start && range_start < seed_end && seed_end < range_end
      is_seed_over_both = seed_start < range_start && range_end < seed_end

      if (is_seed_within)
        seeds_new[seed_start + delta, seed_end + delta] = 1
      else if (is_seed_over_right)
        seeds_new[seed_start + delta, range_end + delta] = seeds[range_end, seed_end] = 1
      else if (is_seed_over_left)
        seeds_new[range_start + delta, seed_end + delta] = seeds[seed_start, range_start] = 1
      else if (is_seed_over_both)
        seeds_new[range_start + delta, range_end + delta] = seeds[seed_start, range_start] = seeds[range_end, seed_end] = 1
      else
        seeds[seed_start, seed_end] = 1
    }
  }

  for (s in seeds_new)
    seeds[s] = 1
  delete seeds_new
}

END {
  for (seed_pair in seeds) {
    split(seed_pair, seed_fields, SUBSEP)
    min = (min == 0) ? seed_fields[1] : ((seed_fields[1] < min) ? seed_fields[1] : min)
  }
  print min
}

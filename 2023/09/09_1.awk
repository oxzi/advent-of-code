{
  last_sum = 0
  for (limit = NF; limit >= 2; limit--) {
    last_sum += $limit

    for (zero = i = 1; i <= limit-1; i++) {
      $i = $(i+1) - $i
      zero = ($i != 0) ? 0 : zero
    }

    if (zero) {
      sum += last_sum
      next
    }
  }
}

END { print sum }

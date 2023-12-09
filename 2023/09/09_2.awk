{
  for (i = 1; i <= NF/2; i++) {
    tmp = $i
    $i = $(NF-i+1)
    $(NF-i+1) = tmp
  }

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

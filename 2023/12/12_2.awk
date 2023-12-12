function arr_dup(from, to_a, to_b) {
  for (i in from)
    to_a[i] = to_b[i] = from[i]
}

function arr_pop(a,    pop, i) {
  pop = a[1]
  for (i = 1; i < length(a); i++)
    a[i] = a[i+1]
  delete a[i]
  return pop
}

function arr_key(a,    i, tmp) {
  for (i in a)
    tmp = tmp "," i "-" a[i]
  return substr(tmp, 2)
}

function strrep(s, n, sep,    i, tmp) {
  for (i = 1; i <= n; i++)
    tmp = tmp sep s
  return substr(tmp, length(sep)+1)
}

# me: can we stop and get decorators? - awk: we have decorators at home
# decorators at home:
function find_cache(springs, groups,    groups_key) {
  if ((springs, (groups_key = arr_key(groups))) in cache)
    return cache[springs, groups_key]
  return (cache[springs, groups_key] = find(springs, groups))
}

function find(springs, groups,    cur, g_1, groups_a, groups_b) {
  if (springs == "")
    return (length(groups) == 0) ? 1 : 0

  if ((cur = substr(springs, 1, 1)) == ".") {
    gsub(/^\.+/, "", springs)
    return find_cache(springs, groups)
  } else if (cur == "#") {
    if (length(groups) == 0 || length(springs) < groups[1])
      return 0
    if (index(substr(springs, 1, groups[1]), ".") > 0)
      return 0
    if (substr(springs, groups[1]+1, 1) == "#")
      return 0

    g_1 = arr_pop(groups)
    springs = substr(springs, g_1+((length(springs) > g_1 && substr(springs, g_1+1, 1) == "?") ? 2 : 1))
    gsub(/^\.+/, "", springs)
    return find_cache(springs, groups)
  } else {
    arr_dup(groups, groups_a, groups_b)
    return find_cache("." substr(springs, 2), groups_a) + find_cache("#" substr(springs, 2), groups_b)
  }
}

function find_count(springs, groups,    groups_arr) {
  delete cache
  split(groups, groups_arr, ",")
  return find_cache(springs, groups_arr)
}

{ sum += find_count(strrep($1, 5, "?"), strrep($2, 5, ",")) }

END { print sum }

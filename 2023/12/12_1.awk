function arr_dup(from, to_a, to_b) {
  for (i in from)
    to_a[i] = to_b[i] = from[i]
}

function strrep(s, n,    tmp, i) {
  for (i = 1; i <= n; i++)
    tmp = tmp s
  return tmp
}

function find(springs, groups, group, trace, finds,    cur, groups_a, groups_b) {
  if (group == length(groups)+1) {
    if (index(springs, "#") == 0)
      finds[trace strrep(".", length(springs))] = 1
    return
  } else if (springs == "") {
    if (group == length(groups) && groups[group] == 0)
      finds[trace] = 1
    return
  }

  if ((cur = substr(springs, 1, 1)) == ".") {
    if (groups[group] == 0)
      find(substr(springs, 2), groups, group+1, trace cur, finds)
    else if (!match(trace, /#$/))
      find(substr(springs, 2), groups, group, trace cur, finds)
  } else if (cur == "#") {
    if (groups[group] == 0)
      return
    groups[group]--
    find(substr(springs, 2), groups, group, trace cur, finds)
  } else {
    arr_dup(groups, groups_a, groups_b)
    find("." substr(springs, 2), groups_a, group, trace, finds)
    find("#" substr(springs, 2), groups_b, group, trace, finds)
  }
}

function find_count(springs, groups,    groups_arr, finds) {
  split(groups, groups_arr, ",")
  find(springs, groups_arr, 1, "", finds)
  return length(finds)
}

{ sum += find_count($1, $2) }

END { print sum }

@load "ordchr"

function hash(s,    i, h) {
  for (i = 1; i <= length(s); i++)
    h = ((h + ord(substr(s, i, 1))) * 17) % 256
  return h
}

BEGIN {
  RS = ","
  FS = "[=-]"
}

{
  if ((nl = index($0, "\n")) > 0)
    $0 = substr($0, 1, nl-1)

  tmp = ""
  subst = 0
  h = hash($1)
  split(boxes[h], lens_pairs, " ")
}

/-/ {
  for (i = 1; i <= length(lens_pairs); i += 2)
    if (lens_pairs[i] != $1)
      tmp = tmp " " lens_pairs[i] " " lens_pairs[i+1]

  boxes[h] = substr(tmp, 2)
}

/=/ {
  for (i = 1; i <= length(lens_pairs); i += 2) {
    if (lens_pairs[i] == $1) {
      tmp = tmp " " $1 " " $2
      subst = 1
    } else {
      tmp = tmp " " lens_pairs[i] " " lens_pairs[i+1]
    }
  }

  if (!subst)
    tmp = tmp " " $1 " " $2

  boxes[h] = substr(tmp, 2)
}

END {
  for (b in boxes) {
    split(boxes[b], lens_pairs, " ")
    for (i = 1; i <= length(lens_pairs); i += 2)
      sum += (b+1) * int(i/2+0.5) * lens_pairs[i+1]
  }
  print sum
}

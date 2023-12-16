@load "ordchr"

BEGIN {
  RS = ","
  FS = ""
}

{
  if ((nl = index($0, "\n")) > 0)
    $0 = substr($0, 1, nl-1)

  h = 0
  for (i = 1; i <= NF; i++)
    h = ((h + ord($i)) * 17) % 256
  sum += h
}

END { print sum }

BEGIN { FS = ";" }

{
  max["red"] = max["green"] = max["blue"] = 0;
  for (i = 1; i <= NF; i++) {
    for (color in max) {
      if (match($i, "([0-9]+) " color, tmp) && (tmp[1] > max[color])) {
        max[color] = tmp[1];
      }
    }
  }

  sum += max["red"] * max["green"] * max["blue"];
}

END { print sum }

#!/bin/bash

# Part One
cat input \
  | sed -r "s/^[ ]+([0-9]+)[ ]+([0-9]+)[ ]+([0-9]+)/\\1+\\2>\\3\&\&\\2+\\3>\\1\&\&\\3+\\1>\\2/g" \
  | bc \
  | grep 1 \
  | wc -l

# Part Two
TMP_1=""
TMP_2=""
COUNT="0"
RESULT="0"
while read line; do
  ((COUNT+=1))

  case $(($COUNT % 3)) in
    1)
      TMP_1=`echo $line | sed -r "s/[ ]+/ /g"`
      ;;
    2)
      TMP_2=`echo $line | sed -r "s/[ ]+/ /g"`
      ;;
    0)
      TMP=`echo $TMP_1 $TMP_2 $line \
        | sed -r "s/([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)/(\\1+\\4>\\7\&\&\\4+\\7>\\1\&\&\\7+\\1>\\4)+(\\2+\\5>\\8\&\&\\5+\\8>\\2\&\&\\8+\\2>\\5)+(\\3+\\6>\\9\&\&\\6+\\9>\\3\&\&\\9+\\3>\\6)/g" \
        | bc`
      ((RESULT+=TMP))
  esac
done < input
echo $RESULT

{
  match($0, /[a-z]*([0-9]).*/, re_numb_first);
  match($0, /.*([0-9])[a-z]*/, re_numb_last);
  sum += re_numb_first[1] re_numb_last[1];
}

END { print sum }

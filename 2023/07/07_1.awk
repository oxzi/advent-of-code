BEGIN {
  split("AKQJT98765432", cards, "")
  for (i = 1; i <= length(cards); i++)
    card_value[cards[i]] = sprintf("%x", i)
  delete cards
}

function deck_type__sort_val(i1, v1, i2, v2) {
  return (card_value[v1] < card_value[v2]) ? -1 : ((card_value[v1] == card_value[v2]) ? 0 : 1)
}

function deck_type__sort_numb(i1, v1, i2, v2) {
  return (v1 > v2) ? -1 : ((v1 == v2) ? 0 : 1)
}

function deck_type(deck,    cards, card_kind, best_card, deck_val, deck_vals) {
  split(deck, cards, "")
  asort(cards, cards, "deck_type__sort_val")
  for (i = 1; i <= length(cards); i++)
    card_kind[cards[i]]++

  asort(card_kind, card_kind, "deck_type__sort_numb")
  for (i = 1; i <= length(card_kind); i++)
    deck_val = deck_val card_kind[i]

  split("5 41 32 3 22 2", deck_vals, " ")
  for (i = 1; i <= length(deck_vals); i++)
    if (match(deck_val, "^" deck_vals[i]))
      break
  return i
}

function deck_card_values(deck,    cards, vals) {
  split(deck, cards, "")
  for (i = 1; i <= length(cards); i++)
    vals = vals card_value[cards[i]]
  return vals
}

{ decks[NR] = deck_type($1) deck_card_values($1) FS $0 }

END {
  asort(decks)
  for (i = 1; i <= length(decks); i++) {
    split(decks[i], deck_fields)
    sum += deck_fields[3] * (NR-i+1)
  }
  print sum
}

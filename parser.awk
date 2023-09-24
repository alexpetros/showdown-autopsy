BEGIN {
  FS="|"
}

{ reparse() }

$1 == "poke" {
  key = getMonKey($2, $3)
  mons[key] = 100
}

$1 == "player"  {
  if ($2 == "p1") p1 = $3
  if ($2 == "p2") p2 = $3
}

$1 == "turn" {
  p1a_health = mons[getMonKey("p1", p1a)]
  p2a_health = mons[getMonKey("p2", p2a)]
  printf "End of turn %d: %s (%d%%), %s (%d%%)\n\n", $2-1, p1a, p1a_health, p2a, p2a_health
  printf ("Turn %d\n", $2)
}

$1 == "switch" {
  player = getPlayer()
  mon = getSpecies($3)
  key = getMonKey(player, mon)

  if (player == "p1") { old_mon = p1a; p1a = mon }
  if (player == "p2") { old_mon = p2a; p2a = mon }

  print player " switched out " old_mon " for " mon

  hp = parse_hp($4)
  mons[key] = hp
}

$1 == "-heal" {
  new_hp = parse_hp($3)
  player = getPlayer()
  mon = player == "p1" ? p1a : p2a

  key = getMonKey(player, mon)
  mons[key] = new_hp
}



$1 == "move" {
  player = getPlayer()
  move = $3

  attacker = player == "p1" ? p1a : p2a
  print attacker " used " move
}

$1 == "-damage" {
  player = getPlayer()

  if ($4) {
    player = substr($2, 0, 2)
    mon = player == "p1" ? p1a : p2a
    defender_key = getMonKey(player, mon)
    prev_hp = mons[defender_key]
    new_hp = parse_hp($3)
    print mon " took " prev_hp - new_hp " " $4
  } else {

    if (player == "p1") {
      defender = p1a
      defender_hp = mons["p1-"defender]
      defender_key = getMonKey("p1", defender)
    } else {
      defender = p2a
      defender_hp = mons["p2-"defender]
      defender_key = getMonKey("p2", defender)
    }

    new_hp = parse_hp($3)

    damage = defender_hp - new_hp
    print "It did " damage "% to " defender " (" new_hp "%)"
  }

  if (new_hp == "0") print defender " fainted."

  mons[defender_key] = new_hp

}

function getPlayer() {
  return substr($2, 1, 2)
}

# Remove the leading "|" and reparse the line withouth it
# This let us access the first field as $1 instead of $2
# Just a little quality-of-life hack
function reparse () {
  gsub(/^\|/, "")
  $0 = $0
}

function getSpecies(mon_extended) {
  comma_loc = match(mon_extended, ",")
  return comma_loc > 0 ? substr(mon_extended, 0, comma_loc - 1) : mon_extended
}

function getMonKey(player, mon) {
  mon = getSpecies(mon)
  return player"-"mon
}

function parse_hp(hp_pct) {
  split(hp_pct, new_pct, "\\")
  hp = new_pct[1] + 0
  return hp
}


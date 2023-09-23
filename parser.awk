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

$1 == "switch" {
  if (getPlayer() == "p1") p1a = getSpecies($3)
  if (getPlayer() == "p2") p2a = getSpecies($3)
}

$1 == "-heal" {
  split($3, new_pct, "\\")
  new_hp = new_pct[1] + 0

  player = getPlayer()
  mon = player == "p1" ? p1a : p2a

  key = getMonKey(player, mon)
  mons[key] = new_hp
}



$1 == "move" {

  player = getPlayer()

  if (player == "p1") {
    attacker = p1a
    defender = p2a
    attacker_hp = mons["p1-"attacker]
    defender_hp = mons["p2-"defender]
  } else {
    attacker = p2a
    defender = p1a
    attacker_hp = mons["p2-"attacker]
    defender_hp = mons["p1-"defender]
  }


  while ($1 != "-damage" && $1 != "") {
    getline
    reparse()
  }

  if ($1 == "-damage") {

    if (substr($3, 0, 1) == "0") {
      new_defender_hp = 0
    } else {
      split($3, new_pct, "\\")
      new_defender_hp = new_pct[1] + 0
    }

    damage = defender_hp - new_defender_hp

    if (new_defender_hp == "0") {
      print attacker " ("attacker_hp"%)" " killed " defender
    } else {
      print attacker " ("attacker_hp"%)" " did " damage "% to " defender " (" new_defender_hp "%)"
    }

    if (getPlayer() == "p1a") {
      mons["p1-"defender] = new_defender_hp
    } else {
      mons["p2-"defender] = new_defender_hp
    }
  }

}

END {

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
  print mon
  return player"-"mon
}


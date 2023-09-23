BEGIN {
  FS="|"
}

{ reparse() }

$1 == "poke" {
  player = $2
  mon = $3
  key = player"-"mon
  mons[key] = 100
}

$1 == "player"  {
  if ($2 == "p1") p1 = $3
  if ($2 == "p2") p2 = $3
}

$1 == "switch" {
  if (getPlayer() == "p1a") p1a = $3
  if (getPlayer() == "p2a") p2a = $3
}

$1 == "-heal" {
  split($3, new_pct, "\\")
  new_hp = new_pct[1] + 0

  if (getPlayer() == "p1a") {
    mon = p1a
    key = "p1-"mon
  } else {
    mon = p2a
    key = "p2-"mon
  }
    mons[key] = new_hp

  # print mon " healed up to " new_hp "% " $4
}



$1 == "move" {

  if (getPlayer() == "p1a") {
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
  return substr($2, 1, 3)
}

# Remove the leading "|" and reparse the line withouth it
# This let us access the first field as $1 instead of $2
# Just a little quality-of-life hack
function reparse () {
  gsub(/^\|/, "")
  $0 = $0
}


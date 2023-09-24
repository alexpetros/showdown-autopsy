BEGIN {
  FS="|"
}

# Remove the leading "|" and reparse the line withouth it
# This let us access the first field as $1 instead of $2
# Just a little quality-of-life hack
{ gsub(/^\|/, ""); $0 = $0 }

$1 == "poke" { set_hp($2, $3, 100)
}

$1 == "player"  {
  if ($2 == "p1") p1 = $3
  if ($2 == "p2") p2 = $3
}

$1 == "turn" {
  p1a_health = get_hp("p1", p1a)
  p2a_health = get_hp("p2", p2a)
  printf "End of turn %d: %s (%d%%), %s (%d%%)\n\n", $2-1, p1a, p1a_health, p2a, p2a_health
  printf ("Turn %d\n", $2)
}

$1 == "switch" {
  player = get_player($2)
  mon = get_species($3)

  if (player == "p1") { old_mon = p1a; p1a = mon }
  if (player == "p2") { old_mon = p2a; p2a = mon }

  print player " switched out " old_mon " for " mon
}

$1 == "-heal" {
  player = get_player($2)
  mon = player == "p1" ? p1a : p2a
  new_hp = parse_hp($3)
  set_hp(player, mon, new_hp)
}

$1 == "move" {
  player = get_player($2)
  move = $3

  attacker = player == "p1" ? p1a : p2a
  print attacker " used " move
}

$1 == "-damage" {
  player = get_player($2)
  mon = player == "p1" ? p1a : p2a
  prev_hp = get_hp(player, mon)
  new_hp = parse_hp($3)
  damage = prev_hp - new_hp

  if ($4) {
    print mon " took " damage"% " $4
  } else {
    print "It did " damage "% to " mon " (" new_hp "%)"
  }

  if (new_hp == 0) {
    opp_player = player == "p2" ? "p1" :"p2"
    opp_mon = player == "p2" ? p1a : p2a
    kills[opp_player"-"opp_mon] += 1
    deaths[player"-"mon] = 1
    print mon " fainted."
  }
  set_hp(player, mon, new_hp)
}

END {
  print "\nKills:"
  for (mon in kills) print mon, kills[mon]
  print "\nDeaths:"
  for (mon in deaths) print mon, deaths[mon]
}

function get_player(pokemon_id) {
  return substr(pokemon_id, 1, 2)
}

function get_species(mon_extended) {
  comma_loc = match(mon_extended, ",")
  return comma_loc > 0 ? substr(mon_extended, 0, comma_loc - 1) : mon_extended
}

function get_hp(player, mon) {
  mon = get_species(mon)
  return mons[player"-"mon]
}

function set_hp(player, mon, health) {
  mon = get_species(mon)
  mons[player"-"mon] = health
}

function parse_hp(hp_pct) {
  split(hp_pct, new_pct, "\\")
  hp = new_pct[1] + 0
  return hp
}


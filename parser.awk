#!awk -f

BEGIN {
  FS="|"
  BATTLE_LOG = "DEBUG" in ENVIRON
  SPLIT = "SPLIT" in ENVIRON
  games=0
}

FNR == 1 {
  delete mons
}

# Remove the leading "|" and reparse the line withouth it
# This let us access the first field as $1 instead of $2
# Just a little quality-of-life hack
{ gsub(/^\|/, ""); $0 = $0 }


$1 == "player"  {
  if ($2 == "p1") p1 = $3
  if ($2 == "p2") p2 = $3
}

$1 == "poke" {
  set_hp($2, $3, 100)

  player_name = $2 == "p1" ? p1 : p2
  mon = get_species($3)
  starts[player_name"-"mon] += 1
}

$1 == "turn" {
  p1a_hp = get_hp("p1", p1a)
  p2s_hp = get_hp("p2", p2a)
  battle_log(sprintf("End of turn %d: %s (%d%%), %s (%d%%)\n", $2-1, p1a, p1a_hp, p2a, p2s_hp))
  battle_log(sprintf("Turn %d", $2))
}

$1 == "switch" {
  player = get_player($2)
  mon = get_species($3)

  if (player == "p1") { old_mon = p1a; p1a = mon }
  if (player == "p2") { old_mon = p2a; p2a = mon }

  battle_log(player " switched out " old_mon " for " mon)
}

$1 == "move" {
  player = get_player($2)
  move = $3
  attacker = player == "p1" ? p1a : p2a
  battle_log(attacker " used " move)
}

$1 == "-heal" {
  player = get_player($2)
  mon = player == "p1" ? p1a : p2a
  new_hp = parse_hp($3)
  set_hp(player, mon, new_hp)
}

$1 == "-damage" {
  player = get_player($2)
  mon = player == "p1" ? p1a : p2a
  prev_hp = get_hp(player, mon)
  new_hp = parse_hp($3)
  damage = prev_hp - new_hp

  if ($4) {
    battle_log(mon " took " damage"% " $4)
  } else {
    battle_log("It did " damage "% to " mon " (" new_hp "%)")
  }

  if (new_hp == 0) {
    player_name = player == "p1" ? p1 : p2
    opp_player_name = player == "p2" ? p1 : p2
    opp_mon = player == "p2" ? p1a : p2a

    kills[opp_player_name"-"opp_mon] += 1
    deaths[player_name"-"mon] += 1
    battle_log(mon " fainted.")
  }

  set_hp(player, mon, new_hp)
}

$1 == "win" {
  games += 1
}

$1 == "win" && SPLIT {
  print "Game "games " - " p1 " vs " p2
  outputStats()
  delete starts
  delete kills
  delete deaths
  print ""
}

END {
  if (!SPLIT) outputStats()
}

function outputStats () {
  for (mon in starts) {
    total_appearances = starts[mon]
    total_kills = kills[mon] > 0 ? kills[mon] : 0
    total_deaths = deaths[mon] > 0 ? deaths[mon] : 0

    split(mon, name_split, "-")
    player_name = name_split[1]
    mon_name = name_split[2]

    printf ("%s:%s:%s:%s:%s\n", player_name, mon_name, total_appearances, total_kills, total_deaths)
  }
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

function battle_log(message) {
  if (BATTLE_LOG) print message
}

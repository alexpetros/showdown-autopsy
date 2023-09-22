BEGIN {
  FS="|"
}

# Remove the leading "|" and reparse the line withouth it
# This let us access the first field as $1 instead of $2
# Just a little quality-of-life hack
{
  gsub(/^\|/, "")
  $0 = $0
}

$1 == "player"  {
  if ($2 == "p1") p1 = $3
  if ($2 == "p2") p2 = $3
}

END {
  print p1
  print p2
}

# Pokemon Showdown Battlelog SQLizer
A mildly-reasonable tool to translate Showdown battle logs into SQL data about battles, written in
awk.

## Usage
```
# Display the stats
awk -f parser.awk BATTLE_LOG_FILEPATH

# Add DEBUG to show the entire battle parsing
DEBUG=1 awk -f parser.awk BATTLE_LOG_FILEPATH
```

## Why?
I would like to be able to create stats out of the battles from my Showdown Draft League, and
analyze them with SQL. I also want to generate the wins/losses/kills/deaths sheet.

## Why awk?
I like awk, and it's perfect for structured, line-based data.

## What protocol?
The [Pokemon Showdown Battle Protocol](https://github.com/smogon/pokemon-showdown/blob/master/sim/SIM-PROTOCOL.md)

# Pokemon Showdown Battlelog SQLizer
A mildly-reasonable tool to translate Showdown battle logs into SQL data about battles, written in
awk.

Written in POSIX-compatible awk, so it should work with literally any awk installation you have.

The only pre-requisite is that you have to understand some command-line basics. I'm still working on
this so the interface is subject to change.

## Installation
Just download this repo and run the `parser.awk` script with any showdown battle log as the STDIN.

To get a battle log, you can just append `.log` to the URL or any showdown replay. Save the contents
of that file somewhere, and substitute in the filepath anywhere you see `BATTLE_LOG_FILEPATH` below.

## Usage
If you have a local awk installation (you do) you can invoke the parser directly:

```bash
# These three are equivalent
./parser.awk BATTLE_LOG_FILEPATH
awk -f ./parser.awk < BATTLE_LOG_FILEPATH
cat BATTLE_LOG_FILEPATH | awk -f ./parser.awk
```

It can also parse multiple battle logs no problem:

```bash
# Aggregate and parse every battle in the logs file (i.e. every file that ends in .log)
./parser.awk < ./logs/.*log
```

And you can add `DEBUG=1` if you want to print out the actual turns of the battle as well.
```bash
# Add DEBUG if you want to pretty-print the battle
DEBUG=1 awk -f parser.awk BATTLE_LOG_FILEPATH
```

I also included a `get-logs.sh` function which will read a list of links from STDIN and download
them to the `logs/` directory in this repo.

## Why?
I would like to be able to create stats out of the battles from my Showdown Draft League, and
analyze them with SQL. I also want to generate the wins/losses/kills/deaths sheet.

## Why awk?
awk is goated when parsing structured, line-based data is the vibe

## What protocol?
The [Pokemon Showdown Battle Protocol](https://github.com/smogon/pokemon-showdown/blob/master/sim/SIM-PROTOCOL.md)

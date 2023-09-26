# Pokemon Showdown Battlelog SQLizer
A mildly-reasonable tool to translate Showdown battle logs into SQL data about battles. Written in
POSIX-compatible awk, so it should work with literally any awk installation you have.

The only pre-requisite is that you have to understand some command-line basics.

I'm still working on this so the interface is subject to change (right now it's not that great).

## Installation
Just download this repo and run the `parser.awk` script with any showdown battle log as the STDIN.

To get a battle log, you can just append `.log` to the URL of any showdown replay. Save the contents
of that file somewhere, and substitute in the filepath anywhere you see `BATTLE_LOG_FILEPATH` below.

## Quickstart
If you have a local awk installation (you do) you can invoke the parser directly, with a filepath:

* Analyze a single battle: `./parser.awk BATTLE_LOG_FILEPATH`
* Analyze multiple battles (uses shell filepath glob): `./parser.awk logs/*.log`
* Analyze multiple battles (uses STDIN): `cat logs/*.log | ./parser.awk`
* Analyze multiple battles, but print individual results: `SPLIT=1 ./parser.awk < logs/*.log`
* Print out a play by play of a battle: `DEBUG=1 ./parser.awk BATTLE_LOG_FILEPATH`

Stats are output in colon-delimited form:
```
# Example from my draft league
$ ./parser.awk logs/*.log | head -n 4
GPearls:Tornadus:2:0:2
yomamasjigglypuffs:Azelf:4:1:2
GPearls:Amoonguss:6:4:5
pop punk pelosi:Chesnaught:5:3:4
```

This is obviously not the nicest for humans to read but it's very easy to morph into whatever form
you like.

I also included a `get-logs.sh` function which will read a list of links from STDIN and download
them to the `logs/` directory in this repo.

## Examples

## Why?
I would like to be able to create stats out of the battles from my Showdown Draft League, and
analyze them with SQL. I also want to generate the wins/losses/kills/deaths sheet.

## Why awk?
awk is goated when parsing structured, line-based data is the vibe

## What protocol?
The [Pokemon Showdown Battle Protocol](https://github.com/smogon/pokemon-showdown/blob/master/sim/SIM-PROTOCOL.md)

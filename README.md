# Autopsy - Pokemon Showdown Battle Reports
A mildly-reasonable tool to translate Showdown battle logs into data. Written POSIX-compatible awk,
so it should work with literally any awk installation you have.

The only pre-requisite is that you have to understand command-line basics (pipes, STDIN, and so on).

I'm still working on this so the interface is subject to change (right now it's not that great).

## Installation
Just download this repo and run the `parser.awk` script with any showdown battle log as the STDIN.

To get a battle log, you can just append `.log` to the URL of any showdown replay. Save the contents
of that file somewhere, and use that file(s) in any of the examples below.

## Quickstart
If you have a local awk installation (you do) you can invoke the parser directly, with a filepath:

* Analyze a single battle: `./autopsy test-log.log`
* Analyze multiple battles (uses shell filepath glob): `autopsy logs/*.log`
* Analyze multiple battles (uses STDIN): `cat logs/*.log | autopsy`
* Analyze multiple battles, but print individual results: `autopsy -s < logs/*.log`
* Print out a play by play of a battle: `autopsy -r BATTLE_LOG_FILEPATH`

Stats are output in colon-delimited form:
```sh
# Example from my draft league
# The columns are: Name, Pokemon, Starts, Kills, Deaths
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
The output format is colon-delimited so that you can combine it with various unix tools. So lets say
that you wanted to sort by Pokemon that got the most kills, simply pass that to the `sort` command
with the appropriate options:

```sh
# Sort options say:
#   sort by number (-n),
#   reversed (-r),
#   with a colon delimeter (-t :),
#   using the 4th column (-k 4)
# Then the head options say: get the top 5 results (-n 5)
$ ./parser.awk logs/*.log | sort -nr -t : -k 4 | head -n 5
yomamasjigglypuffs:Baxcalibur:7:12:6
OnCloudNinetails:Diancie:7:12:5
Muk Muk Goodra:Roaring Moon:9:11:4
wangstaaa:Dragonite:9:10:4
pop punk pelosi:Hydreigon:9:10:4
```

That's not very pretty, but we can pass the results of that to the column tool, which will format
it:
```sh
# Same as before, but now autoformat a column (-t) using colons as the delimeter (-s :)
$ ./parser.awk logs/*.log | sort -nr -t : -k 4 | column -t -s : | head -5
yomamasjigglypuffs  Baxcalibur    7   12  6
OnCloudNinetails    Diancie       7   12  5
Muk Muk Goodra      Roaring Moon  9   11  4
wangstaaa           Dragonite     9   10  4
pop punk pelosi     Hydreigon     9   10  4
```

## Why?
I would like to be able to create stats out of the battles from my Showdown Draft League, and
analyze them with SQL. I also want to generate the wins/losses/kills/deaths sheet.

What's nifty about this parser is that it isn't just parsing each statement line-by-line, it's
updating an internal state about the game being played. For this reason it's very easy to extend to
collect new stats, and, in theory, could be easily extended into a CLI Showdown client.

## Why awk?
awk is goated when parsing structured, line-based data is the vibe

## What protocol?
The [Pokemon Showdown Battle Protocol](https://github.com/smogon/pokemon-showdown/blob/master/sim/SIM-PROTOCOL.md)

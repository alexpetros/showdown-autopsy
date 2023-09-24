# Showdown Protocol SQLizer
A mildly-reasonable tool to translate Showdown battle logs into SQL data about battles, written in
awk.

## Usage
`awk -f parser.awk BATTLE_LOG_FILEPATH`

## Why?
I would like to be able to create stats out of the battles from my Showdown Draft League, and
analyze them with SQL. I also want to generate the wins/losses/kills/deaths sheet.

## Why awk?
I like awk, and it's perfect for structured, line-based data.

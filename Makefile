.PHONY: all
all: logs

# Runs the parser through the contents of all the files in ./logs
# You have to do the find | xargs thing because make doesn't let you do shell expansions
.PHONY: logs
logs:
	@find ./logs -name '*.log' | xargs cat |  awk -f ./parser.awk


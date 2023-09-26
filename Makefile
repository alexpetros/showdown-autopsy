.PHONY: all
all: draft

.PHONY: draft
draft:
	find ./logs -name '*.log' | xargs cat |  awk -f ./parser.awk


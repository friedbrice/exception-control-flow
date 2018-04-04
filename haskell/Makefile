.PHONY: all
all: clean test

.PHONY: clean
clean:

.PHONY: test
test:
	runghc Test.hs

.PHONY: repl
repl:
	ghci Test.hs

.PHONY: check
check:
	ghc -fno-code Test.hs

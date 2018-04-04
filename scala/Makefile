.PHONY: all
all: clean test

.PHONY: clean
clean:
	if [ -d lib ]; then rm -r lib; fi

.PHONY: compile
compile:
	mkdir -p lib
	scalac -d lib Spec.scala \
	              Undefined.scala \
	              Prototype.scala \
	              Exceptions.scala \
	              Continuations.scala \
	              Eithers.scala \
	              Test.scala

.PHONY: test
test: compile
	scala -classpath lib Test

.PHONY: repl
repl: compile
	scala -classpath lib

.PHONY: check
check:
	scalac -Ystop-after:refchecks Spec.scala \
	                              Undefined.scala \
	                              Prototype.scala \
	                              Exceptions.scala \
	                              Continuations.scala \
	                              Eithers.scala \
	                              Test.scala

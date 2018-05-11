# Models of Exception Control Flow

Code examples accompanying a blog post series by Daniel Brice.

## Scala Workflow

Assumes you have `make` and `scala` installed and on your path.

This project uses a _Makefile_. Run any of the below make targets by invoking `make <target>` from the _scala_ directory, or (optionally) continually run any of the make targets by invoking `watch make <target>`.

**Make Targets:**

  - _all:_ Alias for _clean test_.

  - _clean:_ Remove the _lib_ subdirectory, if it exists.

  - _compile:_ Compile all source files, saving build artifacts in the _lib_ directory (creating it if it does not exist).

  - _test:_ _compile_, and run the automated tests.

  - _repl:_ _compile_, and Open a Scala REPL with all source files in scope.

  - _check:_ Parse and typecheck all source files without compiling. Use with `watch` while editing files for quick feedback.

## Haskell Workflow

Assumes you have `make` and `haskell-platform` installed.

This project uses a _Makefile_. Run any of the below make targets by invoking `make <target>` from the _haskell_ directory, or (optionally) continually run any of the make targets by invoking `watch make <target>`.

**Make Targets:**

  - _all:_ Alias for _test_.

  - _test:_ Run the automated tests.

  - _repl:_ Open a _GHCi_ REPL, with the contents of _Spec.hs_, _Test.hs_, and _Undefined.hs_ in global scope and the contents of _Continuations.hs_, _Eithers.hs_, and _Transformers.hs_ scoped to `Continuations`, `Eithers`, and `Transformers` respectively.

  - _check:_ Parse and typecheck all source files without compiling. Use with `watch` while editing files for quick feedback.

# RFuzzy

This package implements another extension of Prolog to deal with
uncertainty, implemented as a
[Ciao](https://github.com/ciao-lang/ciao) package.

Please consult the documentation for more details. See the
[bibliography](doc/bibliography.bib) for detailed information about
the semantics of this implementation.

# Installation and usage

You can automatically fetch, build, and install this package using:

```sh
ciao get github.com/FuzzyLP/RFuzzy
```

This command stores the source and compiles them in the Ciao
_workspace directory_. This directory is given by the value of the
`CIAOPATH` environment variable (or `~/.ciao` if unspecified).

Documentation is placed in the `$CIAOPATH/build/doc` directory (or
`~/.ciao/build/doc`).

**For developing** it is recommended to define `CIAOPATH` (E.g.,
`~/ciao`) and clone this repository in your workspace.

# Examples

At [examples](examples/) directory you may find some examples that
show you how to use the library.


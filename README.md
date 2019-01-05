# Porter2

A naive implementation of the Porter2 stemming algorithm as described on
http://snowballstem.org/algorithms/english/stemmer.html

The implementation is not as clean as could be, especially the reverse processing
of words is not as consequent as could be - words are reversed more often than
needs be.



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `porter2` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:porter2, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/porter2](https://hexdocs.pm/porter2).


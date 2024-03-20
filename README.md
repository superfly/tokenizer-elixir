# Tokenizer

## Installation
You will need to have `libsodium` installed and running locally to use this package. On Mac, you can install it with `brew install libsodium`. On Ubuntu, you can install it with `sudo apt-get install libsodium-dev`.

Adding `tokenizer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tokenizer, "~> 0.1.0"}
  ]
end
```

## Trouble on Mac's
If you have trouble on Mac's even after installing libsodium via homebrew try this before trying to compiling.

```shell
export CPATH="$HOMEBREW_PREFIX/include:$CPATH"
export LIBRARY_PATH="$HOMEBREW_PREFIX/lib:$LIBRARY_PATH"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tokenizer>.

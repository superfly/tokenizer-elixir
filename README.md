# Tokenizer

Elixir library for creating and sealing tokenizer proxy secrets and macaroon authorization headers.

## Installation

Tokenizer uses libsodium via `libsalty2`, so install the system library before
fetching and compiling dependencies:

```sh
# macOS
brew install libsodium

# Debian/Ubuntu
sudo apt-get install -y libsodium-dev
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tokenizer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tokenizer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tokenizer>.


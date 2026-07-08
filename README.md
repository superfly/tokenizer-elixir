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

On Apple Silicon, `libsalty2` may need explicit Homebrew paths when compiling
its NIF:

```sh
CROSSCOMPILE=1 \
CFLAGS="-O2 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -I/opt/homebrew/opt/libsodium/include" \
LDFLAGS="-L/opt/homebrew/opt/libsodium/lib -Wl,-rpath,/opt/homebrew/opt/libsodium/lib -undefined dynamic_lookup" \
mix deps.compile libsalty2 --force
```

Add `tokenizer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tokenizer, "~> 0.3.0"}
  ]
end
```

Documentation is available at <https://hexdocs.pm/tokenizer>.


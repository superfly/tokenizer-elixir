# Changelog

## 0.3.0

- Replace HTTPoison usage with Req.
- Depend on `macfly ~> 0.2.21`, which uses Req and makes Jason optional.
- Replace the unsupported `libsodium` dependency with `libsalty2` / Salty.
- Use Elixir's built-in JSON support by default while keeping optional Jason encoder compatibility.
- Require Elixir `~> 1.18`.
- Document libsodium system package installation for Homebrew and apt.
- Add mise tool versions for local development.

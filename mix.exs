defmodule Tokenizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :tokenizer,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:macfly, "~> 0.1.0", github: "superfly/macaroon-elixir"},
      {:libsodium, "~> 2.0.0"}
    ]
  end
end

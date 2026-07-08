defmodule Tokenizer.MixProject do
  use Mix.Project

  @source_url "https://github.com/superfly/tokenizer-elixir"
  @version "0.3.0"

  def project do
    [
      app: :tokenizer,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications:
        if(Mix.env() == :test, do: [:logger, :crypto, :runtime_tools], else: [:logger, :crypto])
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:req, "~> 0.6"},
      {:macfly, "~> 0.2.21"},
      {:libsalty2, "~> 0.3.0"},
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "tokenizer",
      description: "Elixir library for creating and sealing tokenizer proxy secrets",
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end
end

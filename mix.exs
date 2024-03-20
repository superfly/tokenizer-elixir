defmodule Tokenizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :tokenizer,
      version: "0.2.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
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
      {:jason, "~> 1.4"},
      {:macfly, "~> 0.2.2"},
      {:libsalty2, "~> 0.3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      name: "tokenizer",
      description: "library for working the tokenizer proxy",
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/superfly/tokenizer-elixir"}
    ]
  end
end

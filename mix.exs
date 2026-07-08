defmodule Tokenizer.MixProject do
  use Mix.Project

  def project do
    [
      app: :tokenizer,
      version: "0.2.0",
      elixir: "~> 1.18",
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
      {:req, "~> 0.6"},
      {:macfly, "~> 0.2"},
      libsalty2_dep(),
      {:ex_doc, "~> 0.38", only: :dev, runtime: false}
    ]
  end

  defp libsalty2_dep do
    case :os.type() do
      {:unix, :darwin} ->
        {:libsalty2, "~> 0.3.0",
         system_env: [
           {"CROSSCOMPILE", "1"},
           {"CFLAGS",
            "-O2 -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -I/opt/homebrew/opt/libsodium/include"},
           {"LDFLAGS",
            "-L/opt/homebrew/opt/libsodium/lib -Wl,-rpath,/opt/homebrew/opt/libsodium/lib -undefined dynamic_lookup"}
         ]}

      _ ->
        {:libsalty2, "~> 0.3.0"}
    end
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

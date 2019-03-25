defmodule BotLookup.MixProject do
  use Mix.Project

  def project do
    [
      app: :bot_lookup,
      version: "0.1.2",
      build_path: "./_build",
      config_path: "./config/config.exs",
      deps_path: "./deps",
      lockfile: "./mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BotLookup.Application, []},
      env: [require_ua: true]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.0"},
      {:plug, "~> 1.7"}
    ]
  end
end

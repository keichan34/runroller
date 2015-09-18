defmodule Runroller.Mixfile do
  use Mix.Project

  def project do
    {result, _} = System.cmd("git", ["rev-parse", "HEAD"])
    git_sha = String.slice(result, 0, 7)

    {result, _} = System.cmd("git", ["rev-list", "HEAD", "--count"])
    commit_count = String.strip(result)

    [app: :runroller,
     version: "0.0.1-#{commit_count}-#{git_sha}",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [
        :logger,
        :cowboy,
        :plug,
        :poison,
        :httpoison
      ],
      mod: {Runroller, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 1.5"},
      {:httpoison, "~> 0.7.2"},
      {:exrm, "~> 0.19.0"}
    ]
  end
end

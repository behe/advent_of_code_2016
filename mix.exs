defmodule AdventOfCode2016.Mixfile do
  use Mix.Project

  def project do
    [
      app: :advent_of_code_2016,
      version: "0.1.0",
      elixir: "~> 1.3",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.2"}
    ]
  end
end

defmodule Porter2.Mixfile do
  use Mix.Project

  def project do
    [app: :porter2,
     version: "0.1.1",
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [ espec: :test ],
     test_coverage: [ tool: Coverex.Task ],
     deps: deps(),
     description: "Implementation of the Porter2 stemming algorithm for the english language",
     package: package()
   ]
  end

  # Configuring package attributes for hex.pm
  def package do
    [ 
      name: :porter2,
      files: [ "lib", "config", "mix.exs", "README.md" ],
      maintainers: [ "Sven Riedel" ],
      licenses: [ "GPL 2" ],
      links: %{ "GitHub" => "https://github.com/sriedel/ExPorter2" }
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:espec, "1.6.3", only: :test},
      {:credo, "~> 0.5", only: [ :test, :dev ] },
      {:coverex, "~> 1.4.10", only: :test },
      {:ex_doc, ">= 0.0.0", only: :dev }
    ]
  end
end

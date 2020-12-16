defmodule DarkFlows.MixProject do
  @moduledoc """
  Mix Project
  """

  use Mix.Project

  @version "1.0.0"

  @app :dark_flows
  @name "DarkFlows"
  @github_organization "dark-elixir"
  @hexpm_url "http://hexdocs.pm/#{@app}"
  @github_url "https://github.com/#{@github_organization}/#{@app}"
  @maintainers ["sitch"]
  @description ""

  def project do
    [
      app: @app,
      version: @version,
      elixir: ">= 1.6.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: preferred_cli_env(),
      dialyzer: dialyzer(),
      package: package(),
      aliases: aliases(),
      deps: deps()
    ] ++ docs()
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [extra_applications: [:logger]]
  end

  defp dialyzer do
    [
      plt_add_deps: :app_tree,
      plt_add_apps: [:ex_unit, :iex],
      ignore_warnings: ".dialyzer_ignore.exs",
      list_unused_filters: true,
      flags: [
        # Useful additions
        :error_handling,
        :no_opaque,
        :race_conditions,
        :underspecs,
        :unmatched_returns,

        # Strict (annoying / low-impact)
        :overspecs,
        :specdiffs,

        # Less common / potentially confusing
        # (Can disable without much consequence)
        :no_behaviours,
        :no_contracts,
        :no_fail_call,
        :no_fun_app,
        :no_improper_lists,
        :no_match,
        :no_missing_calls,
        :no_return,
        :no_undefined_callbacks,
        :no_unused,
        :unknown
      ]
    ]
  end

  defp deps do
    [
      # {:prop_schema, ">= 1.0.0"},
      # {:jason, ">= 1.0.0"},
      # {:dark_ecto, ">= 1.0.0"},
      {:opus, "~> 0.6"},

      # Development
      # {:faker, "~> 0.13", only: [:dev, :test]},
      # {:ex_machina, "~> 2.4", only: [:dev, :test]},
      {:dark_dev, ">= 1.0.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp preferred_cli_env do
    [
      check: :test,
      credo: :test,
      dialyzer: :test,
      sobelow: :test
    ]
  end

  defp aliases do
    []
  end

  defp package() do
    [
      maintainers: @maintainers,
      files: ~w(lib priv .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @github_url}
    ]
  end

  # Auto-generated documentation
  defp docs do
    [
      source_ref: "v#{@version}",
      main: @name,
      name: @name,
      description: @description,
      canonical: @hexpm_url,
      source_url: @github_url,
      homepage_url: @github_url,
      docs: [
        # The main page in the docs
        main: "DarkFlows",
        # logo: "priv/static/images/logo.png",
        # extra_section: "GUIDES",
        extras: [
          "README.md"
          # "guides/introduction/Getting Started.md",
          # "docs/GLOSSARY.md",
          # "docs/OVERVIEW.md",
        ],
        groups_for_extras: [
          # Introduction: ~r/guides\/introduction\/.?/,
          # Domains: Path.wildcard("docs/domains/*.md"),
        ],
        groups_for_modules: []
      ]
    ]
  end
end

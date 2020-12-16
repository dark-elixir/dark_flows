[
  ## all available options with default values (see `mix check` docs for description)
  ## Defaults

  # parallel: true,
  # skipped: true,
  # tools: [
  #   {:compiler, "mix compile --warnings-as-errors --force"},
  #   {:formatter, "mix format --check-formatted", detect: [{:file, ".formatter.exs"}]},
  #   {:credo, "mix credo", detect: [{:package, :credo}]},
  #   {:sobelow, "mix sobelow --exit", umbrella: [recursive: true], detect: [{:package, :sobelow}]},
  #   {:ex_doc, "mix docs", detect: [{:package, :ex_doc}]},
  #   {:ex_unit, "mix test", detect: [{:file, "test"}]},
  #   {:dialyzer, "mix dialyzer", detect: [{:package, :dialyxir}]},
  #   {:unused_deps, "mix deps.unlock --check-unused", detect: [{:elixir, ">= 1.10.0"}]},
  #   {:npm_test, "npm test", cd: "assets", detect: [{:file, "package.json", else: :disable}]}
  # ]

  tools: [
    # Avoid double compiles for `:dev` and `:test` envs.
    # See: https://github.com/karolsluszniak/ex_check#avoiding-duplicate-builds

    {:ex_doc, env: %{"MIX_ENV" => "test"}, detect: [package: :dark_dev]},
    {:compiler, env: %{"MIX_ENV" => "test"}},
    {:formatter, env: %{"MIX_ENV" => "test"}},
    {:credo, detect: [package: :dark_dev]},
    {:sobelow, detect: [package: :dark_dev]},
    {:dialyzer, detect: [package: :dark_dev]}
  ]
]

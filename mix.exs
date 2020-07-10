defmodule Vox.MixProject do
    use Mix.Project

    def project do
        [
            app: :vox,
            version: "0.1.0",
            elixir: "~> 1.10",
            start_permanent: Mix.env() == :prod,
            deps: deps()
        ]
    end

    def application do
        [extra_applications: [:logger]]
    end

    defp deps do
        [
            { :tonic, "~> 0.2.2"  }
        ]
    end
end

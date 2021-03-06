defmodule Vox.MixProject do
    use Mix.Project

    def project do
        [
            app: :vox,
            version: "0.1.0",
            elixir: "~> 1.10",
            start_permanent: Mix.env() == :prod,
            deps: deps(),
            docs: [
                markdown_processor: ExDocSimpleMarkdown
            ]
        ]
    end

    def application do
        [extra_applications: [:logger]]
    end

    defp deps do
        [
            { :tonic, "~> 0.2.2"  },
            { :simple_markdown, "~> 0.8", only: :dev, runtime: false },
            { :ex_doc_simple_markdown, "~> 0.5", only: :dev, runtime: false },
            { :ex_doc, "~> 0.18", only: :dev }
        ]
    end
end

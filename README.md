# SolrLow

**TODO: Add description**


```elixir

  url = "http://localhost:8983/solr"
  client = SolrLow.Client.new(url) #=> ["med", "blacklight", "testcore"]
  searchHandler = client |> SolrLow.Core.new("med") |> SolrLow.Core.set_handler("search")
  


```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `solr_low` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:solr_low, "~> 0.1.0"}]
    end
    ```

  2. Ensure `solr_low` is started before your application:

    ```elixir
    def application do
      [applications: [:solr_low]]
    end
    ```


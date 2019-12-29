require Tesla

defmodule SolrLow.HTTP do
  use Tesla

  plug(Tesla.Middleware.Query, wt: "json")
  plug(Tesla.Middleware.Headers, [{"User-Agent", "ElixirSolrLow"}])
  plug(Tesla.Middleware.JSON)

  plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.BaseUrl)

  @type t :: __MODULE__

  def new(url) do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, url}
    ])
  end
end

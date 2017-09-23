require Tesla

defmodule SolrLow do
  use Tesla

  plug Tesla.Middleware.Query, [wt: "json"]
  plug Tesla.Middleware.Headers, %{"User-Agent" => "ElixirSolrLow"}
#  plug Tesla.Middleware.JSON


  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl

  def client(url) do
    Tesla.build_client [
      {Tesla.Middleware.BaseUrl, url}
    ]
  end

  def keyword(client, kw, value) do
    y = SolrLow.get(client, "select", query: [q: "#{kw}:#{value}"])
    case y.status do
      200 -> SolrLow.SolrReply.from_json  y.body
      _ -> {:error, y.status, y}
    end

  end
 

end

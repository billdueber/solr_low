# require Tesla
#
# defmodule SolrLow.Client do
#  use Tesla
#
#  plug Tesla.Middleware.Query, [wt: "json"]
#  plug Tesla.Middleware.Headers, %{"User-Agent" => "ElixirSolrLow"}
#  plug Tesla.Middleware.JSON
#
#
#  plug Tesla.Middleware.Logger
#  plug Tesla.Middleware.BaseUrl
#
#  def new_from_url(url) do
#    Tesla.build_client [
#      {Tesla.Middleware.BaseUrl, url}
#    ]
#  end
#
#  def cores(client) do
#    r = get(client, "/admin/cores")
#    case r.status do
#      200 ->
#        r.body
#        |> Map.get("status")
#        |> Map.keys
#      _ -> {:error, r.status, r}
#    end
#  end
#
#  def keyword(client, kw, value) do
#    y = get(
#      client,
#      "select",
#      query: [
#        q: "#{kw}:#{value}"
#      ]
#    )
#    case y.status do
#      200 -> SolrLow.SolrReply.from_map  y.body
#      _ -> {:error, y.status, y}
#    end
#
#  end
#
# end

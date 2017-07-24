require Tesla

defmodule SolrReply do
    @derive [Poison.Encoder]
    defstruct [:responseHeader, :response]

  defmodule ResponseHeader do
    @derive [Poison.Encoder]
    defstruct [:status, :QTime, :params]
  end

  defmodule Response do
    @derive [Poison.Encoder]
    defstruct [:docs, :numFound, :start]
  end

  @type reply_decode_type ::    %SolrReply{responseHeader: %SolrReply.ResponseHeader{},
                                           response: %SolrReply.Response{}}


  def qtime(sr) do
    Map.get sr.responseHeader, :QTime
  end

  def numFound(sr) do
    sr.response.numFound
  end

  def start(sr) do
    sr.response.start
  end

  def docs(sr) do
    sr.response.docs
  end

  def params(sr) do
    sr.responseHeader.params
  end

  def status(sr) do
    sr.responseHeader.status
  end

  def count(sr) do
    sr |> docs |> Enum.count
  end
end

defmodule SolrLow do
  use Tesla

  plug Tesla.Middleware.Query, [wt: "json"]
  plug Tesla.Middleware.Headers, %{"User-Agent" => "ElixirSolrLow"}
  plug Tesla.Middleware.JSON, engine_opts: %{as: SolrReply.reply_decode_type}


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
      200 -> y.body
      _ -> {:error, y.status, y}
    end

  end
 

end

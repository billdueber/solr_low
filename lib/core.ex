defmodule SolrLow.Core do

  defstruct client: nil, core: nil, handler: nil

  alias SolrLow.Client
  alias __MODULE__

  def new(x, core, handler \\ "select")

  def new(url, core, handler) when is_binary(url) do
    new(Client.new(url), core, handler)
  end

  def new(%Client{} = c, core, handler) do
    %__MODULE__{
      client: c,
      core: core,
      handler: handler
    }
  end

  def set_handler(%Core{} = c, handler) do
    %Core{c | handler: handler}
  end

  defp path(%Core{} = core) do
    core.core <> "/" <> core.handler
  end

  def get(%Core{} = c, params \\ %{}) do
    p = Core.path(c)
    c.client
    |> Client.get(p, params)
  end

  def count(%Core{} = c) do
    c
    |> get([q: "*:*", rows: 0])
    |> SolrLow.Response.numFound
  end


end

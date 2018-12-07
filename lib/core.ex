defmodule SolrLow.Core do


  ### ARRRRGH. Handler should be it's own thing.

  defstruct client: nil, core: nil, handler: nil

  alias SolrLow.Client
  alias __MODULE__


  @type t :: %__MODULE__{
               client: Client.t,
               core: String.t,
               handler: String.t
             }



  def new(x, core, handler \\ "select")

  @spec new(String.t, String.t, String.t) :: t
  def new(url, core, handler) when is_binary(url) do
    new(Client.new(url), core, handler)
  end

  @spec new(Client.t, String.t, String.t) :: t
  def new(%SolrLow.Client{} = c, core, handler) do
    %__MODULE__{
      client: c,
      core: core,
      handler: handler
    }
  end

  # Accessor functions

  def client(%SolrLow.Core{} = c) do
    c.client
  end

  def baseurl(%SolrLow.Core{} = c) do
    c.client.baseurl
  end

  def handler(%SolrLow.Core{} = c) do
    c.handler
  end


  def set_handler(%SolrLow.Core{} = c, handler) do
    %Core{c | handler: handler}
  end

  def path(%SolrLow.Core{} = core) do
    core.core <> "/" <> core.handler
  end

  def url(%SolrLow.Core{} = c) do
    (c |> Core.client |> Client.baseurl) <> "/" <> path(c);
  end


  def get(%SolrLow.Core{} = c, params \\ %{}) do
    p = path(c)
    c.client
    |> Client.get(p, params)
  end

  def count(%SolrLow.Core{} = c) do
    c
    |> get([q: "*:*", rows: 0])
    |> SolrLow.Response.numFound
  end


end

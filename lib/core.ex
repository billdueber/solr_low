defmodule SolrLow.Core do


  ### ARRRRGH. Handler should be it's own thing.

  defstruct client: %SolrLow.Client{},
            core_name: "",
            request_handler: "select"

  alias SolrLow.Client
  alias __MODULE__

  # Let's delegate some stuff to the client



  @type t :: %__MODULE__{
               client: Client.t,
               core_name: String.t,
               request_handler: String.t
             }



  def new(%SolrLow.Client{} = c, core_name) do
    %__MODULE__{
      client: c,
      core_name: core_name
    }
  end

  def request_handler(%SolrLow.Core{} = c) do
    c.request_handler
  end

  def request_handler(%SolrLow.Core{} = c, request_handler) do
    %{c | request_handler: request_handler}
  end

  def path(%SolrLow.Core{} = core) do
    (core.core_name) <> "/" <> (core.request_handler)
  end

  def url(%SolrLow.Core{} = c) do (c.client.baseurl) <> "/" <> path(c) end

  def get(%SolrLow.Core{} = c, params \\ []) do
    p = path(c)
    c.client
    |> Client.get(p, params)
  end

  def count(%SolrLow.Core{} = c) do
    c
    |> get([q: "*:*", rows: 0])
    |> SolrLow.Response.numFound
  end

  # Accessor delegate functions for the client

  def client(%SolrLow.Core{} = c) do c.client end
  def baseurl(%{baseurl: burl}) do burl end



end

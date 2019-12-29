defmodule SolrLow.Core do
  @moduledoc """
  Represent a specific core in a solr installation.
  """

  @default_handler "select"

  defstruct client: %SolrLow.Client{},
            core_name: "",
            request_handler: @default_handler

  alias SolrLow.Client

  @type t :: %__MODULE__{
          client: Client.t(),
          core_name: String.t(),
          request_handler: String.t()
        }

  @doc ~S"""
    Create new core based on an existing client
  """
  def new(%SolrLow.Client{} = c, core_name) do
    %__MODULE__{
      client: c,
      core_name: core_name
    }
  end

  @doc ~S"""
    Set the request handler
  """
  def request_handler(%SolrLow.Core{} = c) do
    c.request_handler
  end

  def request_handler(%SolrLow.Core{} = c, request_handler) do
    %{c | request_handler: request_handler}
  end

  def path(%SolrLow.Core{} = core) do
    core.core_name <> "/" <> core.request_handler
  end

  def url(%SolrLow.Core{} = c) do
    c.client.baseurl <> "/" <> path(c)
  end

  def get(%SolrLow.Core{} = c, params \\ []) do
    p = path(c)

    c.client
    |> Client.get(p, params)
  end

  def count(%SolrLow.Core{} = c) do
    c
    |> get(q: "*:*", rows: 0)
    |> SolrLow.Response.numFound()
  end

  # Accessor delegate functions for the client

  def client(%SolrLow.Core{} = c) do
    c.client
  end

  def baseurl(%{baseurl: burl}) do
    burl
  end
end

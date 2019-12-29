defmodule SolrLow.Client do
  @moduledoc """
  A basic solr client for talking to the solr root.
  """

  alias SolrLow.Core

  alias __MODULE__

  defstruct baseurl: nil, rootclient: nil

  @type t :: %__MODULE__{
          baseurl: String.t(),
          rootclient: SolrLow.HTTP.t()
        }

  @doc """
    Create a basic client to the root of the solr installation

    The argument is a URL pointing to the solr root of your solr
    installation. Normally, this looks like
      `http://machine.domain:8888/solr` or similar.

    A new Client is automatically populated with a SolrLow.HTTP
    for actually talking to solr.

    ## Example

       client = "http://localhost:8000/solr"
                |> SolrLow.Client.new
  """
  @spec new(String.t(), any()) :: %Client{}
  def new(url, rootclient(/ / SolrLow.HTTP.new(url))) do
    %__MODULE__{
      baseurl: url,
      rootclient: SolrLow.HTTP.new(url)
    }
  end

  @doc """
  A basic get: client, path, params_list

  A bare-bones `get` which can be used to get solr-level
  information (such as stuff under /admin). For querying
  of a core, you're better off using an actual %SolrLow.Core.
  """
  @spec get(map, String.t(), []) :: %{}
  def get(%Client{} = c, path, params \\ []) do
    r = SolrLow.HTTP.get(c.rootclient, path, query: params)

    case r do
      {:ok, resp} -> resp.body
      _ -> {:error, r.status, path, params}
    end
  end

  @doc """
    Get a list of the cores currently mounted
  """
  def cores(%Client{} = c) do
    c
    |> get("/admin/cores")
    |> Map.get("status")
    |> Map.keys()
  end

  def core(%Client{} = c, corename) do
    Core.new(c, corename)
  end

  def core(%Client{} = c, corename, handler) do
    c |> Core.new(corename) |> Core.request_handler(handler)
  end
end

defmodule SolrLow.Client do
  @moduledoc """
  A basic solr client for talking to the solr root.
  """

  alias SolrLow.Core

  alias __MODULE__

  defstruct baseurl: nil, rootclient: nil



  @type t :: %__MODULE__{
               baseurl: String.t,
               rootclient: SolrLow.HTTP.t
             }


  @doc """
    Create a basic client to the root of the solr installation
  """
  def new(url) do
    %__MODULE__{
      baseurl: url,
      rootclient: SolrLow.HTTP.new(url)
    }
  end


  # Getters
  def baseurl(%SolrLow.Client{} = c) do
    c.baseurl
  end

  def rootclient(%SolrLow.Client{} = c) do
    c.rootclient
  end


  @doc """
  A basic get: client, path, params_list
  """
  @spec get(map, String.t, []) :: %{}
  def get(%Client{} = c, path, params \\ []) do
    r = SolrLow.HTTP.get(c.rootclient, path, query: params)
    case r.status do
      200 ->
        r.body
      _ -> {:error, r.status, r}
    end
  end

  @doc """
    Get a list of the cores currently mounted
  """
  def cores(%Client{} = c) do
    c
    |> get("/admin/cores")
    |> Map.get("status")
    |> Map.keys

  end

  def core(%Client{} = c, corename) do
    Core.new(c, corename)
  end

  def core(%Client{} = c, corename, handler) do
    Core.new(c, corename, handler)
  end


end


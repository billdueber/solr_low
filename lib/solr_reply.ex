defmodule SolrLow.SolrReply do
@moduledoc """
A generic solr reply, consisting of
  * repsonseHeader (status, qtime, parameters)
  * response (docs, numberFound (nee size), and starting record)
"""
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_one :responseHeader, SolrLow.SolrReply.ResponseHeader
    embeds_one :response, SolrLow.SolrReply.Response
    field :docs, {:array, :map}, virtual: true
    field :status, :integer, virtual: true
    field :num_found, :integer, virtual: true
    field :numFound, :integer, virtual: true
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [])
  end

  def from_json(data) when is_binary(data) do
    Poison.decode!(data) |> from_map
  end

  def from_map(data) when is_map(data) do
    sr = %__MODULE__{}
          |> cast(data, [])
          |> cast_embed(:response)
          |> cast_embed(:responseHeader)
          |> apply_changes

    # Add in the virual fields as aliases
    sr
      |> Map.put(:docs, sr.response.docs)
      |> Map.put(:status, sr.responseHeader.status)
      |> Map.put(:numFound, sr.response.numFound)
      |> Map.put(:num_found, sr.response.numFound)

  end
end

defmodule SolrLow.SolrReply.ResponseHeader do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "responseHeader" do
    field :status, :integer
    field :QTime,  :float
    field :qtime, :float, virtual: true
    field :params, :map
  end

  def changeset(struct, data) do
    struct
    |> cast(data, [:status, :QTime, :params])
   end

 end



defmodule SolrLow.SolrReply.Response do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "response" do
    field :numFound, :integer
    field :start, :integer
    field :docs, {:array, :map}

    def changeset(struct, data) do
      struct
      |> cast(data, [:numFound, :start, :docs ])
    end
  end

end



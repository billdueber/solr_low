defmodule SolrLow.SolrResponse do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_one :responseHeader, SolrLow.SolrResponse.ResponseHeader
    field :response, :map
  end

  def from_json(data) when is_binary(data) do
    Poison.decode!(data) |> from_json
  end

  def from_json(data) when is_map(data) do
    y = %__MODULE__{}
    |> cast(data, [:response])
    |> cast_embed(:responseHeader)
    |> apply_changes

     %{y | :responseHeader => %{y.responseHeader | qtime: Map.get(y.responseHeader, :QTime)}}
  end
end

defmodule SolrLow.SolrResponse.ResponseHeader do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :status, :integer
    field :QTime,  :float
    field :qtime, :float, virtual: true
    field :params, :map

    def aliasQTime(struct) do
      struct
      |> Map.put(:qtime, struct[:QTime])
    end

    def changeset(struct, data) do
      struct
      |> cast(data, [:status, :QTime, :params])
    end

  end
end

defmodule SolrLow.SolrResponse.ResponseHeader do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
   

end

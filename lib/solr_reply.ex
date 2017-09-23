defmodule SolrLow.SolrReply do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    embeds_one :responseHeader, SolrLow.SolrReply.ResponseHeader
    field :response, :map

  end

  def from_json(data) when is_binary(data) do
    Poison.decode!(data) |> from_map
  end

  def from_map(data) when is_map(data) do
    y = %__MODULE__{}
    |> cast(data, [:response])
    |> cast_embed(:responseHeader)
    |> apply_changes

     %{y | :responseHeader => %{y.responseHeader | qtime: Map.get(y.responseHeader, :QTime)}}
  end
end

defmodule SolrLow.SolrReply.ResponseHeader do
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

  defmodule SolrLow.SolrReply.Response do
    use Ecto.Schema
    import Ecto.Changeset

    @primary_key false
    embedded_schema do
      field :numFound, :integer
      field :count,  :float, virtual: true
      field :docs, {:array, :map}
      field :start, :integer

      def changeset(struct, data) do
        struct
        |> cast(data, [:numFound, :docs, :start])
      end
    end

  end
end


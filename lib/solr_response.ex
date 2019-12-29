defmodule SolrLow.Response do
  @moduledoc """
  A generic solr reply, consisting of
    * repsonseHeader (status, qtime, parameters)
    * response (docs, numberFound (nee size), and starting record)

  Try to do it just by abusing pattern matching on teh raw hash
  """

  @doc ~S"""
    Given a string that is a solr reply represented as json,
    turn it into a SolrResponse map
  """
  def from_json(data) when is_binary(data) do
    case Poison.decode(data) do
      {:ok, h} -> h
      x -> x
    end
  end

  def documents(%{"response" => %{"docs" => d}}) do
    d
  end

  def numFound(%{"response" => %{"numFound" => n}}) do
    n
  end
end

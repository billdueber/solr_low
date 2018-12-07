alias SolrLow.Core
alias SolrLow.Client

defmodule SolrClientCoreTest do
  use ExUnit.Case, async: true
  doctest SolrLow.Client

  @url "http://localhost:8983/solr"

  test "creates a client" do
    client = @url
             |> Client.new
    assert client.baseurl == @url
  end

  test "create core from client" do
    client = @url |> Client.new
    core = client |> Client.core("testcore")
    assert core.client.baseurl == @url
  end

  test "create core from url" do
    core = @url |> Core.new("testcore")
    assert core |> Core.baseurl == @url
  end

  test "builds a core URL correctly" do
    core = @url |> Core.new("testcore")
    assert core |> Core.url == @url <> "/testcore"
  end
end

alias SolrLow.Response, as: R

defmodule SolrResponseTest do
  use ExUnit.Case, async: true
  doctest SolrLow.Response

  setup_all do
    fout = File.read("./test/sample_solr_reply.json")
    {:ok, rawjson} = fout
    {:ok, rawmap} = Poison.decode(rawjson)
    [
      rawjson: rawjson,
      rawmap: rawmap,
      resp: R.from_json(rawjson)
    ]
  end


  test "can parse the json", context do
    assert context[:resp] == context[:rawmap]
  end

  test "can get the docs", context do
    assert context[:resp]
           |> R.documents
           |> Enum.count == 2
  end

  test "gets docs in order", context do
    first = context[:resp]
            |> R.documents
            |> List.first
    assert first["id"] == "1"
  end

  test "gets the count", context do
    assert R.numFound(context[:resp]) == 2
  end
end

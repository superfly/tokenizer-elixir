defmodule Tokenizer.MacaroonTest do
  use ExUnit.Case

  test "new" do
    <<"FlyV1 fm2", _::binary>> = Tokenizer.Macaroon.new("foo")
  end

  test "custom caveats implement Macfly.Caveat" do
    caveats = [
      {Tokenizer.Macaroon.RequestMethod.new("GET"), "RequestMethod", 0x1000000000000, "GET"},
      {Tokenizer.Macaroon.RequestPath.new("/v1/tokens"), "RequestPath", 0x1000000000001,
       "/v1/tokens"},
      {Tokenizer.Macaroon.RequestPathPrefix.new("/v1"), "RequestPathPrefix", 0x1000000000002,
       "/v1"},
      {Tokenizer.Macaroon.RequestPathPattern.new("/v1/*"), "RequestPathPattern", 0x1000000000003,
       "/v1/*"},
      {Tokenizer.Macaroon.RequestHost.new("api.example.com"), "RequestHost", 0x1000000000004,
       "api.example.com"}
    ]

    options = %Macfly.Options{}

    for {caveat, name, type, body} <- caveats do
      assert Macfly.Caveat.name(caveat) == name
      assert Macfly.Caveat.type(caveat) == type
      assert Macfly.Caveat.body(caveat) == body
      assert {:ok, ^caveat} = Macfly.Caveat.from_body(caveat, body, options)
    end
  end
end

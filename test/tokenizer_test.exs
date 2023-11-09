defmodule TokenizerTest do
  use ExUnit.Case

  test "integration" do
    HTTPoison.start()
    # :hackney_trace.enable(:max, :io)

    processor = %Tokenizer.InjectProcessor{token: "foo"}
    auth = %Tokenizer.MacaroonAuth{key: Base.encode64("mykey")}
    secret = Tokenizer.Secret.new(processor, auth)

    seal_key =
      Base.decode16!(
        String.upcase("1ec9a2de9b34785519075504b350ece4aae53a9644b1cb6b4893d858b93c8e6c")
      )

    {:ok, sealed} = Tokenizer.seal(secret, seal_key)
    hdr = Tokenizer.Macaroon.new("mykey")

    headers = [
      "Proxy-Tokenizer": sealed,
      "Proxy-Authorization": hdr
    ]

    options = [
      proxy: {:connect, "btoews-tokenizer.fly.dev", 80},
      # proxy_auth: {"", hdr},
      timeout: 10000
    ]

    {:ok, %{status_code: 200, body: jsonBody}} =
      HTTPoison.get("http://httpbin.org/get", headers, options)

    {:ok, %{"headers" => %{"Authorization" => "Bearer foo"}}} = Jason.decode(jsonBody)
  end

  test "seal" do
    s =
      Tokenizer.Secret.new(%Tokenizer.InjectProcessor{token: "foo"}, %Tokenizer.BearerAuth{
        digest: "bar"
      })

    assert {:ok, sealed} = Tokenizer.seal(s, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

    assert byte_size(sealed) ==
             byte_size(Base.encode64(String.duplicate("A", byte_size(Jason.encode!(s)) + 48)))
  end

  test "encode" do
    assert "{}" == Jason.encode!(%Tokenizer.Secret{})
    assert "{}" == Jason.encode!(%Tokenizer.InjectProcessor{})
    assert "{}" == Jason.encode!(%Tokenizer.InjectHMACProcessor{})
    assert "{}" == Jason.encode!(%Tokenizer.BearerAuth{})
    assert "{}" == Jason.encode!(%Tokenizer.MacaroonAuth{})
  end
end

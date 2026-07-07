defmodule TokenizerTest do
  use ExUnit.Case

  @tag :integration
  test "integration" do
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
      connect_options: [proxy: {:http, "btoews-tokenizer.fly.dev", 80, []}],
      decode_body: false,
      receive_timeout: 10_000
    ]

    {:ok, %{status: 200, body: json_body}} =
      Req.get("http://httpbin.org/get", Keyword.merge(options, headers: headers))

    {:ok, %{"headers" => %{"Authorization" => "Bearer foo"}}} = Tokenizer.JSON.decode(json_body)
  end

  test "seal" do
    s =
      Tokenizer.Secret.new(%Tokenizer.InjectProcessor{token: "foo"}, %Tokenizer.BearerAuth{
        digest: "bar"
      })

    assert {:ok, sealed} = Tokenizer.seal(s, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")

    assert byte_size(sealed) ==
             byte_size(
               Base.encode64(String.duplicate("A", byte_size(Tokenizer.JSON.encode!(s)) + 48))
             )
  end

  test "seal round-trips with Salty" do
    {:ok, public_key, secret_key} = Salty.Box.Curve25519xsalsa20poly1305.keypair()

    secret =
      Tokenizer.Secret.new(%Tokenizer.InjectProcessor{token: "foo"}, %Tokenizer.BearerAuth{
        digest: "bar"
      })

    assert {:ok, sealed} = Tokenizer.seal(secret, public_key)
    assert {:ok, encrypted} = Base.decode64(sealed)

    assert {:ok, json} =
             Salty.Box.Curve25519xsalsa20poly1305.seal_open(encrypted, public_key, secret_key)

    assert Tokenizer.JSON.decode!(json) == %{
             "bearer_auth" => %{"digest" => "bar"},
             "inject_processor" => %{"token" => "foo"}
           }
  end

  test "JSON payload shape omits nil fields and preserves populated fields" do
    secret =
      Tokenizer.Secret.new(
        %Tokenizer.InjectProcessor{token: "foo", dst: "Authorization"},
        %Tokenizer.BearerAuth{digest: "bar"},
        allowed_hosts: ["example.com"]
      )

    assert Tokenizer.JSON.decode!(Tokenizer.JSON.encode!(secret)) == %{
             "allowed_hosts" => ["example.com"],
             "bearer_auth" => %{"digest" => "bar"},
             "inject_processor" => %{"dst" => "Authorization", "token" => "foo"}
           }
  end

  test "encode" do
    assert "{}" == JSON.encode!(%Tokenizer.Secret{})
    assert "{}" == JSON.encode!(%Tokenizer.InjectProcessor{})
    assert "{}" == JSON.encode!(%Tokenizer.InjectHMACProcessor{})
    assert "{}" == JSON.encode!(%Tokenizer.BearerAuth{})
    assert "{}" == JSON.encode!(%Tokenizer.MacaroonAuth{})
  end
end

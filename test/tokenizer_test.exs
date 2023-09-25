defmodule TokenizerTest do
  use ExUnit.Case

  test "seal" do
    s = Tokenizer.Secret.new(%Tokenizer.InjectProcessor{token: "foo"}, %Tokenizer.BearerAuth{digest: "bar"})
    assert {:ok, sealed} = Tokenizer.seal(s, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    assert byte_size(sealed) == byte_size(Base.encode64(String.duplicate("A", byte_size(Jason.encode!(s)) + 48)))
  end

  test "encode" do
    assert "{}" == Jason.encode!(%Tokenizer.Secret{})
    assert "{}" == Jason.encode!(%Tokenizer.InjectProcessor{})
    assert "{}" == Jason.encode!(%Tokenizer.InjectHMACProcessor{})
    assert "{}" == Jason.encode!(%Tokenizer.BearerAuth{})
    assert "{}" == Jason.encode!(%Tokenizer.MacaroonAuth{})
  end
end

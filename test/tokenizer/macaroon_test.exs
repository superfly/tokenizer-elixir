defmodule Tokenizer.MacaroonTest do
  use ExUnit.Case

  test "new" do
    {:ok, <<"FlyV1 fm2", _::binary>>} = Tokenizer.Macaroon.new("foo")
  end
end

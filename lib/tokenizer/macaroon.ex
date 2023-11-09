defmodule Tokenizer.Macaroon do
  @location "tokenizer"

  def new(key, caveats \\ []) do
    Macfly.Macaroon.new(key, key_fingerprint(key), @location, caveats)
    |> then(&[&1])
    |> Macfly.encode()
  end

  def key_fingerprint(key) do
    <<prefix::binary-size(16), _rest::binary>> = :crypto.hash(:sha256, key)
    prefix
  end

  defmodule RequestMethod do
    defstruct [:allowed]

    def new(allowed), do: %__MODULE__{allowed: allowed}

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000000
      def body(v), do: v.allowed
      def from_body(_, allowed, _), do: {:ok, %RequestMethod{allowed: allowed}}
    end
  end

  defmodule RequestPath do
    defstruct [:allowed]

    def new(allowed), do: %__MODULE__{allowed: allowed}

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000001
      def body(v), do: v.allowed
      def from_body(_, allowed, _), do: {:ok, %RequestPath{allowed: allowed}}
    end
  end

  defmodule RequestPathPrefix do
    defstruct [:allowed]

    def new(allowed), do: %__MODULE__{allowed: allowed}

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000002
      def body(v), do: v.allowed
      def from_body(_, allowed, _), do: {:ok, %RequestPathPrefix{allowed: allowed}}
    end
  end

  defmodule RequestPathPattern do
    defstruct [:allowed]

    def new(allowed), do: %__MODULE__{allowed: allowed}

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000003
      def body(v), do: v.allowed
      def from_body(_, allowed, _), do: {:ok, %RequestPathPattern{allowed: allowed}}
    end
  end

  defmodule RequestHost do
    defstruct [:allowed]

    def new(allowed), do: %__MODULE__{allowed: allowed}

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000004
      def body(v), do: v.allowed
      def from_body(_, allowed, _), do: {:ok, %RequestHost{allowed: allowed}}
    end
  end
end

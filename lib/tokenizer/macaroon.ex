defmodule Tokenizer.Macaroon do
  @location "tokenizer"

  def new(key, caveats \\ []), do: Macfly.new(key, key_fingerprint(key), @location, caveats)

  def key_fingerprint(key) do
    <<prefix::binary-size(16), _rest::binary>> = :crypto.hash(:sha256, key)
    prefix
  end

  defmodule RequestMethod do
    defstruct [:allowed]

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000000
      def body(v), do: v.allowed
    end
  end

  def restrict_request_method(allowed), do: %RequestMethod{allowed: allowed}

  def restrict_request_method(header, allowed),
    do: Macfly.attenuate(@location, header, [%RequestMethod{allowed: allowed}])

  defmodule RequestPath do
    defstruct [:allowed]

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000001
      def body(v), do: v.allowed
    end
  end

  def restrict_request_path(allowed), do: %RequestPath{allowed: allowed}

  def restrict_request_path(header, allowed),
    do: Macfly.attenuate(@location, header, [%RequestPath{allowed: allowed}])

  defmodule RequestPathPrefix do
    defstruct [:allowed]

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000002
      def body(v), do: v.allowed
    end
  end

  def restrict_request_path_prefix(allowed), do: %RequestPathPrefix{allowed: allowed}

  def restrict_request_path_prefix(header, allowed),
    do: Macfly.attenuate(@location, header, [%RequestPathPrefix{allowed: allowed}])

  defmodule RequestPathPattern do
    defstruct [:allowed]

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000003
      def body(v), do: v.allowed
    end
  end

  defmodule RequestHost do
    defstruct [:allowed]

    defimpl Macfly.Caveat do
      def type(_), do: 0x1000000000004
      def body(v), do: v.allowed
    end
  end

  def restrict_request_host(allowed), do: %RequestHost{allowed: allowed}

  def restrict_request_host(header, allowed),
    do: Macfly.attenuate(@location, header, [%RequestHost{allowed: allowed}])
end

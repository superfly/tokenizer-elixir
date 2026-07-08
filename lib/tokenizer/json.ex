defmodule Tokenizer.JSON do
  @moduledoc false

  @spec encode(term()) :: {:ok, String.t()} | {:error, Exception.t()}
  def encode(value) do
    {:ok, JSON.encode!(value)}
  rescue
    exception -> {:error, exception}
  end

  @spec encode!(term()) :: String.t()
  def encode!(value), do: JSON.encode!(value)

  @spec decode(String.t()) :: {:ok, term()} | {:error, Exception.t()}
  def decode(value), do: JSON.decode(value)

  @spec decode!(String.t()) :: term()
  def decode!(value), do: JSON.decode!(value)

  @spec to_map(struct()) :: map()
  def to_map(struct) do
    struct
    |> Map.from_struct()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end
end

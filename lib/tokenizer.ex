defmodule Tokenizer do
  defmodule InjectProcessor do
    defstruct [:token, fmt: nil, allowed_fmt: nil, dst: nil, allowed_dst: nil]
  end

  defmodule InjectHMACProcessor do
    defstruct [:key, hash: nil, fmt: nil, allowed_fmt: nil, dst: nil, allowed_dst: nil]
  end

  defmodule BearerAuth do
    defstruct [:digest]
  end

  defmodule MacaroonAuth do
    defstruct [:key]
  end

  defmodule Secret do
    defstruct inject_processor: nil,
              inject_hmac_processor: nil,
              bearer_auth: nil,
              macaroon_auth: nil

    def new(processor, auth) do
      %Secret{}
      |> merge_processor(processor)
      |> merge_auth(auth)
    end

    defp merge_processor(%Secret{} = s, %InjectProcessor{} = processor),
      do: %Secret{s | inject_processor: processor}

    defp merge_processor(%Secret{} = s, %InjectHMACProcessor{} = processor),
      do: %Secret{s | inject_hmac_processor: processor}

    defp merge_auth(%Secret{} = s, %BearerAuth{} = auth), do: %Secret{s | bearer_auth: auth}
    defp merge_auth(%Secret{} = s, %MacaroonAuth{} = auth), do: %Secret{s | macaroon_auth: auth}
  end

  def seal(%Tokenizer.Secret{} = s, key) do
    with {:ok, json} <- Jason.encode(s),
         {:ok, sealed} <- Tokenizer.Nif.seal(json, key) do
      {:ok, Base.encode64(sealed)}
    else
      error -> error
    end
  end

  defimpl Jason.Encoder,
    for: [InjectProcessor, InjectHMACProcessor, BearerAuth, MacaroonAuth, Secret] do
    def encode(struct, opts) do
      struct
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Jason.Encode.map(opts)
    end
  end
end

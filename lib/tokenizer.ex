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

  defmodule FlysrcAuth do
    defstruct [:allowed_orgs, :allowed_apps, :allowed_instances]
  end

  defmodule Secret do
    defstruct inject_processor: nil,
              inject_hmac_processor: nil,
              bearer_auth: nil,
              macaroon_auth: nil,
              fly_src_auth: nil,
              allowed_hosts: nil,
              allowed_host_pattern: nil

    def new(processor, auth, opts \\ []) do
      %Secret{
        allowed_hosts: Keyword.get(opts, :allowed_hosts),
        allowed_host_pattern: Keyword.get(opts, :allowed_host_pattern)
      }
      |> merge_processor(processor)
      |> merge_auth(auth)
    end

    defp merge_processor(%Secret{} = s, %InjectProcessor{} = processor),
      do: %Secret{s | inject_processor: processor}

    defp merge_processor(%Secret{} = s, %InjectHMACProcessor{} = processor),
      do: %Secret{s | inject_hmac_processor: processor}

    defp merge_auth(%Secret{} = s, %BearerAuth{} = auth), do: %Secret{s | bearer_auth: auth}
    defp merge_auth(%Secret{} = s, %MacaroonAuth{} = auth), do: %Secret{s | macaroon_auth: auth}
    defp merge_auth(%Secret{} = s, %FlysrcAuth{} = auth), do: %Secret{s | fly_src_auth: auth}
  end

  @spec seal(%Tokenizer.Secret{}, iodata()) :: {:ok, String.t()} | {:error, any()}
  def seal(%Tokenizer.Secret{} = s, key) do
    with {:ok, json} <- Jason.encode(s) do
      {:ok, Base.encode64(:libsodium_crypto_box.seal(json, key))}
    end
  end

  defimpl Jason.Encoder,
    for: [InjectProcessor, InjectHMACProcessor, BearerAuth, MacaroonAuth, FlysrcAuth, Secret] do
    def encode(struct, opts) do
      struct
      |> Map.from_struct()
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
      |> Jason.Encode.map(opts)
    end
  end
end

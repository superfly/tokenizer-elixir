defmodule Tokenizer.Nif do
  @compile {:autoload, false}
  @on_load {:init, 0}

  def init do
    path = :filename.join(:code.priv_dir(:tokenizer), ~c"tokenizer_nif")
    :erlang.load_nif(path, 0)
  end

  def seal(_msg, _seal_key), do: :erlang.exit(:tokernizer_nif_not_loaded)
end

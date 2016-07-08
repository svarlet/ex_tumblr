defmodule ExTumblr.Utils.Parsing do
  def to_struct(nil, module) do
    struct module
  end

  def to_struct(data, module) do
    atomized_kvs =
      data
      |> Enum.map(&atomize_tuple/1)
      |> Enum.filter_map(&match?({:ok, _}, &1), fn {_, kv} -> kv end)

    struct module, atomized_kvs
  end

  defp atomize_tuple({k, v}) when is_binary(k) do
    try do
      {:ok, {String.to_existing_atom(k), v}}
    rescue
      ArgumentError -> {:error, :unregistered_atom}
    end
  end
end

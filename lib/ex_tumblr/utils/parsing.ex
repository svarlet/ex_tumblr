defmodule ExTumblr.Utils.Parsing do
  @doc """
  Convert a map to a struct.

  It expects the keys of the map to be strings. When the key does not
  already exist as an atom, it is dropped. The reason behind this choice is
  because the JSON responses may contain private or deprecated keys. They
  would have to be transformed to atoms. Since they are not under our control
  and because the number of created atoms should be controlled, we consider
  that a string key which does not already have its matching atom is
  irrelevant.
  """
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

  @doc """
  Same as to_struct/2 but enable the developer to specify custom key-value
  transformers.

  This is useful when the original map has a key mapped to a map or to a list
  of map which should be parsed to specific types.
  """
  def to_struct(data, module, transformers) when transformers in [[], nil] do
    to_struct(data, module)
  end

  def to_struct(data, module, [{key, transformer} | rest]) do
    key_as_string = to_string(key)
    updated_data = %{data | key_as_string => transformer.(data[key_as_string])}
    to_struct(updated_data, module, rest)
  end

  defp atomize_tuple({k, v}) when is_binary(k) do
    try do
      {:ok, {String.to_existing_atom(k), v}}
    rescue
      ArgumentError -> {:error, :unregistered_atom}
    end
  end
end

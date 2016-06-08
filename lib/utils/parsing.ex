defmodule ExTumblr.Utils.Parsing do
  @doc """
  Transforms a `%{String.t => any}` type of map into a specific struct.

  Keys of the map should be binaries and will be converted to atoms.

  Sometimes the map to parse will contain unexpected keys. This
  often happens for the sake of backward compatibility when one key
  value pair is being deprecated. Therefore, a list of accepted keys
  must be provided to avoid errors while constructing the desired
  struct.
  """
  @spec to_struct(%{String.t => any}, module, [String.t]) :: struct
  def to_struct(nil, module, _) do
    struct(module)
  end

  def to_struct(data, module, accepted_keys) when is_map(data) do
    data
    |> Map.take(accepted_keys)
    |> Enum.reduce(struct(module), fn ({k, v}, acc) -> %{acc | String.to_atom(k) => v} end)
  end
end

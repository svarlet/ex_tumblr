defmodule ExTumblr.Utils.MapExtras do
  @moduledoc """
  Functions to manipulate maps, strings, ...
  """

  @doc """
  Returns the value associated to a `key` in a map.

  ## Examples

  iex> ExTumblr.Utils.MapExtras.property(%{a: 1, b: 2}, :b)
  {:ok, 2}

  iex> ExTumblr.Utils.MapExtras.property(%{id: 32, user: %{firstname: "Sébastien", lastname: "Varlet"}}, :user)
  {:ok, %{firstname: "Sébastien", lastname: "Varlet"}}

  iex> ExTumblr.Utils.MapExtras.property(nil, :key)
  {:error, "The map is nil."}

  iex> ExTumblr.Utils.MapExtras.property(%{}, :firstname)
  {:error, "The firstname key does not exist."}

  """
  @spec property(map, atom) :: {:ok, any} | {:error, String.t}
  def property(nil, _) do
    {:error, "The map is nil."}
  end

  def property(map, key) do
    case Map.fetch map, key do
      {:ok, value} -> {:ok, value}
      :error -> {:error, "The #{key} key does not exist."}
    end
  end
end

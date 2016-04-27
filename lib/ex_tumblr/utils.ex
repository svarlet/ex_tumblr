defmodule ExTumblr.Utils do
  def property(nil, _) do
    {:error, "The map is nil."}
  end

  def property(map, property) do
    case Map.fetch map, property do
      {:ok, value} -> {:ok, value}
      :error -> {:error, "The #{property} key does not exist."}
    end
  end
end

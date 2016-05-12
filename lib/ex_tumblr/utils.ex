defmodule ExTumblr.Utils do
  def property(nil, _) do
    {:error, "The map is nil."}
  end

  def property(map, name) do
    case Map.fetch map, name do
      {:ok, value} -> {:ok, value}
      :error -> {:error, "The #{name} key does not exist."}
    end
  end
end

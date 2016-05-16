defmodule ExTumblr.Utils.URIExtras do
  def build_path(path_elements) when path_elements in [[], nil] do
    ""
  end

  def build_path(path_elements) do
    path_elements
    |> Enum.reduce("", fn elem, acc -> "#{acc}/#{elem}" end)
  end
end

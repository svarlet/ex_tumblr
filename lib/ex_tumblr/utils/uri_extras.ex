defmodule ExTumblr.Utils.URIExtras do
  @moduledoc """
  This module provides extra functions to manipulate URIs.
  """

  @doc """
  Builds the path of a URL from a list of path elements.

  This function prefixes each path element with a slash character and concatenates
  them. If the list of path elements is nil or empty, an empty string is returned.

  ## Examples

      iex> ExTumblr.Utils.URIExtras.build_path(~w(this is a path))
      "/this/is/a/path"

      iex> ExTumblr.Utils.URIExtras.build_path(["home"])
      "/home"

  """
  @spec build_path([String.t]) :: String.t
  def build_path(path_elements) when path_elements in [[], nil] do
    ""
  end

  def build_path(path_elements) do
    path_elements
    |> Enum.reduce("", fn elem, acc -> "#{acc}/#{elem}" end)
  end
end

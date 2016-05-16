defmodule ExTumblr.Utils.StringExtras do
  @moduledoc """
  This module provides extra functions to manipulate strings.
  """

  @doc ~S"""
  Checks if a string contains any non-whitespace character and
  if its length is strictly positive.

  ## Examples

      iex> ExTumblr.Utils.StringExtras.blank? ""
      true

      iex> ExTumblr.Utils.StringExtras.blank? " "
      true

      iex> ExTumblr.Utils.StringExtras.blank? "  a"
      false

      iex> ExTumblr.Utils.StringExtras.blank? " \t \r\n"
      true

      iex> ExTumblr.Utils.StringExtras.blank? "a\t"
      false

  """
  @spec blank?(String.t) :: boolean
  def blank?(string), do: Regex.match? ~r/^\s*$/, string
end

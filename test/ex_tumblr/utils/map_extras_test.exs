defmodule ExTumblr.Utils.MapExtrasTest do
  use ExUnit.Case, async: true
  doctest ExTumblr.Utils.MapExtras

  import ExTumblr.Utils.MapExtras, only: [property: 2]

  test "Reading a property from a nil map returns an error" do
    assert {:error, _} = property(nil, :property)
  end

  test "Reading a property from an empty map returns an error" do
    assert {:error, message} = property(%{}, :property)
    assert message == "The property key does not exist."
  end

  test "Reading an existing property from a map returns its value" do
    assert {:ok, 234} == property(%{property: 234}, :property)
  end
end

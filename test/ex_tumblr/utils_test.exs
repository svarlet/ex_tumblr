defmodule ExTumblr.UtilsTest do
  use ExUnit.Case, async: true
  doctest ExTumblr.Utils
  import ExTumblr.Utils

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

  test "A string containing only whitespace characters is blank" do
    assert blank?("") == true
    assert blank?(" ") == true
    assert blank?("\t") == true
    assert blank?("\r") == true
    assert blank?("\r\n") == true
    assert blank?("\ ") == true
    assert blank?("\n") == true
    assert blank?("    ") == true
  end

  test "A string containing one non whitespace character is not blank" do
    assert blank?("a") == false
    assert blank?(" a ") == false
    assert blank?(" a") == false
    assert blank?("a ") == false
    assert blank?("1") == false
    assert blank?(" 1") == false
    assert blank?("1 ") == false
    assert blank?(" 1 ") == false
  end
end

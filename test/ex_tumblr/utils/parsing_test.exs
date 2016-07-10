defmodule ExTumblr.Utils.ParsingTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Utils.Parsing

  defmodule DummyUser do
    defstruct firstname: "Robert", lastname: "de Niro"
  end

  #
  # to_struct/2
  #

  test "to_struct/2 returns a default struct when input is nil" do
    assert %DummyUser{} == Parsing.to_struct(nil, DummyUser)
  end

  test "to_struct/2 returns a default struct when input is an empty map" do
    assert %DummyUser{} == Parsing.to_struct(%{}, DummyUser)
  end

  test "to_struct/2 does not break because of unexpected keys" do
    input = %{"unexpected_key" => "value", "firstname" => "Tom", "lastname" => "Hanks"}
    assert %DummyUser{firstname: "Tom", lastname: "Hanks"} == Parsing.to_struct(input, DummyUser)
  end

  test "to_struct/2 returns a default struct when input is only made of irrelevant keys" do
    input = %{"irrelevant_key" => "value", "another_irrelevant_key" => "value"}
    assert %DummyUser{} == Parsing.to_struct(input, DummyUser)
  end

  #
  # to_struct/3
  #

  test "to_struct/3 can convert a map to a struct even with a nil list of converters" do
    flunk "todo"
  end

  test "to_struct/3 can convert a map to a struct even with an empty list of converters" do
    flunk "todo"
  end

  test "to_struct/3 does not run a converter if the associated key does not exist" do
    flunk "todo"
  end

  test "to_struct/3 run all provided converters" do
    flunk "todo"
  end
end

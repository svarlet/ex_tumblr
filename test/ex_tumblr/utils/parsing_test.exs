defmodule ExTumblr.Utils.ParsingTest do
  use ShouldI, async: true

  alias ExTumblr.Utils.Parsing

  defmodule DummyUser do
    @moduledoc false
    defstruct firstname: "Robert", lastname: "de Niro"
  end

  should "return a default struct when input is nil" do
    assert %DummyUser{} == Parsing.to_struct(nil, DummyUser, ~w(firstname lastname))
  end

  should "return a default struct when input is an empty map" do
    assert %DummyUser{} == Parsing.to_struct(%{}, DummyUser, ~w(firstname lastname))
  end

  should "only set the accepted keys" do
    input = %{"firstname" => "Clark", "lastname" => "Kent"}
    assert %DummyUser{firstname: "Clark", lastname: "de Niro"} == Parsing.to_struct(input, DummyUser, ~w(firstname))
  end

  should "not break because of unexpected keys" do
    input = %{"unexpected_key" => "value", "firstname" => "Tom", "lastname" => "Hanks"}
    assert %DummyUser{firstname: "Tom", lastname: "Hanks"} == Parsing.to_struct(input, DummyUser, ~w(firstname lastname))
  end

  should "return a default struct when input is only made of irrelevant keys" do
    input = %{"irrelevant_key" => "value", "another_irrelevant_key" => "value"}
    assert %DummyUser{} == Parsing.to_struct(input, DummyUser, ~w(firstname lastname))
  end
end

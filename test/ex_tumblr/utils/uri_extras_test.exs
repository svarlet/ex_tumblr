defmodule ExTumblr.Utils.URIExtrasTest do
  use ExUnit.Case, async: true

  import ExTumblr.Utils.URIExtras, only: [build_path: 1]

  test "Given a nil list of element path, build_path/1 returns an empty string" do
    assert "" == build_path(nil)
  end

  test "Given an empty list of element path, build_path/1 returns an empty sting" do
    assert "" == build_path([])
  end

  test "Given a list with a single element path, build_path/1 returns the path prefixed with a slash" do
    assert "/a_word" == build_path(["a_word"])
  end

  test "Given a list with 2 path elements, build_path/1 prefixes them with a slash and concatenates them" do
    assert "/a/word" == build_path(~w(a word))
  end
end

defmodule ExTumblr.Utils.StringExtrasTest do
  use ExUnit.Case, async: true
  doctest ExTumblr.Utils.StringExtras
  import ExTumblr.Utils.StringExtras, only: [blank?: 1]

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

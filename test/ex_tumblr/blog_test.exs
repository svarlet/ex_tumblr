defmodule ExTumblr.BlogTest do
  use ExUnit.Case
  alias ExTumblr.Blog

  doctest ExTumblr.Blog

  test "Given an invalid blog identifier Then build_request/2 returns an error" do
    assert {:error, reason} = Blog.build_request(nil, "api-key")
    assert reason == "Nil is not a valid blog identifier."
  end

  test "Given an invalid api key Then build_request/2 returns an error" do
    assert {:error, reason} = Blog.build_request("fake-blog-id", nil)
    assert reason == "Nil is not a valid api key."
  end
end

defmodule ExTumblr.BlogTest do
  use ExUnit.Case
  alias ExTumblr.Blog

  doctest ExTumblr.Blog

  test "Given a nil blog identifier Then build_request/2 returns an error" do
    assert_failure_with nil, "api-key", "Nil is not a valid blog identifier."
  end

  defp assert_failure_with(blog_identifier, api_key, expected_reason) do
    assert {:error, reason} = Blog.build_request blog_identifier, api_key
    assert reason == expected_reason
  end

  test "Given a blank blog identifier Then build_request/2 returns an error" do
    assert_failure_with "", "api-key", "A blog identifier cannot be blank."
    assert_failure_with " \t  \r", "api-key", "A blog identifier cannot be blank."
  end

  test "Given a nil api key Then build_request/2 returns an error" do
    assert_failure_with "fake-blog-id", nil, "Nil is not a valid api key."
  end
end

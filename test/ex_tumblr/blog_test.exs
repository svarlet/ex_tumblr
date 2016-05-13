defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true
  alias ExTumblr.Blog

  defp should_fail(fun, expected_reason) do
    assert {:error, ^expected_reason} = fun.()
  end

  test "A nil blog identifier returns an error" do
    should_fail fn -> Blog.info nil, "api-key" end, "Nil is not a valid blog identifier."
  end

  test "A blank blog identifier returns an error" do
    should_fail fn -> Blog.info "", "api-key" end, "A blog identifier cannot be blank."
    should_fail fn -> Blog.info " \t  \r", "api-key" end, "A blog identifier cannot be blank."
  end

  test "A blank api key returns an error" do
    should_fail fn -> Blog.info "blog_identifier", "" end, "An api key cannot be blank."
    should_fail fn -> Blog.info "blog_identifier", " \t \r" end, "An api key cannot be blank."
  end

  test "A nil api key returns an error" do
    should_fail fn -> Blog.info "fake-blog-id", nil end, "Nil is not a valid api key."
  end

  test "send_request/2 sends the specified request through the specified http client" do
    http_get_client = fn url -> send self(), {:request_sent, url} end
    Blog.send_request "dummy url", http_get_client
    assert_received {:request_sent, "dummy url"}
  end

  test "An avatar request should fail if the blog_identifier is invalid" do
    should_fail fn -> Blog.avatar(nil) end, "Nil is not a valid blog identifier."
    should_fail fn -> Blog.avatar(" ") end, "A blog identifier cannot be blank."
  end
end

defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true
  alias ExTumblr.Blog

  test "send_request/2 sends the specified request through the specified http client" do
    http_get_client = fn url -> send self(), {:request_sent, url} end
    Blog.send_request "dummy url", http_get_client
    assert_received {:request_sent, "dummy url"}
  end

  test "avatar/2 support only specific sizes" do
    unsupported_size = 49384039
    assert_raise FunctionClauseError, fn -> Blog.avatar("gunkatana.tumblr.com", unsupported_size) end
  end

  test "Given a nil list of element path, build_path/1 returns an empty string" do
    assert "" == Blog.build_path(nil)
  end

  test "Given an empty list of element path, build_path/1 returns an empty sting" do
    assert "" == Blog.build_path([])
  end

  test "Given a list with a single element path, build_path/1 returns the path prefixed with a slash" do
    assert "/a_word" == Blog.build_path(["a_word"])
  end

  test "Given a list with 2 path elements, build_path/1 prefixes them with a slash and concatenates them" do
    flunk "todo!"
  end
end

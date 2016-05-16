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
end

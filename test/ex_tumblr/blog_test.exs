defmodule ExTumblr.BlogTest do
  use ExUnit.Case, async: true
  alias ExTumblr.Blog

  test "send_request/2 sends the specified request through the specified http client" do
    http_get_client = fn url -> send self(), {:request_sent, url} end
    Blog.send_request "dummy url", http_get_client
    assert_received {:request_sent, "dummy url"}
  end
end

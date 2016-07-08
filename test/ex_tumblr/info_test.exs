defmodule ExTumblr.InfoTest do
  use ExTumblr.BypassSetupTemplate, async: true

  alias ExTumblr.{Credentials, Info}

  @prebaked_response """
  {
    "meta": {
      "status": 200,
      "msg":    "OK"
    },
    "response": {
      "blog": {
        "title":          "Gunkatana",
        "name":           "gunkatana",
        "total_posts":    13,
        "posts":          13,
        "url":            "http://gunkatana.tumblr.com/",
        "updated":        1455328457,
        "description":    "desc",
        "is_nsfw":        false,
        "ask":            false,
        "ask_page_title": "Ask me anything",
        "ask_anon":       false,
        "share_likes":    false
      }
    }
  }
  """

  test "query the info endpoint", context do
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/gunkatana.tumblr.com/info" == conn.request_path
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Info.request(context.client, "gunkatana.tumblr.com")
  end

  test "provide the Tumblr API key as a query parameter", context do
    Bypass.expect context.bypass, fn conn ->
      assert "api_key=#{context.client.credentials.consumer_key}" == conn.query_string
      Plug.Conn.resp(conn, 200, @prebaked_response)
    end
    Info.request(context.client, "gunkatana.tumblr.com")
  end

  test "transform a successful response into an Info struct", context do
    Bypass.expect context.bypass, fn conn ->
      Plug.Conn.resp(conn, 200, @prebaked_response)
    end
    expected =
      %Info{
        title:                   "Gunkatana",
        name:                    "gunkatana",
        posts:                   13,
        updated:                 1455328457,
        description:             "desc",
        ask:                     false,
        ask_anon:                false,
        is_blocked_from_primary: false
      }
    assert Info.request(context.client, "gunkatana.tumblr.com") == expected
  end
end

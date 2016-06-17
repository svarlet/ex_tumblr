defmodule ExTumblr.FollowersTest do
  use ExTumblr.BypassSetupTemplate, async: true

  alias ExTumblr.{Client, Followers, Credentials}

  @prebaked_response """
  {
    "meta": {
      "status": 200,
      "msg": "OK"
    },
    "response": {
      "total_users": 2684,
      "users":  [
        {
          "name": "david",
          "following": true,
          "url": "http://www.davidslog.com",
          "updated": 1308781073
        },
        {
          "name": "ben",
          "following": true,
          "url": "http://bengold.tv",
          "updated": 1308841333
        }
      ]
    }
  }
  """

  should "send a get request to /v2/blog/gunkatana.tumblr.com/followers", context do
    Bypass.expect context.bypass, fn conn ->
      assert "GET" == conn.method
      assert "/v2/blog/gunkatana.tumblr.com/followers" == conn.request_path
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Followers.request(context.client, "gunkatana.tumblr.com", nil)
  end

  should "pass the params via the body of the request", context do
    Bypass.expect context.bypass, fn conn ->
      {_, body, _} = Plug.Conn.read_body(conn)
      assert body == "limit=5&offset=1"
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Followers.request(context.client, "gunkatana.tumblr.com", %{limit: 5, offset: 1})
  end

  # should "pass the oauth credentials via the headers of the request", context do
  #   Bypass.expect context.bypass, fn conn ->
  #     Plug.Conn.resp conn, 200, @prebaked_response
  #   end
  #   Followers.request("gunkatana.tumblr.com", context.credentials, nil)
  # end

  # should "parse it into a followers struct", context do
  #   Bypass.expect context.bypass, fn conn ->
  #     Plug.Conn.resp conn, 200, @prebaked_response
  #   end
  #   Followers.request("gunkatana.tumblr.com", context.credentials, nil)
  # end
end

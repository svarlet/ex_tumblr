defmodule ExTumblr.FollowersTest do
  use ShouldI, async: true

  alias ExTumblr.{Followers, Credentials}

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

  having "a successful connection" do
    setup context do
      bypass = Bypass.open
      Application.put_env(:ex_tumblr, :hostname, "http://localhost:#{bypass.port}")
      context
      |> assign(bypass: bypass)
      |> assign(credentials: %Credentials{consumer_secret: "ct", consumer_key: "ck", token: "t", token_secret: "ts"})
    end

    should "send a post request to /v2/blog/gunkatana.tumblr.com/followers", context do
      Bypass.expect context.bypass, fn conn ->
        assert "GET" == conn.method
        assert "/v2/blog/gunkatana.tumblr.com/followers" == conn.request_path
        Plug.Conn.resp conn, 200, @prebaked_response
      end
      Followers.request("gunkatana.tumblr.com", context.credentials, nil)
    end

    should "pass the params via the body of the request", context do
      Bypass.expect context.bypass, fn conn ->
        assert "limit=5&offset=1" == conn.body_params
        Plug.Conn.resp conn, 200, @prebaked_response
      end
      Followers.request("gunkatana.tumblr.com", context.credentials, %{limit: 5, offset: 1})
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
end

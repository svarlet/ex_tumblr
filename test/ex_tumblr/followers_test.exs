defmodule ExTumblr.FollowerTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Follower

  test "parsing a string->any map test populate a Follower struct" do
    raw_map = %{
      "name" => "seb",
      "following" => true,
      "url" => "dummy_url",
      "updated" => 424242
    }
    assert %Follower{name: "seb", following: true, url: "dummy_url", updated: 424242} == Follower.parse(raw_map)
  end
end

defmodule ExTumblr.FollowersTest do
  use ExTumblr.BypassSetupTemplate, async: true

  alias ExTumblr.{Client, Follower, Followers, Credentials}

  @prebaked_response """
  {
    "meta": {
      "status": 200,
      "msg": "OK"
    },
    "response": {
      "total_users": 2,
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

  test "send a get request to /v2/blog/gunkatana.tumblr.com/followers", context do
    Bypass.expect context.bypass, fn conn ->
      assert "GET" == conn.method
      assert "/v2/blog/gunkatana.tumblr.com/followers" == conn.request_path
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Followers.request(context.client, "gunkatana.tumblr.com", nil)
  end

  test "pass the params via the body of the request", context do
    Bypass.expect context.bypass, fn conn ->
      {_, body, _} = Plug.Conn.read_body(conn)
      assert body == "limit=5&offset=1"
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Followers.request(context.client, "gunkatana.tumblr.com", %{limit: 5, offset: 1})
  end

  test "pass the oauth credentials via the headers of the request", context do
    Bypass.expect context.bypass, fn conn ->
      oauth_headers = Plug.Conn.get_req_header(conn, "authorization")
      refute oauth_headers in [nil, []]
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Followers.request(context.client, "gunkatana.tumblr.com", nil)
  end

  test "parse the http response into a followers struct", context do
    Bypass.expect context.bypass, fn conn ->
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    followers = Followers.request(context.client, "gunkatana.tumblr.com", nil)
    assert followers == %Followers{
      total_users: 2,
      users: [
        %Follower{
          name: "david",
          following: true,
          url: "http://www.davidslog.com",
          updated: 1308781073
        },
        %Follower{
          name: "ben",
          following: true,
          url: "http://bengold.tv",
          updated: 1308841333
        }
      ]
    }
  end

  @prebaked_empty_response """
  {
    "meta": {
      "status": 200,
      "msg": "OK"
    },
    "response": {
      "total_users": 0,
      "users":  []
    }
  }
  """

  test "handle successfully a successful response containing 0 followers", context do
    Bypass.expect context.bypass, fn conn ->
      Plug.Conn.resp conn, 200, @prebaked_empty_response
    end
    followers = Followers.request(context.client, "gunkatana.tumblr.com", nil)
    assert followers == %Followers{total_users: 0, users: []}
  end
end

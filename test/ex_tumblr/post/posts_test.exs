defmodule ExTumblr.PostsTest do
  use ExTumblr.BypassSetupTemplate, async: true

  alias ExTumblr.Post.Posts

  setup_all do
    {:ok, prebaked_response: File.read!(Path.join(__DIR__, "posts.json"))}
  end

  test "sends a GET request", context do
    Bypass.expect context.bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp conn, 200, context.prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "specifies the api key in the query", context do
    Bypass.expect context.bypass, fn conn ->
      assert "api_key=ck" == conn.query_string
      Plug.Conn.resp conn, 200, context.prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "emits request to the right path", context do
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/peacecorps.tumblr.com/posts" == conn.request_path
      Plug.Conn.resp conn, 200, context.prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "parses the http response into a Posts struct", context do
    Bypass.expect context.bypass, fn conn ->
      Plug.Conn.resp conn, 200, context.prebaked_response
    end
    %Posts{blog: blog, posts: posts, total_posts: total_posts} = Posts.request(context.client, "peacecorps.tumblr.com", nil)
    assert blog != nil
    assert Enum.count(posts) == 20
    assert total_posts == 3156
  end
end

defmodule ExTumblr.PostTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Post

  test "parse/1 can transform a generic map into a Post struct" do
    raw_map = %{
      "blog_name"    => "name",
      "id"           => 23,
      "post_url"     => "url",
      "type"         => "type",
      "timestamp"    => 42,
      "date"         => "2015-05-23",
      "format"       => "text",
      "reblog_key"   => "abcedf",
      "tags"         => ~w(tag1 tag2 tag3),
      "bookmarklet"  => true,
      "mobile"       => true,
      "source_url"   => "http://localhost/source",
      "source_title" => "title",
      "liked"        => true,
      "state"        => "published",
      "total_posts"  => 456
    }

    expected = %Post{
      blog_name:     "name",
      id:            23,
      post_url:      "url",
      type:          "type",
      timestamp:     42,
      date:          "2015-05-23",
      format:        "text",
      reblog_key:    "abcedf",
      tags:          ~w(tag1 tag2 tag3),
      bookmarklet:   true,
      mobile:        true,
      source_url:    "http://localhost/source",
      source_title:  "title",
      liked:         true,
      state:         "published",
      total_posts:   456
    }

    assert expected == Post.parse(raw_map)
  end
end

defmodule ExTumblr.PostsTest do
  use ExTumblr.BypassSetupTemplate, async: true

  alias ExTumblr.Posts

  @prebaked_response File.read!(Path.join(__DIR__, "posts.json"))

  test "sends a GET request", context do
    Bypass.expect context.bypass, fn conn ->
      assert "GET" == conn.method
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "specifies the api key in the query", context do
    Bypass.expect context.bypass, fn conn ->
      assert "api_key=ck" == conn.query_string
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "emits request to the right path", context do
    Bypass.expect context.bypass, fn conn ->
      assert "/v2/blog/peacecorps.tumblr.com/posts" == conn.request_path
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    Posts.request(context.client, "peacecorps.tumblr.com", nil)
  end

  test "parses the http response into a Posts struct", context do
    Bypass.expect context.bypass, fn conn ->
      Plug.Conn.resp conn, 200, @prebaked_response
    end
    %Posts{blog: blog, posts: posts, total_posts: total_posts} = Posts.request(context.client, "peacecorps.tumblr.com", nil)
    assert blog != nil
    assert Enum.count(posts) == 20
    assert total_posts == 3156
  end
end

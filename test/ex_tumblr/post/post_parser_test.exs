defmodule ExTumblr.Post.PostParserTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Post.{PostParser, TextPost, PhotoPost}
  alias ExTumblr.Post.{PhotoItem, PhotoMeta}

  setup_all do
    {:ok, raw_post: %{
        "blog_name" => "peacecorps",
        "id" => 147097203944,
        "post_url" => "the url",
        "slug" => "food-friday-banana-chips-thailand",
        "date" => "2016-07-08 16:00:27 GMT",
        "timestamp" => 1467993627,
        "state" => "published",
        "format" => "html",
        "reblog_key" => "FYNz6ReV",
        "tags" => ["food friday", "thailand"],
        "short_url" => "https://tmblr.co/ZtR4Sx28-hJJe",
        "summary" => "Food Friday: Banana chips (Thailand)"
     }
    }
  end

  test "parse/1 can parse a text post", context do
    expected = %TextPost{
      blog_name: "peacecorps",
      id: 147097203944,
      post_url: "the url",
      type: "text",
      date: "2016-07-08 16:00:27 GMT",
      timestamp: 1467993627,
      state: "published",
      format: "html",
      reblog_key: "FYNz6ReV",
      tags: ["food friday", "thailand"],
      title: "Food Friday: Banana chips (Thailand)",
      body: "the body"
    }
    actual =
      context.raw_post
      |> Map.put_new("type", "text")
      |> Map.put_new("title", "Food Friday: Banana chips (Thailand)")
      |> Map.put_new("body", "the body")
      |> PostParser.parse

    assert expected == actual
  end

end

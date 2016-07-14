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

  test "parse/1 can parse a photo post", context do
    the_photos = [
      %PhotoItem{
        caption: "Las Vegas 2014",
        original_size: %PhotoMeta{width: 400, height: 800, url: "url_original"},
        alt_sizes: [
          %PhotoMeta{width: 800, height: 1600, url: "url_800x1600"},
          %PhotoMeta{width: 1600, height: 3200, url: "url_1600x3200"}
        ]
      },
      %PhotoItem{
        caption: "San Francisco 2014",
        original_size: %PhotoMeta{width: 100, height: 200, url: "url_original"},
        alt_sizes: [
          %PhotoMeta{width: 200, height: 400, url: "url_200x400"},
          %PhotoMeta{width: 400, height: 800, url: "url_400x800"}
        ]
      }
    ]

    unparsed_photos = [
      %{
        "caption" => "Las Vegas 2014",
        "original_size" => %{"width" => 400, "height" => 800, "url" => "url_original"},
        "alt_sizes" => [
          %{"width" => 800, "height" => 1600, "url" => "url_800x1600"},
          %{"width" => 1600, "height" => 3200, "url" => "url_1600x3200"}
        ]
      },
      %{
        "caption" => "San Francisco 2014",
        "original_size" => %{"width" => 100, "height" => 200, "url" => "url_original"},
        "alt_sizes" => [
          %{"width" => 200, "height" => 400, "url" => "url_200x400"},
          %{"width" => 400, "height" => 800, "url" => "url_400x800"}
        ]
      }
    ]

    expected = %PhotoPost{
      blog_name: "peacecorps",
      id: 147097203944,
      post_url: "the url",
      type: "photo",
      date: "2016-07-08 16:00:27 GMT",
      timestamp: 1467993627,
      state: "published",
      format: "html",
      reblog_key: "FYNz6ReV",
      tags: ["food friday", "thailand"],
      photos: the_photos
    }
    actual =
      context.raw_post
      |> Map.put_new("type", "photo")
      |> Map.put_new("photos", the_photos)
      |> PostParser.parse
    assert expected == actual
  end
end

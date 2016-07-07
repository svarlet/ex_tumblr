defmodule ExTumblr.Post.CommonPostDataTest do
  use ExUnit.Case, async: true

  alias ExTumblr.Post.CommonPostData

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
      "state"        => "published"
    }

    expected = %CommonPostData{
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
      state:         "published"
    }

    assert expected == CommonPostData.parse(raw_map)
  end
end

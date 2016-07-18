defmodule ExTumblr.Post.PhotoMetaTest do
  use ExUnit.Case, async: true
  use ExCheck
  doctest ExTumblr.Post.PhotoMeta

  alias ExTumblr.Post.PhotoMeta

  property "parse the width, height and url key-values" do
    for_all {width, height, url} in {non_neg_integer(), non_neg_integer(), unicode_string()} do
      unparsed_photo_meta = %{
        "width" => width,
        "height" => height,
        "url" => url
      }
      unparsed_photo_meta ==
        unparsed_photo_meta
        |> PhotoMeta.parse
        |> Poison.encode!
        |> Poison.decode!
    end
  end
end

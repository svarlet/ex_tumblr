defmodule ExTumblr.Post.PhotoMetaTest do
  use ExUnit.Case, async: true
  use ExCheck
  doctest ExTumblr.Post.PhotoMeta

  alias ExTumblr.Post.PhotoMeta

  property "parse the width, height and url key-values" do
    for_all unparsed_photo_meta in photo_meta_map_gen do
      unparsed_photo_meta ==
        unparsed_photo_meta
        |> PhotoMeta.parse
        |> Poison.encode!
        |> Poison.decode!
    end
  end

  def photo_meta_map_gen do
    domain(
      PhotoMeta,
      fn (self, size) ->
        {_, width} = pick(non_neg_integer, size)
        {_, height} = pick(non_neg_integer, size)
        {_, url} = pick(unicode_binary, size)
        generation = %{"width" => width, "height" => height, "url" => url}
        {self, generation}
      end,
      fn
        (self, %{"width" => w} = value) when w > 0 -> {self, %{value | "width" => w - 1}}
        (self, %{"height" => h} = value) when h > 0 -> {self, %{value | "height" => h - 1}}
        (self, %{"url" => ""} = value) -> {self, %{value | "url" => nil}}
        (self, %{"url" => nil} = value) -> {self, value}
        (self, %{"url" => url} = value) -> {self, %{value | "url" => String.slice(url, 0..-2)}}
        (self, value) -> {self, value}
      end
    )
  end
end

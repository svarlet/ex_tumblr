defmodule ExTumblr.Post.PhotoItemTest do
  use ExUnit.Case, async: true
  use PropCheck

  alias ExTumblr.Post.PhotoItem

  defp url_gen, do: elements ["url1", "url2"]

  defp photo_meta_gen do
    let [width, height, url] <- [nat, nat, url_gen] do
      %{"width" => width,
        "height" => height,
        "url" => url}
    end
  end

  defp caption_gen, do: elements ["", "caption"]

  defp photo_item_gen do
    let [caption, original_size, alt_sizes] <- [caption_gen, photo_meta_gen, list(photo_meta_gen)] do
      %{"caption" => caption,
        "original_size" => original_size,
        "alt_sizes" => alt_sizes}
    end
  end

  property "all properties are parsed" do
    forall raw_photo_item <- photo_item_gen do
      photo_item =
        raw_photo_item
        |> PhotoItem.parse

      # if any property is not/badly parsed, we will find out by reencoding
      # to JSON, decoding and comparing to the generated value.
      raw_photo_item ==
        photo_item
        |> Poison.encode!
        |> Poison.decode!
    end
  end

end
